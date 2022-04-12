import 'dart:math';
import 'dart:collection';
import 'package:exploresg/helper/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:exploresg/screens/place_ui.dart';

import 'package:exploresg/helper/utils.dart';
import 'package:exploresg/helper/places_api.dart';

import 'package:exploresg/models/place.dart';
import 'package:exploresg/helper/location.dart';
import 'package:exploresg/helper/favourites_controller.dart';

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
  PlacesApi _placesApi = PlacesApi();
  FavouritesController _favouritesController = FavouritesController();
  SearchController _searchController = SearchController();
  bool _isLoaded = false;
  List<Place>? _places = [];
  List<double> _distance = [];
  List<String> _favourites = [];

  void initState() {
    super.initState();
    _loadPage();
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
              textMinor("add to favourites", Colors.black)
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
        //shrinkWrap: true,
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
                        _addFav(places[index], 0.05 * height, 0.8 * width),
                        Container()),
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
            appBar: AppBar(
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              //title: Text(widget.title),
              backgroundColor: Color(0xfffffcec),
              automaticallyImplyLeading: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.grey),
                onPressed: () => Navigator.pop(context, false),
              ),
            ),
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

                    _printSearch(_places!, height, width)
                  ],
                ),
              ),
            ),
          )
        : Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
