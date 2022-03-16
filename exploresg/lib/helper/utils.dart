import 'dart:ffi';

import 'package:flutter/material.dart';
import 'dart:core';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/Place.dart';

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
      fontSize: 14,
    ),
  );
}

Text textMinorGrey(String text) {
  return Text(
    text,
    style: TextStyle(
      fontFamily: 'AvenirLtStd',
      fontSize: 14,
      color: Colors.grey,
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

class SearchBar extends StatefulWidget {
  final double width;
  final double height;
  const SearchBar({Key? key, required this.width, required this.height})
      : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool searching = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height / 5.4,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      child: Container(
        child: TextField(
          cursorColor: Colors.grey,
          cursorHeight: 14.0,
          style: TextStyle(fontFamily: 'AvenirLtStd', fontSize: 14),
          decoration: new InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey,
            ),
            labelText: 'type a place...',
            labelStyle: TextStyle(
                fontFamily: 'AvenirLtStd', fontSize: 14, color: Colors.grey),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              borderSide: const BorderSide(
                color: Colors.white,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class Search extends StatefulWidget {
  final double width;
  final double height;
  const Search({Key? key, required this.width, required this.height})
      : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  // ignore: override_on_non_overriding_member
  bool _searchByKeyword = true;
  String filterbydropdownValue = 'filter by';
  String sortbydropdownValue = 'sort by';
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: [
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.0625 * widget.width)),
        Container(
            width: widget.width / 2.1,
            padding: EdgeInsets.symmetric(horizontal: 0.1 * widget.width),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.white),
            child: DropdownButtonFormField<String>(
                focusColor: Colors.white,
                items: [
                  DropdownMenuItem(
                      child: textMinorGrey("filter by"), value: "filter by"),
                  DropdownMenuItem(
                      child: textMinorGrey("distance"), value: "distance")
                ],
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    labelStyle: TextStyle(color: Colors.black, fontSize: 16)),
                isExpanded: true,
                value: filterbydropdownValue,
                onChanged: (String? newValue) {
                  print(newValue);
                })),
        Padding(padding: EdgeInsets.symmetric(horizontal: 0.02 * widget.width)),
        Container(
            width: widget.width / 2.1,
            padding: EdgeInsets.symmetric(horizontal: 0.1 * widget.width),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.white),
            child: DropdownButtonFormField<String>(
                focusColor: Colors.white,
                items: [
                  DropdownMenuItem(
                      child: textMinorGrey("sort by"), value: "sort by"),
                  DropdownMenuItem(
                      child: textMinorGrey("distance"), value: "distance")
                ],
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    labelStyle: TextStyle(color: Colors.black, fontSize: 16)),
                isExpanded: true,
                value: sortbydropdownValue,
                onChanged: (String? newValue) {
                  print(newValue);
                }))
      ],
    ));
  }
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
            ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.network(
                  place.image,
                  fit: BoxFit.fill,
                  height: 100,
                  width: 100,
                )),
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

class Tracker {
  late String placename;
  late String placedesc;
  late String placeaddress;
  late double ratings;
  late String status;
  late String date;
  late String time;
  late Array people;

  Tracker(String placename, String placedesc, String placeaddress,
      double ratings, String date, String time, Array people) {
    this.placename;
    this.placedesc;
    this.placeaddress;
    this.ratings;
    this.status = status;
    this.date = date;
    this.time = time;
    this.people = people;
  }
}
