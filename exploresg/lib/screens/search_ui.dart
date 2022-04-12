import 'dart:math';
import 'dart:collection';
import 'package:exploresg/helper/search_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:exploresg/screens/place_ui.dart';

import 'package:exploresg/helper/utils.dart';
import 'package:exploresg/helper/places_api.dart';

import 'package:exploresg/models/place.dart';
import 'package:exploresg/helper/location.dart';
import 'package:exploresg/helper/favourites_controller.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchScreenArguments {
  final int max;
  final int min;
  final String sort;
  final String text; //either type chosen from dropdown OR search from searchbar

  SearchScreenArguments(this.max, this.min, this.sort, this.text);
}

class SearchScreen extends StatefulWidget {
  static const routeName = "/search";
  final int max;
  final int min;
  final String sort;
  final String text;

  SearchScreen(this.max, this.min, this.sort, this.text);

  @override
  State<SearchScreen> createState() => _SearchScreen();
}

class _SearchScreen extends State<SearchScreen> {
  FavouritesController _favouritesController = FavouritesController();
  SearchController _searchController = SearchController();
  Locator _locator = new Locator();
  late LatLng _userLoc;
  bool _isLoaded = false;
  List<Place>? _places = [];
  List<double> _distance = [];
  List<String> _favourites = [];

  void initState() {
    super.initState();
    _loadPage();
  }

  Widget _topVector() {
    double _width = MediaQuery.of(context).size.width;
    return SafeArea(
      top: true,
      child: FittedBox(
        fit: BoxFit.fill,
        child: SvgPicture.asset(
          'assets/img/place-top.svg',
          width: _width,
          height: _width * 116 / 375,
        ),
      ),
    );
  }

  Widget _back() {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.only(left: 16),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Row(
          children: [
            Icon(Icons.arrow_back_ios, color: Color(0xff22254C)),
            Text("back",
                style: TextStyle(
                    fontFamily: 'AvenirLtStd',
                    fontSize: 14,
                    color: Color(0xff22254C)))
          ],
        ),
      ),
    );
  }

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

  Widget _addFav(Place place, double height, double width) {
    return Container(
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () async {
                  await _favouritesController.addOrRemoveFav(place.id);
                  _favourites = await _favouritesController.getFavouritesList();
                  print("<3 pressed");
                  setState(() {
                    place.likes = !place.likes;
                  });
                  print(place.likes);
                },
                  child: _favourites.contains(place.id)
                      ? Icon(
                    Icons.favorite,
                    color: Color(0xffE56372),
                  )
                      : Icon(
                    Icons.favorite_border,
                    color: Color(0xffE56372),
                  )),
              SizedBox(
                width: 10,
              ),
              textMinor(
                  _favourites.contains(place.id)
                      ? 'added to favourites'
                      : "add to favourites",
                  Color(0xffD1D1D6))
            ],
          ),
        ],
      ),
    );
  }

  Widget _printSearch(List<Place> places, double height, double width) {
    return Container(
      height: height,
      width: width,
      child: ListView.builder(
        shrinkWrap: true,
        //physics: NeverScrollableScrollPhysics(),
        itemCount: places.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Stack(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, PlaceScreen.routeName,
                          arguments: PlaceScreenArguments(
                              _places![index], _favourites));
                    },
                    child: placeContainer(
                      places[index],
                      0.8 * width,
                      0.215 * height,
                      _addFav(places[index], 0.05 * height, 0.8 * width,),
                      Container(),
                        _userLoc != null ? calculateDistance(_userLoc.latitude, _userLoc.longitude, double.parse(_places![index].coordinates["lat"]!), double.parse(_places![index].coordinates["long"]!)) : 0.0
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
            ],
          );
        },
      ),
    );
  }

  void _loadPage() async {
    var result = await _locator.getCurrentLocation();
    if (result != null) {
      _userLoc = result;
    }
    _places = await _searchController.loadSearch(
        context,
        SearchScreenArguments(
            widget.max, widget.min, widget.sort, widget.text));
    if (_places == null) {
      print("null");
    }
    // _favourites = await _favouritesController
    //     .getFavouritesList(); // i think this function can be defined in a controller class instead
    setState(() {
      _isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    ;
    return _isLoaded
        ? Scaffold(
            // appBar: AppBar(
            //   // Here we take the value from the MyHomePage object that was created by
            //   // the App.build method, and use it to set our appbar title.
            //   //title: Text(widget.title),
            //   backgroundColor: Color(0xfffffcec),
            //   automaticallyImplyLeading: true,
            //   leading: IconButton(
            //     icon: Icon(Icons.arrow_back, color: Colors.grey),
            //     onPressed: () => Navigator.pop(context, false),
            //   ),
            // ),
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
                    _topVector(),
                    _back(),
                    SizedBox(
                      height: 7,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        'search results',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'MadeSunflower',
                            fontSize: 36,
                            color: Color(0xff22254C)),
                      ),
                    ),
                    SizedBox(height: 20),
                    _printSearch(_places!, height, width),
                  ],
                ),
              ),
            ),
          )
        : Container(
      color: Color(0XffFFF9ED),
      child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
