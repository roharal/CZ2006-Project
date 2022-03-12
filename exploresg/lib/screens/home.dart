import 'package:flutter/material.dart';
import 'package:exploresg/helper/utils.dart';
import 'package:exploresg/helper/placewidgets.dart';

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
    Place testplace = Place(
        "home",
        "fun place fun place fun place fun place fun place fun place fun place fun place fun place fun place fun placfun place fun place fun place fun place fun place fun place fun place fun place fun place fun place fun placfun place fun place fun place fun place fun place fun place fun place fun place fun place fun place fun placfun place fun place fun place fun place fun place fun place fun place fun place fun place fun place fun place fun place ",
        "Singapore 512345 Happy Road",
        4);
    List<Place> places = [
      testplace,
      testplace,
      testplace,
      testplace,
      testplace,
      testplace
    ];

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    var place;
    return Scaffold(
        backgroundColor: createMaterialColor(Color(0xFFFFF9ED)),
        body: Container(
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              topBar("home", height, width, 'assets/img/homeTop.png'),
              SizedBox(height: 10),
              textMajor("find places", Colors.black, 26),
              Search(width: 0.80 * width, height: 0.3 * height),
              Image.asset("assets/img/stringAccent.png"),
              textMajor("explore", Colors.black, 26),
              for (place in places)
                PlaceContainer(
                    place: place, width: 0.8 * width, height: 0.3 * height),
              SizedBox(
                height: 60,
              ),
            ],
          )),
        ));
  }
}
