import 'dart:convert';

import 'package:exploresg/models/place.dart';
import 'package:http/http.dart';

//address_component, adr_address, business_status, formatted_address,
//geometry, icon, icon_mask_base_uri, icon_background_color, name, photo,
//place_id, plus_code, type, url, utc_offset, vicinity

class PlacesApi {
  final String API_KEY = "AIzaSyDsNDWloKgHeY_W2prK_qPOUXALiL390VY";
  Client _client = Client();
  String findPlacesURL =
      "https://maps.googleapis.com/maps/api/place/findplacefromtext/json";
  String autoCompleteURL =
      "http://maps.googleapis.com/maps/api/place/autocomplete/json";
  String placesPhotoURL = "https://maps.googleapis.com/maps/api/place/photo";
  String textSearchURL =
      "https://maps.googleapis.com/maps/api/place/textsearch/json";
  String nearbySearchURL =
      "https://maps.googleapis.com/maps/api/place/nearbysearch/json";
  String placeDetailsSearchURL =
      "https://maps.googleapis.com/maps/api/place/details/json";

  Future<List<Place>?> nearbySearchFromText(
      String lat, String long, int radius, String type, String input) async {
    List<Place> places = [];
    final request = Uri.parse(
        "$nearbySearchURL?location=$lat%2C$long&radius=$radius&type=$type$input&key=$API_KEY");
    final response = await _client.get(request);
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result["status"] == "OK") {
        for (dynamic n in result["results"]) {
          Map<String, String> coor = {};
          var lat = n["geometry"]["location"]["lat"];
          var long = n["geometry"]["location"]["lng"];
          coor["lat"] = lat.toString();
          coor["long"] = long.toString();
          List<String> photos = [];
          if (n["photos"] != null) {
            List<dynamic> np = n["photos"];
            for (var p in np) {
              var imageWidth = p["width"];
              var imageRef = p["photo_reference"];
              photos.add(
                  "$placesPhotoURL?maxwidth=$imageWidth&photo_reference=$imageRef&key=$API_KEY");
            }
          }
          var opening = n["opening_hours"];
          bool on = false;
          if (opening != null) {
            on = opening["open_now"];
          }
          Place place = Place(
              n["place_id"],
              n["name"],
              "",
              n["vicinity"],
              n["rating"] == null ? 0.0 : double.parse(n["rating"].toString()),
              false,
              coor,
              n["types"],
              n["user_ratings_total"] == null ? 0 : n["user_ratings_total"],
              photos,
              on);
          places.add(place);
        }
        return places;
      } else {
        print(result["status"]);
        return places;
      }
    } else {
      print(response.statusCode);
      return places;
    }
  }

  Future<Place?> placeDetailsSearchFromText(String place_id) async {
    Place? place;
    final request =
        Uri.parse("$placeDetailsSearchURL?place_id=$place_id&key=$API_KEY");
    final response = await _client.get(request);
    if (response.statusCode == 200) {
      Map<String, dynamic> result = json.decode(response.body);
      if (result["status"] == "OK") {
        dynamic n = result["result"];
        Map<String, String> coor = {};
        var lat = n["geometry"]["location"]["lat"];
        var long = n["geometry"]["location"]["lng"];
        coor["lat"] = lat.toString();
        coor["long"] = long.toString();
        List<String> photos = [];
        if (n["photos"] != null) {
          List<dynamic> np = n["photos"];
          for (var p in np) {
            var imageWidth = p["width"];
            var imageRef = p["photo_reference"];
            photos.add(
                "$placesPhotoURL?maxwidth=$imageWidth&photo_reference=$imageRef&key=$API_KEY");
          }
          var opening = n["opening_hours"];
          bool on = false;
          var opening_hours;
          if (opening != null) {
            on = opening["open_now"];
            opening_hours = opening["weekday_text"];
          }
          print(n["name"]);
          place = Place(
              n["place_id"],
              n["name"],
              "",
              n["vicinity"],
              n["rating"] == null ? 0.0 : double.parse(n["rating"].toString()),
              false,
              coor,
              n["types"],
              n["user_ratings_total"] == null ? 0 : n["user_ratings_total"],
              photos,
              on);
          place.setOpeningHours(opening_hours.cast<String>());
        }
        return place;
      } else {
        print(result["status"]);
        return place;
      }
    } else {
      print(response.statusCode);
      return place;
    }
  }
}
