import 'package:exploresg/helper/recommendations_controller.dart';
import 'package:exploresg/helper/authController.dart';
import 'package:exploresg/helper/firebase_api.dart';
import 'package:exploresg/helper/location.dart';
import 'package:exploresg/helper/places_api.dart';
import 'package:exploresg/screens/aftersearch.dart';

import 'package:exploresg/screens/places.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:exploresg/helper/utils.dart';
import 'package:exploresg/models/place.dart';

import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'aftersearch.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:exploresg/helper/favourites_controller.dart';

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends State<HomeScreen> {
  String _placetypedropdownValue = "airport";
  bool _searchByCategory = false;
  String _sortbydropdownValue = 'sort by';
  TextEditingController _searchController = new TextEditingController();

  RecommendationsController _recommendationsController =
      RecommendationsController();

  List<Place> _places = [];
  bool _isLoaded = false;
  FavouritesController _favouritesController = FavouritesController();
  List<String> _favourites = [];

  @override
  void initState() {
    super.initState();
    _loadPage();
  }

  Future<void> _loadPage() async {
    //_places = await _recommendationsController.getRecommendationsList();
    //_favourites = await _favouritesController.getFavouritesList();
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

  Container _dropDownList(double width, DropdownButtonFormField DDL) {
    return Container(
        width: width,
        padding: EdgeInsets.symmetric(horizontal: 0.1 * width),
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.white),
        child: DDL);
  }

  RangeValues _pricevalues = RangeValues(0, 4);
  RangeValues _ratingvalues = RangeValues(1, 5);

  int _minfilter = 0;
  int _maxfilter = 4;

  Widget _ratingfilter(double width) {
    final double min = 1;
    final double max = 5;

    return Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildSideLabel(
              _minfilter.toString(),
            ),
            Expanded(
              child: RangeSlider(
                values: _ratingvalues,
                min: min,
                max: max,
                divisions: 5,
                labels: RangeLabels(
                  _ratingvalues.start.round().toString(),
                  _ratingvalues.end.round().toString(),
                ),
                //showValueIndicator: true,
                onChanged: (values) {
                  setState(() {
                    _ratingvalues = values;
                    _minfilter = values.start.round();
                    _maxfilter = values.end.round();
                    print(values);
                  });
                },
              ),
            ),
            buildSideLabel(_maxfilter.toString()),
          ],
        ));
  }

  Widget _pricefilter(double width) {
    final double min = 0;
    final double max = 4;

    return Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildSideLabel(_minfilter.toString()),
            Expanded(
              child: RangeSlider(
                values: _pricevalues,
                min: min,
                max: max,
                divisions: 4,
                labels: RangeLabels(
                  _pricevalues.start.round().toString(),
                  _pricevalues.end.round().toString(),
                ),
                //showValueIndicator: true,
                onChanged: (values) {
                  setState(() {
                    _pricevalues = values;
                    _minfilter = values.start.round();
                    _maxfilter = values.end.round();
                    print(values);
                  });
                },
              ),
            ),
            buildSideLabel(_maxfilter.toString()),
          ],
        ));
  }

  double _distvalue = 15000;

  Widget _distancefilter(double width) {
    final double min = 0;
    final double max = 15000;

    return Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildSideLabel("0 km"),
            Expanded(
              child: CupertinoSlider(
                value: _distvalue,
                min: min,
                max: max,
                divisions: 1500,
                // labels: RangeLabels(
                //   _distvalues.start.round().toString(),
                //   _distvalues.end.round().toString(),
                // ),
                //showValueIndicator: true,
                onChanged: (value) {
                  setState(() {
                    _distvalue = value;
                    _maxfilter = value.round();
                    _minfilter = 0;
                    print(value);
                  });
                },
              ),
            ),
            buildSideLabel((_maxfilter / 1000).toString() + "km"),
          ],
        ));
  }

  Widget buildSideLabel(String value) {
    return Container(
      width: 60,
      child: Text(
        value,
        style: TextStyle(fontFamily: 'AvenirLtStd', fontSize: 13),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _displayfiltered(double width) {
    if (_sortbydropdownValue == 'distance') {
      return _distancefilter(width);
    } else if (_sortbydropdownValue == 'ratings') {
      return _ratingfilter(width);
    } else if (_sortbydropdownValue == 'price') {
      return _pricefilter(width);
    } else {
      return SizedBox.shrink();
    }
  }

  Container _sortDropDown(double width) {
    return _dropDownList(
        0.49 * width,
        DropdownButtonFormField<String>(
            items: [
              DropdownMenuItem(
                  child: textMinor("sort by", Colors.black), value: "sort by"),
              DropdownMenuItem(
                  child: textMinor("distance", Colors.black),
                  value: "distance"),
              DropdownMenuItem(
                  child: textMinor("ratings", Colors.black), value: "ratings"),
              DropdownMenuItem(
                  child: textMinor("price", Colors.black), value: "price")
            ],
            decoration: dropdownDeco,
            isExpanded: true,
            value: _sortbydropdownValue,
            onChanged: (String? newValue) {
              setState(() {
                _sortbydropdownValue = newValue!;
                _displayfiltered(width);
              });
            }));
  }

  List<String> placeType = [
    "accounting",
    "airport",
    "amusement park",
    "aquarium",
    "art gallery",
    "atm",
    "bakery",
    "bank",
    "bar",
    "beauty salon",
    "bicycle store",
    "book store",
    "bowling alley",
    "bus station",
    "cafe",
    "campground",
    "car dealer",
    "car rental",
    "car repair",
    "car wash",
    "casino",
    "cemetery",
    "church",
    "city hall",
    "clothing store",
    "convenience store",
    "courthouse",
    "dentist",
    "department store",
    "doctor",
    "drugstore",
    "electrician",
    "electronics store",
    "embassy",
    "fire station",
    "florist",
    "funeral home",
    "furniture store",
    "gas station",
    "gym",
    "hair care",
    "hardware store",
    "hindu temple",
    "home goods store",
    "hospital",
    "insurance agency",
    "jewelry store",
    "laundry",
    "lawyer",
    "library",
    "light rail station",
    "liquor store",
    "local government office",
    "locksmith",
    "meal delivery",
    "meal takeaway",
    "mosque",
    "movie theater",
    "moving company",
    "museum",
    "night club",
    "park",
    "parking",
    "pet store",
    "pharmacy",
    "physiotherapist",
    "plumber",
    "police",
    "post office",
    "primary school",
    "real estate agency",
    "restaurant",
    "roofing contractor",
    "school",
    "secondary school",
    "shoe store",
    "shopping mall",
    "spa",
    "stadium",
    "subway station",
    "supermarket",
    "taxi stand",
    "tourist attraction",
    "train station",
    "transit station",
    "travel agency",
    "university",
    "veterinary care",
    "zoo"
  ];

  Container _placeTypeDropDown(double width) {
    //String _placetypedropdownValue = "airport";

    return _dropDownList(
        width,
        DropdownButtonFormField(
          items: placeType
              .map((String e) =>
                  DropdownMenuItem(value: e, child: textMinor(e, Colors.black)))
              .toList(),
          decoration: dropdownDeco,
          isExpanded: true,
          value: _placetypedropdownValue,
          // validator: (value) {
          //   if (value!.isEmpty) {
          //     return "can't empty";
          //   } else {
          //     return null;
          //   }
          // },
          onChanged: (newValue) {
            setState(() {
              print(newValue);
              _placetypedropdownValue = newValue!;
            });
          },
        ));
  }

  Container _searchBar(double width, double height) {
    return Container(
      width: width,
      height: height / 5.4,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      child: Container(
        child: TextField(
          onSubmitted: (value) {
            // print(_placetypedropdownValue);
            // print(_sortbydropdownValue);
            print(_searchController.text);
          },
          controller: _searchController,
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

  Transform _searchSwitch() {
    return Transform.scale(
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
        ));
  }

  Align _goButton() {
    return Align(
        alignment: Alignment.topRight,
        child: TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ))),
          onPressed: () {
            Navigator.pushNamed(context, AfterSearchScreen.routeName,
                arguments: _searchByCategory == false //using input searchbar
                    ? ScreenArguments(_maxfilter, _minfilter,
                        _sortbydropdownValue, _searchController.text)
                    : ScreenArguments(
                        //using place type dropdown
                        _maxfilter,
                        _minfilter,
                        _sortbydropdownValue,
                        _placetypedropdownValue,
                      ));
            // print(_maxfilter);
            // print(_minfilter);
            // print(_sortbydropdownValue);
            // print(_searchController.text);
          },
          child: Text("Go!",
              style: TextStyle(
                  fontFamily: 'AvenirLtStd',
                  fontSize: 12,
                  color: Colors.white)),
        ));
  }

  Widget _searchTools(double width, double height) {
    return Container(
        width: width,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textMinor("keyword search", Colors.black),
                _searchSwitch(),
                textMinor("dropdown list", Colors.black)
              ],
            ),
            _searchByCategory == false
                ? _searchBar(width, height)
                : _placeTypeDropDown(width),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(width: 0.02 * width),
              _sortDropDown(width)
            ]),
            _displayfiltered(width),
            _goButton()
          ],
        ));
  }

  Widget _addFav(Place place, double height, double width) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        width: width,
        height: height,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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

  Widget recommendedList(List<Place> places, double height, double width) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: places.length,
      itemBuilder: (context, index) {
        return Column(children: [
          Stack(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, Places2Screen.routeName,
                      arguments: Places2ScreenArgs(_places[index]));
                },
                child: placeContainer(places[index], 0.8 * width, 0.3 * height),
              ),
              Positioned(
                bottom: 0,
                child: _addFav(places[index], 0.05 * height, 0.8 * width)),
          ]
          ),
          SizedBox(
            height: 15,
          )
        ]);
      },
    );
  }

  // void _loadRecommendations() async {
  //   String uid = _auth.getCurrentUser()!.uid;
  //   String interest = "";
  //   Locator locator = new Locator();
  //   var coor = await locator.getCurrentLocation();
  //   if (coor != null) {
  //     List<Place> _mixPlaces = [];
  //     await _firebaseApi
  //         .getDocumentByIdFromCollection("users", uid)
  //         .then((value) {
  //       interest = value["interest"];
  //     }).onError((error, stackTrace) {
  //       showAlert(context, "Retrieve User Profile", error.toString());
  //     });
  //     if (interest != "") {
  //       var split = interest.split(",");
  //       for (String s in split) {
  //         var result = await _placesApi.nearbySearchFromText(
  //             coor.latitude.toString(),
  //             coor.longitude.toString(),
  //             10000,
  //             s,
  //             "");
  //         for (var i in result!) {
  //           _mixPlaces.add(i);
  //         }
  //       }
  //       _mixPlaces = (_mixPlaces..shuffle());
  //       while (_mixPlaces.length > 5) {
  //         _mixPlaces.removeLast();
  //       }
  //     }
  //     _places = _mixPlaces;
  //     setState(() {
  //       _isLoaded = true;
  //     });
  //   } else {
  //     showAlert(context, "Location Permission Error",
  //         "Location permission either disable or disabled. Please enable to enjoy the full experience.");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return _isLoaded
        ? Scaffold(
            backgroundColor: createMaterialColor(Color(0xfffffcec)),
            body: Container(
                child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                  topBar("home", height, width, 'assets/img/homeTop.png'),
                  SizedBox(height: 10),
                  textMajor("find places", Colors.black, 26),
                  _searchTools(0.80 * width, 0.3 * height),
                  Image.asset("assets/img/stringAccent.png"),
                  textMajor("explore", Colors.black, 26),
                  recommendedList(_places, height, width),
                  SizedBox(height: 20)
                ]))))
        : Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
