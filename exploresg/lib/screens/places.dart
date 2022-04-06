import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exploresg/helper/authController.dart';
import 'package:exploresg/helper/firebase_api.dart';
import 'package:exploresg/helper/utils.dart';
import 'package:exploresg/models/place.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:exploresg/helper/favourites_controller.dart';

class Places2ScreenArgs {
  final Place place;
  Places2ScreenArgs(this.place);
}

class Places2Screen extends StatefulWidget {
  static const routeName = "/places2Screen";
  final Place place;
  Places2Screen({required this.place});

  @override
  State<StatefulWidget> createState() {
    return _Places2Screen();
  }
}

// Widget _renderDropdown(){
//   String status;

//    if(status == 'to explore') {
//     return Text('Widget A'); // this could be any Widget
//   } else if(status == 'explored') {
//     return Text('Widget B');
//   } else {
//     return Text('Widget C');
//   }
// }

class _Places2Screen extends State<Places2Screen> {
  // List<DropdownMenuItem<String>> get dropdownItems{
  //   List<DropdownMenuItem<String>> exploreStatus = [
  //   DropdownMenuItem(child: Text("unexplored"),value: "unexplored"),
  //   DropdownMenuItem(child: Text("to explore"),value: "to explore"),
  //   DropdownMenuItem(child: Text("explored"),value: "explored"),
  // ];
  // rety

