import 'dart:math';

import 'package:exploresg/screens/home.dart';

import 'package:exploresg/screens/places.dart';
import 'package:flutter/material.dart';
import 'package:exploresg/helper/utils.dart';
import 'package:exploresg/helper/places_api.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'package:exploresg/models/place.dart';
import 'package:exploresg/helper/location.dart';
import 'package:exploresg/helper/favourites_controller.dart';

class ScreenArguments {
  final String placeType;
  final int max;
  final int min;
  final String sort;
  final String text;

  ScreenArguments(this.placeType, this.max, this.min, this.sort, this.text);
}

class AfterSearchScreen extends StatefulWidget {
  static const routeName = "/afterSearch";
  final String placeType;
  final int max;
  final int min;
  final String sort;
  final String text;
  AfterSearchScreen(this.placeType, this.max, this.min, this.sort, this.text);

  @override
  //const _placetypedropdownValue = screenArguments.sort
  State<AfterSearchScreen> createState() => _AfterSearchState();
}

class _AfterSearchState extends State<AfterSearchScreen> {
  // bool _searchByCategory = false;
  //
  // String _placeTypeDropdownValue = 'place';
  // // String _filteredByDropdownValue = 'filter by';
  // String _sortByDropdownValue = 'sort by';
  // TextEditingController _searchController = new TextEditingController();

  PlacesApi _placesApi = PlacesApi();
  List<Place> _places = [];
  bool _isLoaded = false;

  FavouritesController _favouritesController = FavouritesController();
  List<String> _favourites = [];

  void initState() {
    super.initState();
    _loadPage();
  }

  Future<void> _loadPage() async {
    _loadSearch(ScreenArguments(
        widget.placetype, widget.max, widget.min, widget.sort, widget.text));
    _favourites = await _favouritesController
        .getFavouritesList(); // i think this function can be defined in a controller class instead
    setState(() {
      _isLoaded = true;
    });

  }

  InputDecoration dropdownDeco = InputDecoration(
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      labelStyle: TextStyle(color: Colors.black, fontSize: 16));

  // Container _dropdownList(double width, DropdownButtonFormField DDL) {
  //   return Container(
  //       width: width,
  //       padding: EdgeInsets.symmetric(horizontal: 0.1 * width),
  //       margin: EdgeInsets.symmetric(vertical: 5),
  //       decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(20), color: Colors.white),
  //       child: DDL);
  // }

  // Container _filterDropDown(double width) {
  //   return _dropdownList(
  //       0.49 * width,
  //       DropdownButtonFormField<String>(
  //           items: [
  //             DropdownMenuItem(
  //                 child: textMinor("filter by", Colors.black),
  //                 value: "filter by"),
  //             DropdownMenuItem(child: textMinor("b", Colors.black), value: "b")
  //           ],
  //           decoration: dropdownDeco,
  //           isExpanded: true,
  //           value: _filterByDropdownValue,
  //           onChanged: (String? newValue) {
  //             _filterByDropdownValue = newValue!;
  //           }));
  // }

  // double _distvalue = 50000;
  // RangeValues _pricevalues = RangeValues(0, 4);
  // RangeValues _ratingvalues = RangeValues(1, 5);
  //
  // int _maxfilter = 0;
  // int _minfilter = 4;

  // Widget _ratingfilter(double width) {
  //   final double min = 1;
  //   final double max = 5;
  //
  //   return Container(
  //       margin: EdgeInsets.symmetric(horizontal: 16),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           buildSideLabel(min),
  //           Expanded(
  //             child: RangeSlider(
  //               values: _ratingvalues,
  //               min: min,
  //               max: max,
  //               divisions: 5,
  //               labels: RangeLabels(
  //                 _ratingvalues.start.round().toString(),
  //                 _ratingvalues.end.round().toString(),
  //               ),
  //               //showValueIndicator: true,
  //               onChanged: (values) {
  //                 setState(() {
  //                   _ratingvalues = values;
  //                   _maxfilter = values.start.round();
  //                   _minfilter = values.end.round();
  //                   print(values);
  //                 });
  //               },
  //             ),
  //           ),
  //           buildSideLabel(max),
  //         ],
  //       ));
  // }

  // Widget _pricefilter(double width) {
  //   final double min = 0;
  //   final double max = 4;
  //
  //   return Container(
  //       margin: EdgeInsets.symmetric(horizontal: 16),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           buildSideLabel(min),
  //           Expanded(
  //             child: RangeSlider(
  //               values: _pricevalues,
  //               min: min,
  //               max: max,
  //               divisions: 4,
  //               labels: RangeLabels(
  //                 _pricevalues.start.round().toString(),
  //                 _pricevalues.end.round().toString(),
  //               ),
  //               //showValueIndicator: true,
  //               onChanged: (values) {
  //                 setState(() {
  //                   _pricevalues = values;
  //                   _maxfilter = values.start.round();
  //                   _minfilter = values.end.round();
  //                   print(values);
  //                 });
  //               },
  //             ),
  //           ),
  //           buildSideLabel(max),
  //         ],
  //       ));
  // }

