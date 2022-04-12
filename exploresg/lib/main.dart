import 'package:exploresg/screens/base.dart';
import 'package:exploresg/screens/forgotpassword.dart';
import 'package:exploresg/screens/login.dart';
import 'package:exploresg/screens/signup.dart';
import 'package:exploresg/screens/splash.dart';
import 'package:exploresg/screens/verify.dart';
import 'package:exploresg/theme/theme_constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:exploresg/screens/interests_ui.dart';
import 'package:flutter/material.dart';
import 'package:exploresg/screens/changePassword.dart';

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
      theme: appTheme,
      initialRoute: '/',
      routes: {
        SplashScreen.routeName: (context) => SplashScreen(),
        BaseScreen.routeName: (context) => BaseScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        SignUpScreen.routeName: (context) => SignUpScreen(),
        VerifyScreen.routeName: (context) => VerifyScreen(),
        ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
      },
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case InterestScreen.routeName: {
            final InterestScreenArguments args = settings.arguments as InterestScreenArguments;
            return MaterialPageRoute(builder: (context) {
              return InterestScreen(args.userID, args.userInts);
            });
            // ignore: dead_code
            break;
          }
        }
        assert(false, 'Need to implement ${settings.name}');
        return null;
      },
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
