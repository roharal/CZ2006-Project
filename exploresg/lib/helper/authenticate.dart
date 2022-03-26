import 'package:flutter/material.dart';

import 'package:exploresg/screens/login.dart';
import 'package:exploresg/screens/signup.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;
  void toggleView(){
    //print(showSignIn.toString());
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return LoginScreen();
    } else {
      return SignUpScreen();
    }
  }
}