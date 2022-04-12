import 'package:exploresg/helper/auth_controller.dart';
import 'package:exploresg/helper/google_sign_it.dart';
import 'package:exploresg/screens/base.dart';
import 'package:exploresg/screens/forgotpassword.dart';
import 'package:exploresg/screens/interests_ui.dart';
import 'package:exploresg/screens/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  AuthController _authController = AuthController();
  GoogleSignInProvider _googleSignInProvider = GoogleSignInProvider();

  Widget _topBar(double width) {
    return FittedBox(
        fit: BoxFit.fill,
        child: SvgPicture.asset('assets/img/login-top.svg',
            width: width, height: width));
  }

  Widget _login(double width, double height) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      width: width - 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          textMajor("sign in", Color(0xff22254C), 36),
          SizedBox(height: 10),
          _loginForm(),
          SizedBox(height: 30),
          _progressButton(width, height),
          SizedBox(height: 5),
          _useUsernameOrEmail(),
        ],
      ),
    );
  }

  Widget _signupLabel() {
    return InkWell(
      onTap: () {
        Navigator.pushReplacementNamed(context, SignUpScreen.routeName);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          textMinor("don't have an account?", Color(0xff22254C)),
          SizedBox(
            width: 5,
          ),
          textMinor("sign up", Color(0xff6488E5)),
        ],
      ),
    );
  }

  Widget _loginButton(double width, double height) {
    return SizedBox(
      width: width,
      height: height * 0.05,
      child: ElevatedButton(
        onPressed: _validateLogin,
        child: textMinor("sign in", Colors.white),
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            primary: Color(0xff6488E5),
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
      ),
    );
  }

  Widget _progressButton(double width, double height) {
    return Container(
      width: width * 0.6,
      height: height * 0.05,
      child: _isLoading ? Container(
        color: Colors.white,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ) : _loginButton(width, height),
    );
  }

  Widget _emailTextField() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: TextFormField(
        obscureText: false,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "email",
          hintStyle: TextStyle(
            color: Color(0xffD1D1D6),
          ),
          icon: Icon(
            Icons.email,
            color: Color(0xffD1D1D6),
          ),
        ),
        style: TextStyle(
          fontFamily: 'AvenirLtStd',
          color: Color(0xff22254C),
          fontSize: 14,
        ),
        keyboardType: TextInputType.emailAddress,
        validator: _validateEmail,
        onSaved: (String? saved) {
          _email = saved!.trim();
        },
      ),
    );
  }

  Widget _passwordTextField() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "password",
          hintStyle: TextStyle(
            color: Color(0xffD1D1D6),
          ),
          icon: Icon(
            Icons.lock,
            color: Color(0xffD1D1D6),
          ),
        ),
        style: TextStyle(
          fontFamily: 'AvenirLtStd',
          color: Color(0xff22254C),
          fontSize: 14,
        ),
        keyboardType: TextInputType.text,
        validator: _validatePassword,
        onSaved: (String? saved) {
          _password = saved!;
        },
      ),
    );
  }

  Widget _usernameTextField() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: TextFormField(
        obscureText: false,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "username",
          hintStyle: TextStyle(
            color: Color(0xffD1D1D6),
          ),
          icon: Icon(
            Icons.alternate_email,
            color: Color(0xffD1D1D6),
          ),
        ),
        style: TextStyle(
          fontFamily: 'AvenirLtStd',
          color: Color(0xff22254C),
          fontSize: 14,
        ),
        keyboardType: TextInputType.text,
        validator: _validateUsername,
        onSaved: (saved) {
          _username = saved!.trim().toLowerCase();
        },
      ),
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
            textMinor("login using", Color(0xff22254C)),
            SizedBox(
              width: 5,
            ),
            _useEmail
                ? textMinor("username", Color(0xff6488E5))
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
        Navigator.pushReplacementNamed(context, ForgotPasswordScreen.routeName);
      },
      child: textMinor("forgot my password", Color(0xff6488E5)),
    );
  }

  Widget _googleRegisterButton(double width, double height) {
    return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            primary: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
        onPressed: () async {
          var result =
              await _googleSignInProvider.googleLogin(context: context);
          if (result != null) {
            var bool = await _authController.checkUserExist(result.uid);
            if (!bool) {
              var error = await _authController.createUserFromGoogleSignIn(result);
              if (error != null) {
                showAlert(context, "Google Sign In Error", error);
              } else {
                Navigator.pushReplacementNamed(context, InterestScreen.routeName, arguments: InterestScreenArguments(result.uid,""));
              }
            } else {
              Navigator.pushReplacementNamed(context, BaseScreen.routeName);
            }
          }
        },
        icon: Image.asset(
          "assets/img/google_logo.png",
          width: 25,
          height: 25,
        ),
        label: textMinor('sign in with google', Color(0xff22254C)));
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password cannot be empty";
    } else if (value.length < 8) {
      return "Password must contain at least 8 characters";
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
    var result = await _authController.signInEmail(email, password);
    if (result is User) {
      Navigator.pushReplacementNamed(context, BaseScreen.routeName);
    } else {
      showAlert(context, "Login Error (1)", result.split("]")[1]);
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _usernameLogin() async {
    String uid = await _authController.getUidfromUsername(_username);
    if (uid != "notFound") {
      await _authController.getUserFromId(uid).then((value) {
        _emailLogin(value["email"], _password);
      }).onError((error, stackTrace) {
        print(stackTrace);
        showAlert(context, "User error (1)", error.toString());
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      showAlert(context, "User error (2)", "Username or password incorrect");
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
              Positioned(child: _topBar(_width)),
              Positioned(
                top: _height * 0.25,
                child: Column(
                  children: [
                    _login(_width, _height),
                    SizedBox(height: 10),
                    _googleRegisterButton(_width, _height),
                    SizedBox(height: 10),
                    _signupLabel(),
                    SizedBox(height: 10),
                    _forgotPassword(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
