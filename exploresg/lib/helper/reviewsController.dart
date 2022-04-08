import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exploresg/models/place.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ReviewsController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseMessaging _fcm = FirebaseMessaging.instance;

  //create review
  Future createReview(String placeID, String userID, Map<String, dynamic> data) async {
    bool placeExists = await checkPlaceExist(placeID);

    if(!placeExists) {
      await _firestore
          .collection("place")
          .doc(placeID)
          .collection('reviews');
    }
    await _firestore
        .collection("place/$placeID/reviews")
        .doc(userID)
        .set(data);
  }

  //read all reviews
  Future<DocumentSnapshot> getReviews(String placeID) async {
    var placeReviews;
    // check if a place document exists already
    bool placeExists = await checkPlaceExist(placeID);
    if (placeExists) {
      placeReviews = await _firestore.collection("place/$placeID/reviews").doc().get();
    } else {
      placeReviews = null;
    }
    return placeReviews;
  }

  //update review
  Future updateReview(String placeID, String userID, Map<String, dynamic> data) async {
    await _firestore.collection("place/$placeID/reviews").doc(userID).update(data);
  }

  //delete review
  Future deleteReview(String placeID, String userID) async {
    await _firestore.collection("place/$placeID/reviews").doc(userID).delete();
  }

  //tabulate exploreSG ratings
  // Future<double> tabulateRatings(String placeID) async{
  //   var placeReviews;
  //   // check if a place document exists already
  //   bool placeExists = await checkPlaceExist(placeID);
  //   if (placeExists) {
  //     placeReviews = await _firestore.collection("place/$placeID/reviews").doc().get();
  //   } else {
  //     return 0;
  //   }
  // }

  Future<DocumentSnapshot> getPlaceFromId(String id) async {
    return await _firestore.collection("place").doc(id).get();
  }

  Future<bool> checkPlaceExist(String id) async {
    var result = await this.getPlaceFromId(id);
    return result.exists;
  }
}
