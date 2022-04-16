import 'dart:math';

import 'package:exploresg/helper/location_controller.dart';
import 'package:exploresg/helper/places_api.dart';
import 'package:exploresg/helper/utils.dart';
import 'package:exploresg/models/place.dart';
import 'package:exploresg/helper/auth_controller.dart';
import 'package:flutter/material.dart';

class HomeController {
  AuthController _auth = AuthController();
  PlacesApi _placesApi = PlacesApi();
  var rng = Random();

  Future<List<Place>?> loadRecommendations(BuildContext context) async {
    String uid = _auth.getCurrentUser()!.uid;
    String interest = '';
    Locator locator = new Locator();
    var coor = await locator.getCurrentLocation();
    if (coor != null) {
      List<Place> _mixPlaces = [];
      await _auth.getUserFromId(uid).then((value) {
        interest = value['interest'];
      }).onError((error, stackTrace) {
        showAlert(context, 'Retrieve User Profile', error.toString());
      });
      if (interest != '') {
        var split = interest.split(',');
        for (String s in split) {
          var result = await _placesApi.nearbySearchFromText(
              coor.latitude.toString(),
              coor.longitude.toString(),
              10000,
              '&type=$s');
          for (var i in result!) {
            _mixPlaces.add(i);
          }
        }
        _mixPlaces = (_mixPlaces..shuffle());
        while (_mixPlaces.length > 5) {
          _mixPlaces.removeLast();
        }
      } else {
        var split = placeType..shuffle();
        for (String s in split.sublist(3,6)) {
          var result = await _placesApi.nearbySearchFromText(
              coor.latitude.toString(),
              coor.longitude.toString(),
              10000,
              '&type=$s');
          for (var i in result!) {
            _mixPlaces.add(i);
          }
        }
        _mixPlaces = (_mixPlaces..shuffle());
        while (_mixPlaces.length > 5) {
          _mixPlaces.removeLast();
        }
      }
      return _mixPlaces;
    } else {
      showAlert(context, 'Location Permission Error',
          'Location permission either disable or disabled. Please enable to enjoy the full experience.');
      return null;
    }
  }
}
