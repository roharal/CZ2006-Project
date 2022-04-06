import 'dart:math';
import 'dart:collection';

import 'package:exploresg/screens/places.dart';
import 'package:flutter/material.dart';
import 'package:exploresg/helper/utils.dart';
import 'package:exploresg/helper/places_api.dart';
import 'package:exploresg/models/place.dart';
import 'package:exploresg/helper/location.dart';

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
  List<double> _distance = [];
  bool _isLoaded = false;

  void initState() {
    super.initState();
    _loadSearch(ScreenArguments(
        widget.placeType, widget.max, widget.min, widget.sort, widget.text));
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
        width: width,
        height: height,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                textMinor("add to favourites", Colors.black)
              ])
            ]));
  }

//SORT DISTANCE RETURNING PLACES ACCORDING TO ASCENDING DIST
  // Widget _sortdistance(place, lat, long) {
  //   List<PlaceDistance> list = [];
  //   for (var i in place){
  //     calculateDistance(lat, long, i, )
  //   }
  //   return distance;
  // }

  //returns distance in km
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

    Locator location = new Locator();
    var userLoc = await location.getCurrentLocation();

    if (userLoc != null) {
      String lat = userLoc.latitude.toString();
      String long = userLoc.longitude.toString();

      if (screenArguments.sort == 'distance') {
        //_sortdistance(result, lat, long);
        //List<PlaceDistance> list = [];
        var result = await _placesApi.nearbySearchFromText(
            lat, long, screenArguments.max, screenArguments.text, "");

        print(result);
        var distmap = {};

        for (var i in result!) {
          //FN TO SORT PLACES BY DIST
          distmap[i] = calculateDistance(
              userLoc.latitude,
              userLoc.longitude,
              double.parse(i.coordinates["lat"]!),
              double.parse(i.coordinates["long"]!));
        }

        var sortedKeys = distmap.keys.toList(growable: false)
          ..sort((a, b) => distmap[a].compareTo(distmap[b]));
        LinkedHashMap sortedMap = new LinkedHashMap.fromIterable(sortedKeys,
            key: (k) => k, value: (k) => distmap[k]);

        for (var i in sortedMap.values) {
          _distance.add(double.parse(i.toStringAsFixed(2)));
        }

        for (var i in sortedKeys) {
          _mixPlaces.add(i);
        }
      } else if (screenArguments.sort == "ratings") {
        var result = await _placesApi.nearbySearchFromText(
            lat, long, 15000, screenArguments.text, "");

        print(result);

        var ratingsmap = {};

        for (var i in result!) {
          if (widget.min <= i.ratings && i.ratings <= widget.max) {
            ratingsmap[i] = i.ratings;
          }
          print(i);
        }
        var sortedKeys = ratingsmap.keys.toList(growable: false)
          ..sort((a, b) => ratingsmap[a].compareTo(ratingsmap[b]));
        LinkedHashMap sortedMap = new LinkedHashMap.fromIterable(sortedKeys,
            key: (k) => k, value: (k) => ratingsmap[k]);

        for (var i in sortedKeys) {
          _mixPlaces.add(i);
        }
      } else if (screenArguments.sort == "price") {
        var result = await _placesApi.nearbySearchFromText(
            lat, long, 15000, screenArguments.text, "", widget.max, widget.min);

        print(result);

        var pricemap = {};

        for (var i in result!) {
          if (widget.min <= i.price && i.price <= widget.max)
            pricemap[i] = i.price;

          print(i);
        }
        var sortedKeys = pricemap.keys.toList(growable: false)
          ..sort((a, b) => pricemap[a].compareTo(pricemap[b]));
        LinkedHashMap sortedMap = new LinkedHashMap.fromIterable(sortedKeys,
            key: (k) => k, value: (k) => pricemap[k]);

        for (var i in sortedKeys) {
          _mixPlaces.add(i);
        }
      }

      _places = _mixPlaces;
      setState(() {
        _isLoaded = true;
      });
    } else {
      showAlert(context, "Location Permission Error",
          "Location permission either disable or disabled. Please enable to enjoy the full experience.");
    }
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
                      // child: placeContainer(places[index], width, 0.2 * height,
                      //     _distance.removeAt(0)),
                      child: placeContainer(
                        places[index],
                        width,
                        0.2 * height,
                      ),
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
            appBar: AppBar(
                // Here we take the value from the MyHomePage object that was created by
                // the App.build method, and use it to set our appbar title.
                //title: Text(widget.title),
                backgroundColor: Color(0xfffffcec),
                automaticallyImplyLeading: true,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.grey),
                  onPressed: () => Navigator.pop(context, false),
                )),
            body: Container(
                //height: 220.0,
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        //mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                  // Container(
                  //     alignment: Alignment.center,
                  _printSearch(_places, height, width)
                ]))))
        : Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
