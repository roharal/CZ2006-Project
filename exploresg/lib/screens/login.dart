import 'package:exploresg/helper/firebase_api.dart';
import 'package:exploresg/screens/base.dart';
import 'package:exploresg/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../helper/utils.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  late String _username, _password, _email;
  bool _isLoading = false, _useEmail = false;
  final _loginKey = GlobalKey<FormState>();
  FirebaseApi _firebaseApi = FirebaseApi();

  Widget _topBar(double width, double height) {
    return FittedBox(
        fit: BoxFit.fill,
        child: SvgPicture.asset('assets/img/login-top.svg',
          width: width,
          height: height * 0.4,
        )
    );
  }

  Widget _login(double width, double height) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      width: width - 80,
      height: height * 0.5,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 25),
            textMajor("sign in", Colors.black, 36),
            SizedBox(height: 30),
            _loginForm(),
            SizedBox(height: 30),
            _progressButton(width, height),
            SizedBox(height: 5),
            _useUsernameOrEmail(),
            SizedBox(height: 20,),
            _forgotPassword()
          ]
      ),
    );
  }

  Widget _loginLabel() {
    return InkWell(
      onTap: () {
        Navigator.pushReplacementNamed(context, SignUpScreen.routeName);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          textMinor("don't have an account?", Colors.black),
          SizedBox(width: 5,),
          textMinor("sign up", createMaterialColor(Color(0xff6488E5)))
        ],
      ),
    );
  }

  Widget _loginButton(double width, double height) {
    return SizedBox(
      width: width,
      height:  height * 0.05,
      child: ElevatedButton(
        onPressed: _validateLogin,
        child: textMinor("Login", Colors.white),
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            primary: Color(0xff6488E5),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
        ),
      ),
    );
  }

  Widget _progressButton(double width, double height) {
    return Container(
      width: width * 0.6,
      height: height * 0.05,
      child: _isLoading ? progressionIndicator() : _loginButton(width, height),
    );
  }

  Widget _emailTextField() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        child: TextFormField(
          obscureText: false,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Email",
            prefixIcon: Icon(Icons.email),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: _validateEmail,
          onSaved: (String? saved) {
            _email = saved!.trim();
          },
        )
    );
  }

  Widget _passwordTextField() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        child: TextFormField(
          obscureText: true,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Password",
            prefixIcon: Icon(Icons.lock),
          ),
          keyboardType: TextInputType.text,
          validator: _validatePassword,
          onSaved: (String? saved) {
            _password = saved!;
          },
        )
    );
  }

  Widget _usernameTextField() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        child: TextFormField(
          obscureText: false,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Username",
            prefixIcon: Icon(Icons.alternate_email),
          ),
          keyboardType: TextInputType.text,
          validator: _validateUsername,
          onSaved: (saved) {
            _username = saved!.trim().toLowerCase();
          },
        )
    );
  }

  Widget _useUsernameOrEmail() {
    return InkWell(
      onTap: () {
        setState(() {
          _useEmail = !_useEmail;
        });
      },
      child: Container(
        padding: EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            textMinor("Login using", Colors.black),
            SizedBox(
              width: 5,
            ),
            _useEmail ? textMinor("username", Color(0xff6488E5))
                : textMinor("email", Color(0xff6488E5))
          ],
        ),
      ),
    );
  }

  Widget _loginForm() {
    return Form(
      key: _loginKey,
      child: Column(
        children: <Widget>[
          _useEmail ? _emailTextField() : _usernameTextField(),
          _passwordTextField(),
        ],
      ),
    );
  }

  Widget _forgotPassword() {
    return InkWell(
      onTap: () {
        print("forget password shit");
      },
      child: textMinor("forgot my password", Color(0xff6488E5)),
    );
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password cannot be empty";
    } else if (value.length < 8) {
      return "Password must contain at least 6 characters";
    }
    return null;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return "Username cannot be empty";
    }
    return null;
  }

  String? _validateEmail(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value == null || value.isEmpty) {
      return "Email cannot be empty";
    } else if (!regex.hasMatch(value))
      return 'Enter a valid email';
    else
      return null;
  }

  void _validateLogin() {
    if (_loginKey.currentState!.validate()) {
      _loginKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      if (_useEmail) {
        _emailLogin(_email, _password);
      } else {
        _usernameLogin();
      }
    }
  }

  void _emailLogin(String email, String password) async {
    await _firebaseApi.loginUsingEmail(email, password).then((value) {
      setState(() {
        _isLoading = false;
        if (value == null) {
          print("user login");
          Navigator.pushReplacementNamed(context, BaseScreen.routeName);
        } else {
          showAlert(context, "Login Error (1)", value);
        }
      });
    }).onError((error, stackTrace) {
      showAlert(context, "Login Error (2)", error.toString());
    });
  }

  void _usernameLogin() async {
    String uid = await _firebaseApi.getUidfromUsername(_username);
    if (uid != "notFound") {
      await _firebaseApi.getDocumentByIdFromCollection("users", uid).then((value) {
        _emailLogin(value["email"], _password);
      }).onError((error, stackTrace) {
        print(stackTrace);
        showAlert(context, "User error", error.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Color(0xfffffcec),
        body: SingleChildScrollView(
          child: Container(
            height: _height - 20,
            child: Stack(
              children: [
                Positioned(child: _topBar(_width, _height)),
                Positioned(
                  top: _height * 0.25,
                  child: _login(_width, _height),
                ),
                Positioned(
                  right: 0,
                  left: 0,
                  bottom: _height * 0.05,
                  child: _loginLabel(),
                )
              ],
            ),
          ),
        )
    );
  }
}
