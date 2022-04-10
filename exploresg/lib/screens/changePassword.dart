import 'package:flutter/material.dart';
import 'package:exploresg/helper/utils.dart';
import 'package:flutter_svg/svg.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordArguments {
  final String email;

  ChangePasswordArguments(this.email);
}

class ChangePasswordScreen extends StatefulWidget {
  static const routeName = "/changePW";
  final String email;

  ChangePasswordScreen(this.email);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final auth = FirebaseAuth.instance;
  late String _email;

  Widget _topBar(double width) {
    return FittedBox(
        fit: BoxFit.fill,
        child: SvgPicture.asset('assets/img/login-top.svg',
            width: width, height: width));
  }

  Widget _returnLogin() {
    return GestureDetector(
      child: textMinor('return to profile', Color(0xff6488E5)),
      onTap: () {
        Navigator.pop(context);
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
        // _emailTextField(),
        _sendRequest()
      ]),
    );
  }

  // Widget _emailTextField() {
  //   return Container(
  //       padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
  //       child: TextFormField(
  //         obscureText: false,
  //         decoration: InputDecoration(
  //           border: InputBorder.none,
  //           hintText: "email",
  //           hintStyle: TextStyle(
  //             color: Color(0xffD1D1D6),
  //           ),
  //           icon: Icon(
  //             Icons.email,
  //             color: Color(0xffD1D1D6),
  //           ),
  //         ),
  //         style: TextStyle(
  //           fontFamily: 'AvenirLtStd',
  //           color: Color(0xff22254C),
  //           fontSize: 14,
  //         ),
  //         keyboardType: TextInputType.emailAddress,
  //         validator: _validateEmail,
  //         onChanged: (String? saved) {
  //           _email = saved!.trim();
  //         },
  //       ));
  // }

  Widget _sendRequest() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20))),
          onPressed: () {
            print(widget.email);
            // auth.sendPasswordResetEmail(email: widget.email);
            // Navigator.pop(context);
          },
          child: textMinor(
            'reset my password',
            Color(0xff6488E5),
          ))
    ]);
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
          )),
    );
  }
}
