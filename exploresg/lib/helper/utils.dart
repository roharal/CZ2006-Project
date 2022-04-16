import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:exploresg/models/place.dart';
import 'package:flutter_svg/svg.dart';

Text textMajor(String text, Color color, double size) {
  return Text(
    text,
    style: TextStyle(fontFamily: 'MadeSunflower', fontSize: size, color: color),
  );
}

Text textMinor(String text, Color color) {
  return Text(text,
      style: TextStyle(fontFamily: 'AvenirLtStd', fontSize: 14, color: color));
}

TextStyle avenirLtStdStyle(Color color) {
  return TextStyle(fontFamily: 'AvenirLtStd', fontSize: 14, color: color);
}

Text textMinorBold(String text, Color color, double size) {
  return Text(text,
      style: TextStyle(
          fontFamily: 'AvenirLtStd',
          fontWeight: FontWeight.bold,
          fontSize: size,
          color: color));
}

Widget topBar(String title, double height, double width, String imagePath) {
  return Stack(
    children: [
      FittedBox(
          fit: BoxFit.fill,
          child: SvgPicture.asset(
            imagePath,
            width: width,
            height: width / 204 * 490,
          )),
      Positioned(
        bottom: width / 30,
        left: width / 8,
        child: textMajor(title, Colors.white, 36),
      )
    ],
  );
}

//returns distance in km
double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}

List<String> placeType = [
  'airport',
  'amusement_park',
  'aquarium',
  'art_gallery',
  'bakery',
  'bar',
  'beauty_salon',
  'book_store',
  'bowling_alley',
  'cafe',
  'casino',
  'cemetery',
  'clothing_store',
  'department_store',
  'florist',
  'gym',
  'hair_care',
  'library',
  'lodging',
  'movie_theater',
  'museum',
  'night_club',
  'park',
  'restaurant',
  'shopping_mall',
  'spa',
  'stadium',
  'tourist_attraction',
  'university',
  'zoo',
];

Future showAlert(BuildContext context, String title, String content) async {
  Platform.isIOS
      ? await showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text(title),
              content: Text(content),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          })
      : await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: new Text(title),
              content: new Text(content),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
}

Widget progressionIndicator() {
  return Container(
    color: Color(0XffFFF9ED),
    child: Center(
      child: CircularProgressIndicator(),
    ),
  );
}

Widget _printDist(distance) {
  return (distance != null)
      ? textMinor(distance.toString() + "km", Color(0xff22254C))
      : SizedBox();
}

Widget _printPrice(numOfD) {
  switch (numOfD) {
    case 0:
      return textMinor("\$", Color(0xff22254C));
    case 1:
      return textMinor("\$\$", Color(0xff22254C));
    case 2:
      return textMinor("\$\$\$", Color(0xff22254C));
    case 3:
      return textMinor("\$\$\$\$", Color(0xff22254C));
    case 4:
      return textMinor("\$\$\$\$\$", Color(0xff22254C));
    default:
      return SizedBox(width: 0);
  }
}

Widget placeContainer(
    Place place, double width, double height, Widget extra, Widget top,
    [double? distance]) {
  return Container(
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20))),
    padding:
        EdgeInsets.symmetric(vertical: 0.05 * height, horizontal: 0.05 * width),
    width: width,
    child: Column(
      children: [
        top,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child:  place.images.length != 0 ? Image.network(place.images[0],
                fit: BoxFit.fill,
                height: 100,
                width: 100,
              ) : Icon(Icons.question_mark, size: 100,),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.placeName,
                    style: TextStyle(
                        fontFamily: 'AvenirLtStd',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xff22254C)),
                  ),
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
                  textMinor(place.placeAddress, Color(0xff22254C)),
                  SizedBox(height: 5),
                  _printPrice(place.price),
                  SizedBox(height: 5),
                  //include dist for afterseach
                  // textMinor(distance.toString() + "km", Colors.black),
                  _printDist(distance?.toStringAsFixed(2)),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: height * 0.14,
        ),
        extra,
      ],
    ),
  );
}
