import 'package:flutter/material.dart';
import 'package:exploresg/helper/utils.dart';
import 'package:exploresg/helper/placewidgets.dart';

class AfterSearchScreen extends StatefulWidget {
  const AfterSearchScreen({Key? key}) : super(key: key);

  @override
  State<AfterSearchScreen> createState() => _AfterSearchState();
}

class _AfterSearchState extends State<AfterSearchScreen> {
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
              topBar("places", height, width, 'assets/img/afterSearchTop.png'),
              SizedBox(height: 10),
              Search(width: 0.80 * width, height: 0.3 * height),
              SizedBox(height: 20),
              for (place in places)
                PlaceContainer(
                    place: place, width: 0.8 * width, height: 0.3 * height),
              SizedBox(
                height: 60,
              ),
            ]))));
  }
}
