import 'package:exploresg/helper/places_api.dart';
import 'package:exploresg/models/place.dart';
import 'package:exploresg/helper/authController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecommendationsController {
  AuthController _auth = AuthController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  PlacesApi _placesApi = PlacesApi();

  Future<List<Place>> getRecommendationsList() async {
    String uid = _auth.getCurrentUser()!.uid;
    String interest = "";
    List<Place> _mixPlaces = [];
    await _firestore.collection("users").doc(uid).get().then((value) {
      interest = value["interest"];
    });
    if (interest != "") {
      var split = interest.split(",");
      for (String s in split) {
        var result = await _placesApi.nearbySearchFromText(
            "1.4430557283012149", "103.80793159927359", 10000, s, "");
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
  }
}