  //String _curExpStatus;
  String dropdownValue = 'explored';
  FavouritesController _favouritesController = FavouritesController();
  FirebaseApi _firebaseApi = FirebaseApi();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AuthController _auth = AuthController();
  List<String> _favourites = [];
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    _favourites = await _favouritesController.getFavouritesList();
    setState(() {
      _isLoaded = true;
    });
  }

  Widget _upVec() {
    return Container(
        width: double.infinity,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[Image.asset('assets/img/placesUpVec.png')]));
  }

  Widget _back() {
    return Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.fromLTRB(_hPad, 10, _hPad, 10),
        child: Row(
          children: [
            Icon(Icons.arrow_back_ios),
            Text("back",
                style: TextStyle(
                  fontFamily: 'AvenirLtStd',
                  fontSize: 14,
                ))
          ],
        ));
  }

  Widget _placeImg(Place place) {
    return Container(
        height: 178,
        width: 304,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Image.network(place.images[0]));
  }

  Widget _ratings() {
    return Container(
        padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Google ratings: ",
                style: TextStyle(
                  fontFamily: 'AvenirLtStd',
                  fontSize: 14,
                )),
            Text("Explore ratings: ",
                style: TextStyle(
                  fontFamily: 'AvenirLtStd',
                  fontSize: 14,
                ))
          ],
        ));
  }

  Widget _starRatings(Place place) {
    return Container(
        padding: const EdgeInsets.fromLTRB(40, 0, 40, 10),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          RatingBarIndicator(
            rating: place.ratings,
            itemBuilder: (context, index) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            itemCount: 5,
            itemSize: 20,
            direction: Axis.horizontal,
          ),
          Image.asset('assets/img/ratingStars.png')
        ]));
  }

  Widget _address(Place place) {
    return Container(
        padding: const EdgeInsets.fromLTRB(25, 5, 40, 0),
        child: Column(children: [
          Text(place.placeAddress,
              style: TextStyle(
                fontFamily: 'AvenirLtStd',
                fontSize: 14,
              ))
        ]));
  }

  Widget _addFav(Place place, double height, double width) {
    return Container(
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          Row(children: [
            InkWell(
                onTap: () async {
                  await _favouritesController.addOrRemoveFav(place.id);
                  _favourites = await _favouritesController.getFavouritesList();
                  setState(() {
                    place.likes = !place.likes;
                    print(_favourites);
                  });
                  print(place.likes);
                },
                child: _favourites.contains(place.id)
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
            textMinor("add to favourites", Colors.black)
          ])
        ]));
  }

  Widget recommendedList(List<Place> places, double height, double width) {
    return Container(
        height: 0.8 * height,
        width: 0.8 * width,
        child: ListView.builder(
          itemCount: places.length,
          itemBuilder: (context, index) {
            return Column(children: [
              InkWell(
                onTap: () {},
                child: placeContainer(places[index], width, 0.3 * height),
              ),
              _addFav(places[index], 0.05 * height, width),
              SizedBox(
                height: 5,
              )
            ]);
          },
        ));
  }

  Widget _lowVec() {
    return Column(children: [
      Image.asset(
        'assets/img/placesLowVec.png',
      )
    ]);
  }

  Widget _dropDown() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        margin: EdgeInsets.symmetric(vertical: 3),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.white),
        child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
                value: dropdownValue,
                icon: const Icon(Icons.keyboard_arrow_down),
                style: const TextStyle(
                  color: Colors.orange,
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
                    child: Text(
                      value,
                      style: TextStyle(),
                    ),
                  );
                }).toList())));
  }

  Widget _toExplore() {
    return Container(
        padding: EdgeInsets.fromLTRB(25, 5, 5, 20),
        child: Column(children: [
          Row(children: [
            Align(
              alignment: Alignment.centerLeft,
            ),
            Text("select date: ",
                style: TextStyle(
                  fontFamily: 'AvenirLtStd',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(width: 20),
            Image.asset('assets/img/placesCalendar.png', height: 25, width: 25),
          ]),
          SizedBox(height: 20),
          Row(children: [
            Text("select time: ",
                style: TextStyle(
                  fontFamily: 'AvenirLtStd',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(width: 20),
            Image.asset('assets/img/placesClock.png', height: 25, width: 25),
          ]),
          SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              child: Text('invite someone',
                  style: TextStyle(
                    fontFamily: 'AvenirLtStd',
                    color: Colors.white,
                    fontSize: 16,
                  )),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  primary: Color(0xffD1D1D6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              onPressed: () {},
            ),
            SizedBox(width: 8),
            Container(
              margin: EdgeInsets.only(right: 25),
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                child: Text('add-to-explore',
                    style: TextStyle(
                      fontFamily: 'AvenirLtStd',
                      color: Colors.white,
                      fontSize: 16,
                    )),
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    primary: Color(0xffD1D1D6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                onPressed: () {},
              ),
            )
          ])
        ]));
  }

  Widget _explored() {
    return Container(
        padding: EdgeInsets.fromLTRB(25, 5, 5, 20),
        child: Column(children: [
          Row(children: [
            Align(
              alignment: Alignment.centerLeft,
            ),
            Text("my rating: ",
                style: TextStyle(
                  fontFamily: 'AvenirLtStd',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(width: 10),
            RatingBarIndicator(
              rating: 4.0,
              itemBuilder: (context, index) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              itemCount: 5,
              itemSize: 20,
              direction: Axis.horizontal,
            ),
          ]),
          SizedBox(height: 20),
          Row(children: [
            Text("my review: ",
                style: TextStyle(
                  fontFamily: 'AvenirLtStd',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                )),
          ]),
          SizedBox(height: 5),
          Container(
              height: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
              child: Container(
                  child: TextField(
                      decoration: new InputDecoration(
                labelText:
                    'describe your experience or record some\n nice memories...',
                labelStyle: TextStyle(
                  fontFamily: 'AvenirLtStd',
                  fontSize: 16,
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: const BorderSide(
                    color: Colors.white,
                  ),
                ),
              )))),
          SizedBox(height: 8),
          ElevatedButton(
            child: Text('recommend to someone',
                style: TextStyle(
                  fontFamily: 'AvenirLtStd',
                  color: Colors.white,
                  fontSize: 16,
                )),
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                primary: Color(0xffE56372),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
            onPressed: () {},
          ),
        ]));
  }

  Widget _statusText() {
    if (dropdownValue == 'explored') {
      return _explored();
    } else if (dropdownValue == 'to explore') {
      return _toExplore();
    } else {
      return SizedBox.shrink();
    }
  }

  static const double _hPad = 16.0;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    // List<DropdownMenuItem<String>> get dropdownItems {
    //   List<DropdownMenuItem<String>> statusItems = [
    //     DropdownMenuItem(child: Text("Unexplored"), value: "USA"),
    //     DropdownMenuItem(child: Text("To explore"), value: "Canada"),
    //     DropdownMenuItem(child: Text("Explored"), value: "Brazil"),
    //   ];
    //   return statusItems;
    // }

    return _isLoaded
        ? Scaffold(
            backgroundColor: createMaterialColor(Color(0xFFFFF9ED)),
            body: Column(children: [
              Expanded(
                  child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                    _upVec(),
                    _back(),
                    Container(
                        child: textMajor(
                            widget.place.placeName, Colors.black, 36)),
                    _placeImg(widget.place),
                    _ratings(),
                    _starRatings(widget.place),
                    _address(widget.place),
                    _addFav(widget.place, 0.05 * height, width),
                    _lowVec(),
                    Container(
                        //padding: const EdgeInsets.fromLTRB(25, 5, 40, 8),
                        child: Text("my details",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'MadeSunflower',
                              fontSize: 26,
                            ))),
                    Container(
                      padding: EdgeInsets.fromLTRB(25, 5, 5, 5),
                      child: Column(children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Text("my status: ",
                                    style: TextStyle(
                                      fontFamily: 'AvenirLtStd',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    )),
                                SizedBox(width: 5),
                                _dropDown(),
                                //_renderDropdown();
                              ],
                            ))
                      ]),
                    ),
                    _statusText()
                  ])))
            ]))
        : Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
