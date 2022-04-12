import 'dart:async';

import 'package:exploresg/helper/auth_controller.dart';
import 'package:exploresg/screens/base.dart';
import 'package:exploresg/screens/login.dart';
import 'package:flutter/material.dart';

import '../helper/utils.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = "/splash";

  @override
  State<StatefulWidget> createState() {
    return _SplashScreen();
  }
}

class _SplashScreen extends State<SplashScreen> {
  AuthController _auth = AuthController();

  @override
  void initState() {
    super.initState();
    _timer();
  }

  Future<Timer> _timer() async {
    var d = Duration(seconds: 3);
    return Timer(d, _homePage);
  }

  void _homePage() {
    var user = _auth.getCurrentUser();
    if (user != null) {
      Navigator.pushReplacementNamed(context, BaseScreen.routeName);
    } else {
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        child: Stack(
          children: [
            Image.asset('assets/img/splash.png',
                height: height, width: width, fit: BoxFit.fill),
            Positioned(
              top: height / 4,
              left: width / 4.5,
              child: textMajor("explore", Color(0xff22254C), 36),
            ),
            Positioned(
                top: height / 3.5,
                left: width / 2.2,
                child: textMajor("SG", Color(0xff22254C), 36)),
            Positioned(
              top: height / 2.9,
              left: width / 4.5,
              child: SizedBox(
                width: width / 1.8,
                child: textMinor(
                    "discover new places and invite your friends to go together!",
                    Color(0xff22254C)),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    textMinor("Copyright HDMILF 2022", Color(0xff22254C)),
                    textMinor("All rights reserved", Color(0xff22254C))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
