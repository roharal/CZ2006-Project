import 'package:exploresg/screens/base.dart';
import 'package:exploresg/screens/home.dart';
import 'package:exploresg/screens/splash.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        SplashScreen.routeName: (context) => SplashScreen(),
        BaseScreen.routeName: (context) => BaseScreen(),

      },
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
