import 'package:flutter/material.dart';
import 'package:exploresg/helper/utils.dart';


class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends State<HomeScreen> {

  // _moveToAnotherPageWithinNavBar() {
  //   pushNewScreenWithRouteSettings(
  //       context,
  //       screen: PlaceScreen(), // class you're moving into
  //       settings: RouteSettings(name: PlaceScreen.routeName), // remember to include routeName at the base class
  //       pageTransitionAnimation: PageTransitionAnimation.cupertino
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: createMaterialColor(Color(0xFFFFF9ED)),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              topBar("home", height, width, 'assets/img/homeTop.png'),
              textMajor("find places", Colors.black, 26),
            ],
          )
        ),
      )
    );
  }
}