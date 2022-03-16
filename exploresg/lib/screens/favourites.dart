import 'package:exploresg/helper/utils.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class FavouriteScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FavouriteScreen();
  }
}

class _FavouriteScreen extends State<FavouriteScreen> {
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
              topBar(
                  "favourites", height, width, 'assets/img/favouriteTop.png'),
              SizedBox(
                height: 20,
              ),
              SearchBar(width: 0.8 * width, height: 0.3 * height),
              SizedBox(
                height: 10,
              ),
              Search(width: 0.8 * width, height: 0.3 * height),
              SizedBox(
                height: 30,
              ),
              PlaceContainer(
                  place: Place('Cat Safari', 'Cattos', 'Sunshine View', 3.00),
                  width: 0.8 * width,
                  height: 0.3 * height),
              PlaceContainer(
                  place: Place('Cat Safari', 'Cattos', 'Sunshine View', 3.00),
                  width: 0.8 * width,
                  height: 0.3 * height)
            ],
          ),
        ),
      ),
    );
  }
}
