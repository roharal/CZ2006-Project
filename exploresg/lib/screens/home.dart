
import 'package:exploresg/helper/authController.dart';
import 'package:exploresg/helper/firebase_api.dart';
import 'package:exploresg/helper/location.dart';
import 'package:exploresg/helper/places_api.dart';
import 'package:exploresg/screens/places.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:exploresg/helper/utils.dart';
import 'package:exploresg/models/place.dart';

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
  String _filterbydropdownValue = 'filter by';
  String _sortbydropdownValue = 'sort by';
  TextEditingController _searchController = new TextEditingController();
  PlacesApi _placesApi = PlacesApi();
  FirebaseApi _firebaseApi = FirebaseApi();
  AuthController _auth = AuthController();
  List<Place> _places = [];
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadRecommendations();
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

  Container _filterDropDown(double width) {
    return _dropDownList(
        0.49 * width,
        DropdownButtonFormField<String>(
            items: [
              DropdownMenuItem(
                  child: textMinor("filter by", Colors.black),
                  value: "filter by"),
              DropdownMenuItem(child: textMinor("b", Colors.black), value: "b")
            ],
            decoration: dropdownDeco,
            isExpanded: true,
            value: _filterbydropdownValue,
            onChanged: (String? newValue) {
              _filterbydropdownValue = newValue!;
            }));
  }

  Container _sortDropDown(double width) {
    return _dropDownList(
        0.49 * width,
        DropdownButtonFormField<String>(
            items: [
              DropdownMenuItem(
                  child: textMinor("sort by", Colors.black), value: "sort by"),
              DropdownMenuItem(child: textMinor("b", Colors.black), value: "b")
            ],
            decoration: dropdownDeco,
            isExpanded: true,
            value: _sortbydropdownValue,
            onChanged: (String? newValue) {
              _sortbydropdownValue = newValue!;
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
            print(_placetypedropdownValue +
                _filterbydropdownValue +
                _sortbydropdownValue +
                _searchController.text);
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
            print(_placetypedropdownValue +
                _filterbydropdownValue +
                _sortbydropdownValue +
                _searchController.text);
            // pushNewScreenWithRouteSettings(
            //           context,
            //           screen: AfterSearchScreen(), // class you're moving into
            //           settings: RouteSettings(name: AfterSearchScreen.routeName), // remember to include routeName at the base class
            //           pageTransitionAnimation: PageTransitionAnimation.cupertino
            //       );
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
              _filterDropDown(width),
              SizedBox(width: 0.02 * width),
              _sortDropDown(width)
            ]),
            _goButton()
          ],
        ));
  }

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

  Widget recommendedList(List<Place> places, double height, double width) {
    return Container(
      height: 0.8 * height,
      width: 0.8 * width,
      child: ListView.builder(
        itemCount: places.length,
        itemBuilder: (context, index) {
          return Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                        context,
                        Places2Screen.routeName,
                        arguments: Places2ScreenArgs(_places[index]));
                  },
                  child: placeContainer(places[index], width, 0.2 * height),
                ),
                _addFav(places[index], 0.05 * height, width),
                SizedBox(height: 5,)
              ]
          );},
      )
    );
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

  void _loadRecommendations() async {
    String uid = _auth.getCurrentUser()!.uid;
    String interest = "";
    Locator locator = new Locator();
    var coor = await locator.getCurrentLocation();
    if (coor != null) {
      List<Place> _mixPlaces = [];
      await _firebaseApi
          .getDocumentByIdFromCollection("users", uid)
          .then((value) {
        interest = value["interest"];
      }).onError((error, stackTrace) {
        showAlert(context, "Retrieve User Profile", error.toString());
      });
      if (interest != "") {
        var split = interest.split(",");
        for (String s in split) {
          var result = await _placesApi.nearbySearchFromText(
              coor.latitude.toString(), coor.longitude.toString(), 10000, s, "");
          for (var i in result!) {
            _mixPlaces.add(i);
          }
        }
        _mixPlaces = (_mixPlaces..shuffle());
        while (_mixPlaces.length > 5) {
          _mixPlaces.removeLast();
        }
      }
      _places = _mixPlaces;
      setState(() {
        _isLoaded = true;
      });
    } else {
      showAlert(context, "Location Permission Error", "Location permission either disable or disabled. Please enable to enjoy the full experience.");
    }
  }

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
                        children:[
                          topBar("home", height, width, 'assets/img/homeTop.png'),
                          SizedBox(height: 10),
                          textMajor("find places", Colors.black, 26),
                          _searchTools(0.80 * width, 0.3 * height),
                          Image.asset("assets/img/stringAccent.png"),
                          textMajor("explore", Colors.black, 26),
                          recommendedList(_places, height, width),
                          SizedBox(height: 20)
                        ]
                    )
                )
            )
    ) :
    Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
