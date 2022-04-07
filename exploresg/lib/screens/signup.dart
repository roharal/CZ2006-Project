import 'package:exploresg/helper/utils.dart';
import 'package:exploresg/models/user.dart';
import 'package:exploresg/screens/login.dart';
import 'package:exploresg/screens/verify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:exploresg/helper/firebase_api.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = "/signUp";

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  FirebaseApi _firebaseApi = FirebaseApi();
  final _registerKey = GlobalKey<FormState>();
  bool _isLoading = false, _isChecked = false;
  late bool _isTaken;
  static final validUsername = RegExp(r'^[a-zA-Z0-9]+$');
  late String _email, _password, _username, _first, _last;

  Widget _topBar(double width) {
    return FittedBox(
        fit: BoxFit.fill,
        child: SvgPicture.asset('assets/img/login-top.svg',
            width: width, height: width
            //height: height * 0.4,
            ));
  }

  Widget _firstTextField() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: TextFormField(
        obscureText: false,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'first name',
          hintStyle: TextStyle(
            color: Color(0xffD1D1D6),
          ),
          icon: Icon(
            Icons.account_circle,
            color: Color(0xffD1D1D6),
          ),
        ),
        style: TextStyle(
          fontFamily: 'AvenirLtStd',
          color: Color(0xff22254C),
          fontSize: 14,
        ),
        validator: _validateName,
        onSaved: (String? saved) {
          _first = saved!.trim();
        },
      ),
    );
  }

  Widget _lastTextField() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: TextFormField(
        obscureText: false,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "last name",
          hintStyle: TextStyle(
            color: Color(0xffD1D1D6),
          ),
          icon: Icon(
            Icons.account_circle,
            color: Color(0xffD1D1D6),
          ),
        ),
        style: TextStyle(
          fontFamily: 'AvenirLtStd',
          color: Color(0xff22254C),
          fontSize: 14,
        ),
        validator: _validateName,
        onSaved: (String? saved) {
          _last = saved!.trim();
        },
      ),
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
        ));
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
        ));
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
          onChanged: (value) {
            if (_isChecked) {
              setState(() {
                _isChecked = false;
              });
            }
            _username = value.trim().toLowerCase();
          },
          onSaved: (String? saved) {
            _username = saved!.trim().toLowerCase();
          },
        ));
  }

  Widget _registerForm() {
    return Form(
      key: _registerKey,
      child: Column(
        children: <Widget>[
          _usernameTextField(),
          _firstTextField(),
          _lastTextField(),
          _emailTextField(),
          _passwordTextField(),
        ],
      ),
    );
  }

  Widget _signUp(double width, double height) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      width: width - 80,
      // height: height * 0.65,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        //SizedBox(height: 25),
        textMajor("sign up", Color(0xff22254C), 36),
        SizedBox(height: 10),
        _registerForm(),
        SizedBox(height: 30),
        _progressButton(width, height)
      ]),
    );
  }

  Widget _loginLabel() {
    return InkWell(
      onTap: () {
        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          textMinor("already have an account?", Color(0xff22254C)),
          SizedBox(
            width: 5,
          ),
          textMinor("sign in", createMaterialColor(Color(0xff6488E5)))
        ],
      ),
    );
  }

  Widget _registerButton(double width, double height) {
    return ElevatedButton(
      onPressed: _isChecked ? _validateRegister : _validateUsername,
      child: _isChecked
          ? textMinor("register", Colors.white)
          : textMinor("check username", Colors.white),
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          primary: Color(0xff6488E5),
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
    );
  }

  Widget _progressButton(double width, double height) {
    return Container(
      width: width * 0.6,
      height: height * 0.05,
      child:
          _isLoading ? progressionIndicator() : _registerButton(width, height),
    );
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Name cannot be empty";
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password cannot be empty";
    } else if (value.length < 8) {
      return "Password must contain at least 8 characters";
    }
    return null;
  }

  String? _validateEmail(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return "Email cannot be empty";
    } else if (!regex.hasMatch(value))
      return 'Enter a valid email';
    else
      return null;
  }

  void _validateUsername() async {
    if (!validUsername.hasMatch(_username)) {
      showAlert(context, "Invalid username",
          "Username cannot contain special characters!");
    } else if (_username.isEmpty) {
      showAlert(context, "Invalid username", "Username cannot be empty!");
    } else if (_username.length < 4) {
      showAlert(context, "Invalid username",
          "Username cannot be less than 4 characters!");
    } else {
      await _firebaseApi.getUidfromUsername(_username).then((value) {
        if (value == "notFound") {
          _isTaken = false;
        } else {
          _isTaken = true;
        }
        setState(() {
          _isChecked = !_isTaken;
          if (_isTaken) {
            showAlert(context, "Username taken",
                "Change to another unique username!");
          } else {
            showAlert(
                context, "Congratulation!", "The username is yours to take!");
          }
        });
      });
    }
  }

  void _validateRegister() {
    if (_isChecked && !_isTaken) {
      if (_registerKey.currentState!.validate()) {
        _registerKey.currentState!.save();
        setState(() {
          _isLoading = true;
        });
        _createUser();
      }
    }
  }

  void _createUser() async {
    UserModel user = UserModel("", _username, _first, _last, _email, "", "", "",

        false, false, "shopping_mall,cafe,park", "");

    await _firebaseApi.createUserFromEmail(user, _password).then((value) {
      setState(() {
        _isLoading = false;
      });
      if (value == null) {
        print("user created");
        Navigator.pushReplacementNamed(context, VerifyScreen.routeName);
      } else {
        showAlert(context, "Sign Up Error", value.toString());
      }
    });
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
                top: _height * 0.2,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    _signUp(_width, _height),
                    SizedBox(
                      height: 10,
                    ),
                    _loginLabel()
                  ],
                ),
              ),
            ],
          ),
        )));
  }
}
