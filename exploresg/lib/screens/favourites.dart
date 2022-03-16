import 'package:exploresg/helper/utils.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import '../models/Place.dart';

class FavouriteScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FavouriteScreen();
  }
}

class _FavouriteScreen extends State<FavouriteScreen> {
  Place testplace = Place('Cat Safari', 'Cattos', 'Sunshine View', 3.00, false,
      'https://upload.wikimedia.org/wikipedia/commons/thumb/4/48/Catsrepublic.jpg/275px-Catsrepublic.jpg');
  Widget _addFav(Place place) {
    return Expanded(
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          Row(children: [
            InkWell(
                onTap: () {
                  print("<3 pressed");
                  setState(() {
                    place.likes = !place.likes;
                  });
                  print(place.likes);
                },
                child: place.likes
                    ? Icon(
                        Icons.favorite,
                        color: Colors.red,
                      )
                    : Icon(
                        Icons.favorite_border,
                        color: Colors.grey,
                      )),
            SizedBox(
              width: 10,
            ),
            textMinor("add to favourites")
          ])
        ]));
  }

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
              placeContainer(
                  testplace, 0.8 * width, 0.3 * height, _addFav(testplace)),
              placeContainer(
                  testplace, 0.8 * width, 0.3 * height, _addFav(testplace))
            ],
          ),
        ),
      ),
    );
  }
}
