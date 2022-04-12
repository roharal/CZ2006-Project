import 'package:exploresg/helper/home_controller.dart';
import 'package:exploresg/helper/location.dart';
import 'package:exploresg/screens/search_ui.dart';
import 'package:exploresg/screens/place_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:exploresg/helper/utils.dart';
import 'package:exploresg/models/place.dart';

import 'package:exploresg/helper/favourites_controller.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends State<HomeScreen> {
  String _placeTypeDropdownValue = 'airport',
      _filterByDropdownValue = 'filter by',
      _prevFilter = '';
  bool _searchByCategory = false, _isLoaded = false;
  TextEditingController _searchController = new TextEditingController();
  HomeController _homeController = HomeController();
  FavouritesController _favouritesController = FavouritesController();
  Locator _locator = Locator();
  List<Place>? _places = [];
  List<String> _favourites = [];
  late LatLng _userLoc;

  @override
  void initState() {
    super.initState();
    _loadPage();
  }

  Future<void> _loadPage() async {
    var result = await _locator.getCurrentLocation();
    if (result != null) {
      _userLoc = result;
    }
    _places = await _homeController.loadRecommendations(context);
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
      labelStyle: TextStyle(color: Color(0xff22254C), fontSize: 16));

  Widget _dropDownList(double width, DropdownButtonFormField DDL) {
    return Container(
        width: width,
        padding: EdgeInsets.symmetric(horizontal: 0.1 * width),
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.white),
        child: DDL);
  }

  RangeValues _priceValues = RangeValues(0, 4);
  RangeValues _ratingValues = RangeValues(1, 5);

  int _minFilter = 0;
  int _maxFilter = 4;
  double _distValue = 15000;

  Widget _ratingFilter(double width) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildSideLabel(
              _minFilter.toString(),
            ),
            Expanded(
              child: RangeSlider(
                values: _ratingValues,
                min: 1,
                max: 5,
                divisions: 5,
                labels: RangeLabels(
                  _ratingValues.start.round().toString(),
                  _ratingValues.end.round().toString(),
                ),
                onChanged: (values) {
                  setState(() {
                    _ratingValues = values;
                    _minFilter = values.start.round();
                    _maxFilter = values.end.round();
                  });
                },
              ),
            ),
            buildSideLabel(_maxFilter.toString()),
          ],
        ));
  }

  Widget _priceFilter(double width) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildSideLabel(_minFilter.toString()),
            Expanded(
              child: RangeSlider(
                values: _priceValues,
                min: 0,
                max: 4,
                divisions: 4,
                labels: RangeLabels(
                  _priceValues.start.round().toString(),
                  _priceValues.end.round().toString(),
                ),
                onChanged: (values) {
                  setState(() {
                    _priceValues = values;
                    _minFilter = values.start.round();
                    _maxFilter = values.end.round();
                  });
                },
              ),
            ),
            buildSideLabel(_maxFilter.toString()),
          ],
        ));
  }

  Widget _distanceFilter(double width) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildSideLabel('0 km'),
            Expanded(
              child: CupertinoSlider(
                activeColor: Color(0xff6488E5),
                value: _distValue,
                min: 0,
                max: 15000,
                divisions: 1500,
                onChanged: (value) {
                  setState(() {
                    _distValue = value;
                    _maxFilter = value.round();
                    _minFilter = 0;
                  });
                },
              ),
            ),
            buildSideLabel((_maxFilter / 1000).toString() + 'km'),
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

  Widget _displayFiltered(double width) {
    if (_filterByDropdownValue == 'distance') {
      if (_prevFilter != _filterByDropdownValue) {
        setState(() {
          _minFilter = 0;
          _maxFilter = 15000;
          _distValue = 15000;
        });
      }
      _prevFilter = _filterByDropdownValue;
      return _distanceFilter(width);
    } else if (_filterByDropdownValue == 'ratings') {
      if (_prevFilter != _filterByDropdownValue) {
        setState(() {
          _minFilter = 1;
          _maxFilter = 5;
          _priceValues = RangeValues(0, 4);
        });
      }
      _prevFilter = _filterByDropdownValue;
      return _ratingFilter(width);
    } else if (_filterByDropdownValue == 'price') {
      if (_prevFilter != _filterByDropdownValue) {
        setState(() {
          _minFilter = 0;
          _maxFilter = 4;
          _ratingValues = RangeValues(1, 5);
        });
      }
      _prevFilter = _filterByDropdownValue;
      return _priceFilter(width);
    } else {
      // setState(() {});
      return SizedBox.shrink();
    }
  }

  Widget _filterDropDown(double width) {
    return _dropDownList(
      0.49 * width,
      DropdownButtonFormField<String>(
        icon: Icon(Icons.arrow_drop_down, color: Color(0xffD1D1D6)),
        items: [
          DropdownMenuItem(
              child: textMinor('filter by', Color(0xffD1D1D6)),
              value: 'filter by'),
          DropdownMenuItem(
              child: textMinor('distance', Color(0xff22254C)),
              value: 'distance'),
          DropdownMenuItem(
              child: textMinor('ratings', Color(0xff22254C)), value: 'ratings'),
          DropdownMenuItem(
              child: textMinor('price', Color(0xff22254C)), value: 'price')
        ],
        decoration: dropdownDeco,
        isExpanded: true,
        value: _filterByDropdownValue,
        onChanged: (String? newValue) {
          setState(() {
            _filterByDropdownValue = newValue!;
            _displayFiltered(width);
          });
        },
      ),
    );
  }

  Widget _placeTypeDropDown(double width) {
    return _dropDownList(
      width,
      DropdownButtonFormField(
        icon: Icon(Icons.arrow_drop_down, color: Color(0xffD1D1D6)),
        items: placeType
            .map((String e) => DropdownMenuItem(
                value: e,
                child: textMinor(e.replaceAll("_", " "), Color(0xff22254C))))
            .toList(),
        decoration: dropdownDeco,
        isExpanded: true,
        value: _placeTypeDropdownValue,
        onChanged: (newValue) {
          setState(() {
            _placeTypeDropdownValue = newValue!;
          });
        },
      ),
    );
  }

  Widget _searchBar(double width, double height) {
    return Container(
      width: width,
      height: height / 5,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
        controller: _searchController,
        cursorColor: Colors.grey,
        cursorHeight: 14.0,
        style: TextStyle(
            fontFamily: 'AvenirLtStd', fontSize: 14, color: Color(0xff22254C)),
        decoration: new InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: Color(0xffD1D1D6),
          ),
          hintText: 'type a place...',
          hintStyle: TextStyle(
              fontFamily: 'AvenirLtStd',
              fontSize: 14,
              color: Color(0xffD1D1D6)),
          contentPadding: EdgeInsets.zero,
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
    );
  }

  Widget _searchSwitch() {
    return Transform.scale(
      transformHitTests: false,
      scale: .7,
      child: CupertinoSwitch(
        activeColor: Color(0xff6488E5),
        trackColor: Color(0xff6488E5), //change to closer colour
        value: _searchByCategory,
        onChanged: (value) {
          setState(() {
            _searchByCategory = !_searchByCategory;
          });
        },
      ),
    );
  }

  Widget _goButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Color(0xff6488E5)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ))),
        onPressed: () {
          Navigator.pushNamed(context, SearchScreen.routeName,
              arguments: _searchByCategory == false //using input searchbar
                  ? SearchScreenArguments(_maxFilter, _minFilter,
                  _filterByDropdownValue, _searchController.text)
                  : SearchScreenArguments(
                //using place type dropdown
                _maxFilter,
                _minFilter,
                _filterByDropdownValue,
                _placeTypeDropdownValue,
              ));
        },
        child: Text('go!',
            style: TextStyle(
                fontFamily: 'AvenirLtStd', fontSize: 16, color: Colors.white)),
      ),
    );
  }

  Widget _searchTools(double width, double height) {
    return Container(
      width: width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              textMinor('keyword search',
                  _searchByCategory ? Color(0xffD1D1D6) : Color(0xff22254C)),
              _searchSwitch(),
              textMinor('dropdown list',
                  _searchByCategory ? Color(0xff22254C) : Color(0xffD1D1D6))
            ],
          ),
          _searchByCategory == false
              ? _searchBar(width, height)
              : _placeTypeDropDown(width),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(width: 0.02 * width),
            _filterDropDown(width)
          ]),
          _displayFiltered(width),
          _goButton()
        ],
      ),
    );
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
          Row(
            children: [
              InkWell(
                  onTap: () async {
                    await _favouritesController.addOrRemoveFav(place.id);
                    _favourites =
                        await _favouritesController.getFavouritesList();
                    setState(() {
                      place.likes = !place.likes;
                    });
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

  Widget recommendedList(List<Place> places, double height, double width) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: places.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Stack(children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, PlaceScreen.routeName,
                      arguments:
                          PlaceScreenArguments(_places![index], _favourites));
                },
                child: placeContainer(
                    places[index],
                    0.8 * width,
                    0.24 * height,
                    _addFav(places[index], 0.05 * height, 0.8 * width),
                    Container(),
                    _userLoc != null
                        ? calculateDistance(
                            _userLoc.latitude,
                            _userLoc.longitude,
                            double.parse(_places![index].coordinates["lat"]!),
                            double.parse(_places![index].coordinates["long"]!))
                        : 0.0),
              ),
            ]),
            SizedBox(
              height: 15,
            ),
          ],
        );
      },
    );
  }

  Future<void> _reload() async {
    _isLoaded = false;
    _places = await _homeController.loadRecommendations(context);
    setState(() {
      _isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return _isLoaded
        ? RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _isLoaded = false;
              });
              _reload();
            },
            child: Scaffold(
              body: Container(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _reload();
                        },
                        child: topBar(
                            'home', height, width, 'assets/img/home-top.svg'),
                      ),
                      SizedBox(height: 30),
                      textMajor('find places', Color(0xff22254C), 26),
                      SizedBox(
                        height: 7,
                      ),
                      _searchTools(0.80 * width, 0.3 * height),
                      FittedBox(
                          fit: BoxFit.fill,
                          child: SvgPicture.asset('assets/img/home-mid.svg',
                              width: width, height: width)),
                      textMajor('explore', Color(0xff22254C), 26),
                      recommendedList(_places!, height, width),
                      SizedBox(height: 20)
                    ],
                  ),
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
