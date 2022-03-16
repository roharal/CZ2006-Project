import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'utils.dart';
import 'dart:core';

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
                "assets/img/oshy.png",
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
                InkWell(
                  onTap: () {
                    print("<3 pressed");
                    setState(() {
                      _likes = !_likes;
                    });
                    print(_likes);
                  },
                  child: _likes
                      ? Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : Icon(
                          Icons.favorite_border,
                          color: Colors.grey,
                        ),
                ),
                SizedBox(
                  width: 10,
                ),
                textMinor("add to favourites")
              ]))
        ]));
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
  bool _searchByCategory = true;
  String placetype = 'place type';
  String filterbydropdownValue = 'filter by';
  String sortbydropdownValue = 'sort by';

  InputDecoration dropdownDeco = InputDecoration(
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      labelStyle: TextStyle(color: Colors.black, fontSize: 16));

  Container dropdownlist(double width, DropdownButtonFormField DDL) {
    return Container(
        width: width,
        padding: EdgeInsets.symmetric(horizontal: 0.1 * widget.width),
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.white),
        child: DDL);
  }

  Widget build(BuildContext context) {
    return Container(
        width: widget.width,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textMinor("keyword search"),
                Transform.scale(
                    transformHitTests: false,
                    scale: .7,
                    child: CupertinoSwitch(
                      activeColor: Colors.blue,
                      trackColor: Colors.blue, //change to closer colour
                      value: _searchByCategory,
                      onChanged: (value) {
                        setState(() {
                          _searchByCategory = !_searchByCategory;
                        });
                      },
                    )),
                textMinor("dropdown list")
              ],
            ),
            _searchByCategory == false
                ? textMinor("searchbyKW")
                : dropdownlist(
                    widget.width,
                    DropdownButtonFormField<String>(
                        items: [
                          DropdownMenuItem(
                              child: textMinor("place type"),
                              value: "place type"),
                          DropdownMenuItem(child: textMinor("a"), value: "a")
                        ],
                        decoration: dropdownDeco,
                        isExpanded: true,
                        value: placetype,
                        onChanged: (String? newValue) {
                          placetype = newValue!;
                        })),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              dropdownlist(
                  0.49 * widget.width,
                  DropdownButtonFormField<String>(
                      items: [
                        DropdownMenuItem(
                            child: textMinor("filter by"), value: "filter by"),
                        DropdownMenuItem(child: textMinor("b"), value: "b")
                      ],
                      decoration: dropdownDeco,
                      isExpanded: true,
                      value: filterbydropdownValue,
                      onChanged: (String? newValue) {
                        filterbydropdownValue = newValue!;
                      })),
              SizedBox(width: 0.02 * widget.width),
              dropdownlist(
                  0.49 * widget.width,
                  DropdownButtonFormField<String>(
                      items: [
                        DropdownMenuItem(
                            child: textMinor("sort by"), value: "sort by"),
                        DropdownMenuItem(child: textMinor("b"), value: "b")
                      ],
                      decoration: dropdownDeco,
                      isExpanded: true,
                      value: sortbydropdownValue,
                      onChanged: (String? newValue) {
                        sortbydropdownValue = newValue!;
                      }))
            ]),
            Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ))),
                  onPressed: () {
                    print(placetype +
                        filterbydropdownValue +
                        sortbydropdownValue);
                  },
                  child: Text("Go!",
                      style: TextStyle(
                          fontFamily: 'AvenirLtStd',
                          fontSize: 12,
                          color: Colors.white)),
                ))
          ],
        ));
  }
}
