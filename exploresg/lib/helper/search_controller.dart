import 'dart:collection';

import 'package:exploresg/helper/location.dart';
import 'package:exploresg/helper/places_api.dart';
import 'package:exploresg/helper/utils.dart';
import 'package:exploresg/models/place.dart';
import 'package:exploresg/screens/search_ui.dart';
import 'package:flutter/cupertino.dart';

class SearchController {
  List<double> _distance = [];

  // List<String> _favourites = [];

  Future<List<Place>?> loadSearch(
      BuildContext context, SearchScreenArguments arguments) async {
    List<Place> places = [], filteredPlace = [];
    PlacesApi _placesApi = PlacesApi();

    Locator location = new Locator();
    var userLoc = await location.getCurrentLocation();

    if (userLoc != null) {
      String lat = userLoc.latitude.toString();
      String long = userLoc.longitude.toString();

      switch (arguments.sort) {
        case 'distance':
          {
            var places = placeType.contains(arguments.text)
                ? await _placesApi.nearbySearchFromText(
                    lat,
                    long,
                    arguments.max,
                    "&type=" + arguments.text,
                  )
                : await _placesApi.nearbySearchFromText(
                    lat,
                    long,
                    arguments.max,
                    "&keyword=" + arguments.text,
                  );

            filteredPlace.clear();
            var distMap = {};
            for (var i in places!) {
              //FN TO SORT PLACES BY DIST
              distMap[i] = calculateDistance(
                  userLoc.latitude,
                  userLoc.longitude,
                  double.parse(i.coordinates["lat"]!),
                  double.parse(i.coordinates["long"]!));
            }
            var sortedKeys = distMap.keys.toList(growable: false)
              ..sort((a, b) => distMap[a].compareTo(distMap[b]));

            LinkedHashMap sortedMap = new LinkedHashMap.fromIterable(sortedKeys,
                key: (k) => k, value: (k) => distMap[k]);
            for (var i in sortedMap.values) {
              _distance.add(double.parse(i.toStringAsFixed(2)));
            }

            for (var i in sortedKeys) {
              filteredPlace.add(i);
            }
            break;
          }

        case 'ratings':
          {
            var places = placeType.contains(arguments.text)
                ? await _placesApi.nearbySearchFromText(
                    lat,
                    long,
                    20000,
                    "&type=" + arguments.text,
                  )
                : await _placesApi.nearbySearchFromText(
                    lat,
                    long,
                    20000,
                    "&keyword=" + arguments.text,
                  );

            filteredPlace.clear();
            var ratingsMap = {};
            for (var i in places!) {
              if (arguments.min <= i.ratings && i.ratings <= arguments.max) {
                print("price");
                print(i.price);
                ratingsMap[i] = i.ratings;
              }
            }
            var sortedKeys = ratingsMap.keys.toList(growable: false)
              ..sort((a, b) => ratingsMap[a].compareTo(ratingsMap[b]));

            for (var i in sortedKeys) {
              filteredPlace.add(i);
            }
            break;
          }

        case 'price':
          {
            var places = placeType.contains(arguments.text)
                ? await _placesApi.nearbySearchFromText(lat, long, 20000,
                    "&type=" + arguments.text, arguments.max, arguments.min)
                : await _placesApi.nearbySearchFromText(lat, long, 20000,
                    "&keyword=" + arguments.text, arguments.max, arguments.min);

            filteredPlace.clear();
            var priceMap = {};

            for (var i in places!) {
              priceMap[i] = i.price;
            }

            var sortedKeys = priceMap.keys.toList(growable: false)
              ..sort((a, b) => priceMap[a].compareTo(priceMap[b]));

            for (var i in sortedKeys) {
              filteredPlace.add(i);
            }
            break;
          }
        default:
          {
            var places = placeType.contains(arguments.text)
                ? await _placesApi.nearbySearchFromText(
                    lat,
                    long,
                    20000,
                    "&type=" + arguments.text,
                  )
                : await _placesApi.nearbySearchFromText(
                    lat,
                    long,
                    20000,
                    "&keyword=" + arguments.text,
                  );

            for (var i in places!) {
              filteredPlace.add(i);
            }
            break;
          }
      }
      return filteredPlace;
    } else {
      showAlert(context, "Location Permission Error",
          "Location permission either disable or disabled. Please enable to enjoy the full experience.");
      return null;
    }
  }
}
