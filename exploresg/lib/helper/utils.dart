import 'package:flutter/material.dart';
import 'dart:core';
import 'models.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';

Text textMajor(String text, Color color, double size) {
  return Text(
    text,
    style: TextStyle(fontFamily: 'MadeSunflower', fontSize: size, color: color),
  );
}

Text textMinor(String text) {
  return Text(
    text,
    style: TextStyle(
      fontFamily: 'AvenirLtStd',
      fontSize: 12,
    ),
  );
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  final swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}

Widget placeContainer(Place place, double width, double height, Widget e) {
  return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(
          vertical: 0.05 * height, horizontal: 0.05 * width),
      width: width,
      height: height,
      child: Column(children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              "assets/img/catSafari.png",
              height: 100,
              width: 100,
              fit: BoxFit.fill,
            ),
            SizedBox(width: 20),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  textMajor(place.placename, Colors.grey, 20),
                  RatingBarIndicator(
                    rating: place.ratings,
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: width / 20,
                    direction: Axis.horizontal,
                  ),
                  textMinor(place.placeaddress)
                ]))
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Expanded(
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: textMinor(place.placedesc))),
        e
      ]));
}

Widget topBar(String title, double height, double width, String imagePath) {
  return Stack(
    children: [
      Container(
        height: height / 3.5,
        width: width,
        decoration: new BoxDecoration(
          image:
              DecorationImage(image: AssetImage(imagePath), fit: BoxFit.fill),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(40.0)),
        ),
      ),
      Positioned(
        top: height / 5,
        left: width / 8,
        child: textMajor(title, Colors.white, 36),
      )
    ],
  );
}
