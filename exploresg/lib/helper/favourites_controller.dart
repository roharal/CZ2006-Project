import 'package:exploresg/helper/authController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavouritesController {
  AuthController _auth = AuthController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void updateFavOnDB(uid, favourites) async {
    await _firestore
        .collection("users")
        .doc(uid)
        .update({"favourites": favourites});
  }

  Future<void> addOrRemoveFav(placeID) async {
    String uid = _auth.getCurrentUser()!.uid;
    String favourites = '';
    await _firestore.collection("users").doc(uid).get().then((value) {
      favourites = value["favourites"];
    });
    if (favourites == '') {
      favourites = placeID;
    } else {
      List favourites_list = favourites.split(',');
      if (favourites_list.contains(placeID)) {
        favourites_list.remove(placeID);
        favourites = favourites_list.join(',');
      } else {
        favourites = favourites + ',' + placeID;
      }
    }
    updateFavOnDB(uid, favourites);
  }

  Future<List<String>> getFavouritesList() async {
    String uid = _auth.getCurrentUser()!.uid;
    String favourites = '';
    await _firestore.collection("users").doc(uid).get().then((value) {
      favourites = value["favourites"];
    });
    if (favourites == '') {
      return [];
    }
    return favourites.split(',');
  }

  Future<bool> isUserFavourite(place) async {
    String uid = _auth.getCurrentUser()!.uid;
    await _firestore.collection("users").doc(uid).get().then((value) {
      String favourites = value["favourites"];
      List favourites_list = favourites.split(',');
      return favourites_list.contains(place.id);
    });
    return false;
  }
}