  // Widget _distancefilter(double width) {
  //   final double min = 0;
  //   final double max = 50000;
  //
  //   return Container(
  //       margin: EdgeInsets.symmetric(horizontal: 16),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           buildSideLabel(min),
  //           Expanded(
  //             child: CupertinoSlider(
  //               value: _distvalue,
  //               min: min,
  //               max: max,
  //               divisions: 100000,
  //               // labels: RangeLabels(
  //               //   _distvalues.start.round().toString(),
  //               //   _distvalues.end.round().toString(),
  //               // ),
  //               //showValueIndicator: true,
  //               onChanged: (value) {
  //                 setState(() {
  //                   _distvalue = value;
  //                   _maxfilter = value.round();
  //                   _minfilter = 0;
  //                   print(value);
  //                 });
  //               },
  //             ),
  //           ),
  //           buildSideLabel(max),
  //         ],
  //       ));
  // }

  Widget buildSideLabel(double value) {
    return Container(
      width: 30,
      child: Text(
        value.round().toString(),
        style: TextStyle(fontFamily: 'AvenirLtStd', fontSize: 13),
        textAlign: TextAlign.center,
      ),
    );
  }

  // Widget _displayFiltered(double width) {
  //   if (_sortByDropdownValue == 'distance') {
  //     return _distancefilter(width);
  //   } else if (_sortByDropdownValue == 'ratings') {
  //     return _ratingfilter(width);
  //   } else if (_sortByDropdownValue == 'price') {
  //     return _pricefilter(width);
  //   } else {
  //     return SizedBox.shrink();
  //   }
  // }

  // Container _sortDropDown(double width) {
  //   return _dropdownList(
  //       0.49 * width,
  //       DropdownButtonFormField<String>(
  //           items: [
  //             DropdownMenuItem(
  //                 child: textMinor("sort by", Colors.black), value: "sort by"),
  //             DropdownMenuItem(child: textMinor("b", Colors.black), value: "b")
  //           ],
  //           decoration: dropdownDeco,
  //           isExpanded: true,
  //           value: _sortByDropdownValue,
  //           onChanged: (String? newValue) {
  //             _sortByDropdownValue = newValue!;
  //           }));
  // }

  // Container _sortDropDown(double width) {
  //   return _dropdownList(
  //       0.49 * width,
  //       DropdownButtonFormField<String>(
  //           items: [
  //             DropdownMenuItem(
  //                 child: textMinor("sort by", Colors.black), value: "sort by"),
  //             DropdownMenuItem(
  //                 child: textMinor("distance", Colors.black),
  //                 value: "distance"),
  //             DropdownMenuItem(
  //                 child: textMinor("ratings", Colors.black), value: "ratings"),
  //             DropdownMenuItem(
  //                 child: textMinor("price", Colors.black), value: "price")
  //           ],
  //           decoration: dropdownDeco,
  //           isExpanded: true,
  //           value: _sortByDropdownValue,
  //           onChanged: (String? newValue) {
  //             setState(() {
  //               _sortByDropdownValue = newValue!;
  //               _displayFiltered(width);
  //             });
  //           }));
  // }

  // Container _placeTypeDropDown(double width) {
  //   return _dropdownList(
  //       width,
  //       DropdownButtonFormField<String>(
  //           items: [
  //             DropdownMenuItem(
  //                 child: textMinor("place type", Colors.black),
  //                 value: "place type"),
  //             DropdownMenuItem(child: textMinor("a", Colors.black), value: "a")
  //           ],
  //           decoration: dropdownDeco,
  //           isExpanded: true,
  //           value: _placeTypeDropdownValue,
  //           onChanged: (String? newValue) {
  //             _placeTypeDropdownValue = newValue!;
  //           }));
  // }

  // Container _searchBar(double width, double height) {
  //   return Container(
  //     width: width,
  //     height: height / 5.4,
  //     decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(20), color: Colors.white),
  //     child: Container(
  //       child: TextField(
  //         onSubmitted: (value) {
  //           print(_placeTypeDropdownValue);
  //           print(_sortByDropdownValue);
  //           print(_searchController.text);
  //         },
  //         controller: _searchController,
  //         cursorColor: Colors.grey,
  //         cursorHeight: 14.0,
  //         style: TextStyle(fontFamily: 'AvenirLtStd', fontSize: 14),
  //         decoration: new InputDecoration(
  //           prefixIcon: Icon(
  //             Icons.search,
  //             color: Colors.grey,
  //           ),
  //           labelText: 'type a place...',
  //           labelStyle: TextStyle(
  //               fontFamily: 'AvenirLtStd', fontSize: 14, color: Colors.grey),
  //           enabledBorder: const OutlineInputBorder(
  //             borderRadius: BorderRadius.all(Radius.circular(20.0)),
  //             borderSide: const BorderSide(
  //               color: Colors.white,
  //             ),
  //           ),
  //           focusedBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.all(Radius.circular(20.0)),
  //             borderSide: BorderSide(color: Colors.white),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Transform _searchSwitch() {
  //   return Transform.scale(
  //       transformHitTests: false,
  //       scale: .7,
  //       child: CupertinoSwitch(
  //         activeColor: Colors.blue,
  //         trackColor: Colors.blue, //change to closer colour
  //         value: _searchByCategory,
  //         onChanged: (value) {
  //           setState(() {
  //             _searchByCategory = !_searchByCategory;
  //           });
  //         },
  //       ));
  // }

