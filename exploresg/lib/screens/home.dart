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
  // _moveToAnotherPageWithinNavBar() {
  //   pushNewScreenWithRouteSettings(
  //       context,
  //       screen: PlaceScreen(), // class you're moving into
  //       settings: RouteSettings(name: PlaceScreen.routeName), // remember to include routeName at the base class
  //       pageTransitionAnimation: PageTransitionAnimation.cupertino
  //   );
  // }
  bool _searchByCategory = false;
  String _placetypedropdownValue = 'place type';
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
    _places = await _recommendationsController.getRecommendationsList();
    _favourites = await _favouritesController.getFavouritesList();
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

  double _distvalue = 50000;
  RangeValues _pricevalues = RangeValues(0, 4);
  RangeValues _ratingvalues = RangeValues(1, 5);

  int _maxfilter = 0;
  int _minfilter = 4;

  Widget _ratingfilter(double width) {
    final double min = 1;
    final double max = 5;

    return Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildSideLabel(min),
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
                    _maxfilter = values.start.round();
                    _minfilter = values.end.round();
                    print(values);
                  });
                },
              ),
            ),
            buildSideLabel(max),
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
            buildSideLabel(min),
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
                    _maxfilter = values.start.round();
                    _minfilter = values.end.round();
                    print(values);
                  });
                },
              ),
            ),
            buildSideLabel(max),
          ],
        ));
  }

  Widget _distancefilter(double width) {
    final double min = 0;
    final double max = 50000;

    return Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildSideLabel(min),
            Expanded(
              child: CupertinoSlider(
                value: _distvalue,
                min: min,
                max: max,
                divisions: 100000,
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
            buildSideLabel(max),
          ],
        ));
  }

  Widget buildSideLabel(double value) {
    return Container(
      width: 40,
      child: Text(
        value.round().toString(),
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

  Container _placeTypeDropDown(double width) {
    return _dropDownList(
        width,
        DropdownButtonFormField<String>(
            items: [
              DropdownMenuItem(
                  child: textMinor("place type", Colors.black),
                  value: "place type"),
              DropdownMenuItem(child: textMinor("a", Colors.black), value: "a")
            ],
            decoration: dropdownDeco,
            isExpanded: true,
            value: _placetypedropdownValue,
            onChanged: (String? newValue) {
              _placetypedropdownValue = newValue!;
            }));
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
            print(_placetypedropdownValue);
            print(_sortbydropdownValue);
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
                arguments: ScreenArguments(_placetypedropdownValue, _maxfilter,
                    _minfilter, _sortbydropdownValue, _searchController.text));
            // print(_maxfilter);
            // print(_minfilter);
            // print(_sortbydropdownValue);
            // print(_searchController.text);

            // pushNewScreenWithRouteSettings(context,
            //     screen: AfterSearchScreen(ScreenArguments(
            //         _placetypedropdownValue,
            //         _maxfilter,
            //         _minfilter,
            //         _sortbydropdownValue,
            //         _searchController.text)), // class you're moving into
            //     //settings: RouteSettings(name: AfterSearchScreen.), // remember to include routeName at the base class
            //     settings: RouteSettings(
            //       name: '/aftersearch',
            //       arguments: ScreenArguments(
            //           _placetypedropdownValue,
            //           _maxfilter,
            //           _minfilter,
            //           _sortbydropdownValue,
            //           _searchController.text),
            //     ),
            //     pageTransitionAnimation: PageTransitionAnimation.cupertino);
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

  Widget recommendedList(List<Place> places, double height, double width) {
    return Container(
        height: 0.8 * height,
        width: 0.8 * width,
        child: ListView.builder(
          itemCount: places.length,
          itemBuilder: (context, index) {
            return Column(children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, Places2Screen.routeName,
                      arguments: Places2ScreenArgs(_places[index]));
                },
                child: placeContainer(places[index], 0.8 * width, 0.3 * height),
              ),
              _addFav(places[index], 0.05 * height, width),
              SizedBox(
                height: 5,
              )
            ]);
          },
        ));
  }

  // accounting
  // airport
  // amusement_park
  // aquarium
  // art_gallery
  // atm
  // bakery
  // bank
  // bar
  // beauty_salon
  // bicycle_store
  // book_store
  // bowling_alley
  // bus_station
  // cafe
  // campground
  // car_dealer
  // car_rental
  // car_repair
  // car_wash
  // casino
  // cemetery
  // church
  // city_hall
  // clothing_store
  // convenience_store
  // courthouse
  // dentist
  // department_store
  // doctor
  // drugstore
  // electrician
  // electronics_store
  // embassy
  // fire_station
  // florist
  // funeral_home
  // furniture_store
  // gas_station
  // gym
  // hair_care
  // hardware_store
  // hindu_temple
  // home_goods_store
  // hospital
  // insurance_agency
  // jewelry_store
  // laundry
  // lawyer
  // library
  // light_rail_station
  // liquor_store
  // local_government_office
  // locksmith
  // lodging
  // meal_delivery
  // meal_takeaway
  // mosque
  // movie_rental
  // movie_theater
  // moving_company
  // museum
  // night_club
  // painter
  // park
  // parking
  // pet_store
  // pharmacy
  // physiotherapist
  // plumber
  // police
  // post_office
  // primary_school
  // real_estate_agency
  // restaurant
  // roofing_contractor
  // rv_park
  // school
  // secondary_school
  // shoe_store
  // shopping_mall
  // spa
  // stadium
  // storage
  // store
  // subway_station
  // supermarket
  // synagogue
  // taxi_stand
  // tourist_attraction
  // train_station
  // transit_station
  // travel_agency
  // university
  // veterinary_care
  // zoo
  // String lat, String long, int radius, String type, String input

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
