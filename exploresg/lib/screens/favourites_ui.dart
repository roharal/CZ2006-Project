import 'package:exploresg/helper/favourites_controller.dart';
import 'package:exploresg/helper/places_api.dart';
import 'package:exploresg/helper/utils.dart';
import 'package:exploresg/screens/place_ui.dart';
import 'package:flutter/material.dart';
import 'package:exploresg/models/place.dart';

class FavouriteScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FavouriteScreen();
  }
}

class _FavouriteScreen extends State<FavouriteScreen> {
  PlacesApi _placesApi = PlacesApi();
  List<String> _favourites = [];
  List<Place> _favourite_places = [];
  bool _isLoaded = false;
  FavouritesController _favouritesController = FavouritesController();

  @override
  void initState() {
    super.initState();
    _loadFavourites();
  }

  Widget _addFav(int index, Place place, double height, double width) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20))),
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
                  _favourite_places = await _favouritesController.removeFavourites(index, _favourite_places);
                  setState(() {});
                },
                child: _favourites.contains(place.id)
                    ? Icon(
                        Icons.favorite,
                        color: Color(0xffE56372),
                      )
                    : Icon(
                        Icons.favorite_border,
                        color: Color(0xffE56372),
                      ),
              ),
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
            Stack(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, PlaceScreen.routeName,
                        arguments:
                            PlaceScreenArguments(places[index], _favourites));
                  },
                  child: placeContainer(
                      places[index],
                      0.8 * width,
                      0.215 * height,
                      _addFav(index, places[index], 0.05 * height, 0.8 * width),
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
    );
  }

  Future<void> _loadFavourites() async {
    _favourite_places = [];
    _favourites = await _favouritesController.getFavouritesList();
    if (_favourites != []) {
      for (var fav in _favourites) {
        var _place = await _placesApi.placeDetailsSearchFromText(fav);
        _favourite_places.add(_place!);
      }
    } else {
      _favourite_places = [];
    }
    setState(() {
      _isLoaded = true;
    });
  }

  // Widget _addFav(Place place) {
  //   return Expanded(
  //       child: Row(
  //           crossAxisAlignment: CrossAxisAlignment.end,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //         Row(children: [
  //           InkWell(
  //               onTap: () {
  //                 print("<3 pressed");
  //                 setState(() {
  //                   place.likes = !place.likes;
  //                 });
  //                 print(place.likes);
  //               },
  //               child: place.likes
  //                   ? Icon(
  //                       Icons.favorite,
  //                       color: Colors.red,
  //                     )
  //                   : Icon(
  //                       Icons.favorite_border,
  //                       color: Colors.grey,
  //                     )),
  //           SizedBox(
  //             width: 10,
  //           ),
  //           textMinor("add to favourites", Colors.black)
  //         ])
  //       ]));
  // }

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
              _loadFavourites();
            },
            child: Scaffold(
              backgroundColor: Color(0xFFFFF9ED),
              body: Container(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      topBar("favourites", height, width,
                          'assets/img/favourites-top.svg'),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      recommendedList(_favourite_places, height, width),
                      SizedBox(height: 20)
                    ],
                  ),
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
