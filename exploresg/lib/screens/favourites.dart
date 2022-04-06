import 'package:exploresg/helper/favourites_controller.dart';
import 'package:exploresg/helper/places_api.dart';
import 'package:exploresg/helper/utils.dart';
import 'package:exploresg/screens/places.dart';
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
                      setState(() {
                        _isLoaded = false;
                      });
                      await _favouritesController.addOrRemoveFav(place.id);
                      _favourites =
                          await _favouritesController.getFavouritesList();
                      _favourite_places = [];
                      if (_favourites != []) {
                        for (var fav in _favourites) {
                          var _place =
                              await _placesApi.placeDetailsSearchFromText(fav);
                          _favourite_places.add(_place!);
                        }
                      }
                      setState(() {
                        print(_favourite_places);
                        place.likes = !place.likes;
                        _isLoaded = true;
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
                      arguments: Places2ScreenArgs(places[index]));
                },
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

  @override
  void initState() {
    super.initState();
    _loadFavourites();
  }

  Future<void> _loadFavourites() async {
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

  @override
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
        ? Scaffold(
            backgroundColor: createMaterialColor(Color(0xFFFFF9ED)),
            body: Container(
                child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                  topBar("favourites", height, width,
                      'assets/img/favouriteTop.png'),
                  SizedBox(
                    height: 20,
                  ),
                  SearchBar(width: 0.8 * width, height: 0.3 * height),
                  SizedBox(
                    height: 10,
                  ),
                  Search(width: 0.8 * width, height: 0.3 * height),
                  SizedBox(
                    height: 30,
                  ),
                  recommendedList(_favourite_places, height, width),
                  SizedBox(height: 20)
                ]))))
        : Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