  // Align _goButton(ScreenArguments screenArguments) {
  //   return Align(
  //       alignment: Alignment.topRight,
  //       child: TextButton(
  //         style: ButtonStyle(
  //             backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
  //             shape: MaterialStateProperty.all<RoundedRectangleBorder>(
  //                 RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(18.0),
  //             ))),
  //         onPressed: () {},
  //         child: Text("Go!",
  //             style: TextStyle(
  //                 fontFamily: 'AvenirLtStd',
  //                 fontSize: 12,
  //                 color: Colors.white)),
  //       ));
  // }

  // Widget _searchTools(
  //     double width, double height, ScreenArguments screenArguments) {
  //   return Container(
  //       width: width,
  //       child: Column(
  //         children: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               textMinor("keyword search", Colors.black),
  //               _searchSwitch(),
  //               textMinor("dropdown list", Colors.black)
  //             ],
  //           ),
  //           _searchByCategory == false
  //               ? _searchBar(width, height)
  //               : _placeTypeDropDown(width),
  //           Row(mainAxisAlignment: MainAxisAlignment.center, children: [
  //             SizedBox(width: 0.02 * width),
  //             _sortDropDown(width)
  //           ]),
  //           _displayfiltered(width),
  //           _goButton(screenArguments),
  //         ],
  //       ));
  // }

  Widget _addFav(Place place, double height, double width) {
    return Container(
        color: Colors.white,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(children: [
                InkWell(
                    onTap: () async {
                      await _favouritesController.addOrRemoveFav(place.id);
                      _favourites =
                          await _favouritesController.getFavouritesList();
                      print("<3 pressed");
                      setState(() {
                        place.likes = !place.likes;
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

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  void _loadSearch(ScreenArguments screenArguments) async {
    // String uid = _auth.getCurrentUser()!.uid;
    // String interest = "";
    List<Place> _mixPlaces = [];
    // await _firebaseApi
    //     .getDocumentByIdFromCollection("users", uid)
    //     .then((value) {
    //   interest = value["interest"];
    // }).onError((error, stackTrace) {
    //   showAlert(context, "Retrieve User Profile", error.toString());
    // });
    // if (interest != "") {
    //   var split = interest.split(",");
    // for (String s in split) {
    //   var result = await _placesApi.nearbySearchFromText(
    //       "1.4430557283012149", "103.80793159927359", 10000, s, "");
    //   for (var i in result!) {
    //     _mixPlaces.add(i);
    //   }
    // }
    Locator location = new Locator();
    var userLoc = await location.getCurrentLocation();
    if (userLoc != null) {
      String lat = userLoc.latitude.toString();
      String long = userLoc.longitude.toString();
      if (screenArguments.sort == 'distance') {
        var result = await _placesApi.nearbySearchFromText(
            lat, long, screenArguments.max, screenArguments.text, "");
        for (var i in result!) {
          _mixPlaces.add(i);
        }
      }
      _places = _mixPlaces;
      setState(() {
        _isLoaded = true;
      });
    } else {
      showAlert(context, "Location Permission Error", "Location permission either disable or disabled. Please enable to enjoy the full experience.");
    }

    // print(lat);
    // print(long);

  }

  Widget _printSearch(List<Place> places, double height, double width) {
    return Container(
        height: height,
        width: width,
        child: ListView.builder(
            //shrinkWrap: true,
            itemCount: places.length,
            itemBuilder: (context, index) {
              return Container(
                  height: 0.3 * height,
                  child: Column(children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, Places2Screen.routeName,
                            arguments: Places2ScreenArgs(_places[index]));
                      },
                      child: placeContainer(places[index], width, 0.2 * height),
                    ),
                    _addFav(places[index], 0.05 * height, width),
                  ]));
            }));
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    // LatLng userLoc = Locator.getLongLang() as LatLng;
    //final homeargs = ModalRoute.of(context)!.settings.arguments;

    return _isLoaded
        ? Scaffold(
            backgroundColor: createMaterialColor(Color(0xFFFFF9ED)),
            body: Container(
                //height: 220.0,
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        //mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                  // Container(
                  //     alignment: Alignment.center,topBar("places", height, width, 'assets/img/afterSearchTop.png'),

                  _printSearch(_places, height, width)
                ]))))
        : Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
