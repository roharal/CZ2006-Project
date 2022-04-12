import 'package:exploresg/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:exploresg/helper/utils.dart';
import 'package:flutter_svg/svg.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const routeName = "/forgetPW";

  @override
  State<ForgotPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgotPasswordScreen> {
  final auth = FirebaseAuth.instance;
  late String _email;
  final _emailKey = GlobalKey<FormState>();

  Widget _topBar(double width) {
    return FittedBox(
        fit: BoxFit.fill,
        child: SvgPicture.asset('assets/img/login-top.svg',
            width: width, height: width));
  }

  Widget _returnLogin() {
    return GestureDetector(
      child: textMinor('return to login page', Color(0xff6488E5)),
      onTap: () {
        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      },
    );
  }

  Widget _resetPassword(double width, double height) {
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
          textMajor("reset password", Color(0xff22254C), 30),
          SizedBox(height: 30),
          _emailForm(),
          _sendRequest()
        ],
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
        onChanged: (String? saved) {
          _email = saved!.trim();
        },
      ),
    );
  }

  Widget _emailForm() {
    return Form(
        key: _emailKey,
        child: Container(
          child: _emailTextField(),
        ));
  }

  Widget _sendRequest() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))),
          onPressed: () {
            _validate();
          },
          child: textMinor(
            'send request',
            Color(0xff6488E5),
          ),
        ),
      ],
    );
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

  void _validate() {
    if (_emailKey.currentState!.validate()) {
      _emailKey.currentState!.save();
      setState(() {
        auth.sendPasswordResetEmail(email: _email);
        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      });
    }
  }

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
                top: _height * 0.3,
                child: Column(
                  children: [
                    _resetPassword(_width, _height),
                    SizedBox(height: 20),
                    _returnLogin(),
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
