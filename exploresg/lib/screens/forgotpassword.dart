import 'package:exploresg/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:exploresg/helper/utils.dart';
import 'package:flutter_svg/svg.dart';

class ForgotPasswordPage extends StatefulWidget {
  static const routeName = "/forgetPW";
  @override
  State<ForgotPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgotPasswordPage> {
  Widget _topBar(double width) {
    return FittedBox(
        fit: BoxFit.fill,
        child: SvgPicture.asset(
          'assets/img/login-top.svg',
          width: width,
        ));
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
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        textMajor("reset password", Color(0xff22254C), 30),
        SizedBox(height: 30),
        textMinor('type your email', Color(0xff6488E5)),
        SizedBox(height: 10),
        _emailTextField()
      ]),
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
        ));
  }

  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Color(0xfffffcec),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(child: _topBar(_width)),
                  Positioned(
                    top: _height * 0.25,
                    child: _resetPassword(_width, _height),
                  ),
                ],
              ),
              SizedBox(height: _height * 0.28),
              _returnLogin()
            ],
          ),
        ));
  }
}