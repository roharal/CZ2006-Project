import 'dart:ffi';

import 'package:flutter/material.dart';
import 'dart:core';
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

class Place {
  late String placename;
  late String placedesc;
  late String placeaddress;
  late double ratings;
  //constructor
  Place(
      String placename, String placedesc, String placeaddress, double ratings) {
    this.placename = placename;
    this.placedesc = placedesc;
    this.placeaddress = placeaddress;
    this.ratings = ratings;
  }
}

class PlaceContainer extends StatefulWidget {
  final Place place;
  final double width;
  final double height;
  const PlaceContainer(
      {Key? key,
      required this.place,
      required this.width,
      required this.height})
      : super(key: key);

  @override
  State<PlaceContainer> createState() => _PlaceContainerState();
}

class _PlaceContainerState extends State<PlaceContainer> {
  @override
  // ignore: override_on_non_overriding_member
  bool _likes = false;
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.symmetric(
            vertical: 0.05 * widget.height, horizontal: 0.05 * widget.width),
        width: widget.width,
        height: widget.height,
        child: Column(children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                "assets/img/catsafari.png",
                height: 100,
                width: 100,
                fit: BoxFit.fill,
              ),
              SizedBox(width: 20),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    textMajor(widget.place.placename, Colors.grey, 20),
                    RatingBarIndicator(
                      rating: widget.place.ratings,
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: widget.width / 20,
                      direction: Axis.horizontal,
                    ),
                    textMinor(widget.place.placeaddress)
                  ]))
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: textMinor(widget.place.placedesc))),
          Expanded(
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                IconButton(
                  icon: _likes
                      ? Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : Icon(
                          Icons.favorite_border,
                          color: Colors.grey,
                        ),
                  onPressed: () {
                    print("<3 pressed");
                    setState(() {
                      _likes = !_likes;
                    });
                    print(_likes);
                  },
                ),
                textMinor("add to favourites")
              ]))
        ]));
  }
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

class TrackerContainer extends StatefulWidget {
  final Place place;
  final double width;
  final double height;
  const TrackerContainer(
      {Key? key,
      required this.place,
      required this.width,
      required this.height})
      : super(key: key);

  @override
  State<TrackerContainer> createState() => _TrackerContainerState();
}

class _TrackerContainerState extends State<TrackerContainer> {
  @override
  // ignore: override_on_non_overriding_member
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(
          vertical: 0.05 * widget.height, horizontal: 0.05 * widget.width),
      width: widget.width,
      height: widget.height + 30,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                "assets/img/catsafari.png",
                height: 100,
                width: 100,
                fit: BoxFit.fill,
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textMajor(widget.place.placename, Colors.grey, 20),
                    RatingBarIndicator(
                      rating: widget.place.ratings,
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: widget.width / 20,
                      direction: Axis.horizontal,
                    ),
                    textMinor(widget.place.placeaddress)
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          textMinor(widget.place.placedesc),
          Expanded(
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(children: [
                        textMinor('my status:'),
                        textMinor('date:'),
                        textMinor('time:'),
                        textMinor('people:'),
                      ]),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Status(
                              height: widget.height, width: widget.width),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: textMinor('16/3/2022'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: textMinor('11:30 am'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: textMinor('faith, ihsan'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Status extends StatefulWidget {
  final double width;
  final double height;
  const Status({Key? key, required this.width, required this.height})
      : super(key: key);

  @override
  State<Status> createState() => _StatusState();
}

class _StatusState extends State<Status> {
  String dropdownValue = 'to explore';
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 18),
        margin: EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: createMaterialColor(Color(0xFFFFF9ED))),
        height: widget.height / 6.5,
        child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
                value: dropdownValue,
                icon: const Icon(Icons.keyboard_arrow_down),
                style: const TextStyle(
                  color: Colors.blueAccent,
                  fontFamily: 'AvenirLtStd',
                  fontSize: 14,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                items: <String>['unexplored', 'to explore', 'explored']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList())));
  }
}
