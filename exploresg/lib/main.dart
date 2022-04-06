import 'package:exploresg/screens/base.dart';
import 'package:exploresg/screens/login.dart';
import 'package:exploresg/screens/signup.dart';
import 'package:exploresg/screens/splash.dart';
import 'package:exploresg/screens/verify.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:exploresg/screens/interests.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        LoginScreen.routeName: (context) => LoginScreen(),
        SignUpScreen.routeName: (context) => SignUpScreen(),
        InterestScreen.routeName: (context) => InterestScreen(),
        VerifyScreen.routeName: (context) => VerifyScreen()
      },
      onGenerateRoute: (RouteSettings settings) {
        assert(false, 'Need to implement ${settings.name}');
        return null;
      },
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
