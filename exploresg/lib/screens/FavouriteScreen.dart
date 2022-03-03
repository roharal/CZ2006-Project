import 'package:exploresg/helper/utils.dart';
import 'package:flutter/material.dart';

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
    return Container(
        child: Stack(
          children: [
            topBar("favourites", height, width, 'assets/img/favouriteTop.png')
          ],
        )
    );
  }
}