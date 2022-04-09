import 'auth.dart';
import 'package:exploresg/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserController {
  Auth _auth = Auth();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
}
