import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';

import '../models/review.dart';

class ReviewsController {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //create review
  Future createReview(String placeID, String userID, Map<String, dynamic> data) async {
    bool exists = await placeExists(placeID);

    if(!exists) { //create the place first
      await _firestore.collection("place").doc(placeID).collection('reviews');
      await _firestore.collection("place").doc(placeID).set({'average_rating': 0.0, 'total_num_ratings': 0});
    }

    await _firestore.collection("place/$placeID/reviews").doc(userID).set(data); //add user review

    //update place average rating and number ratings fields
    var placeData = await _firestore.collection("place").doc(placeID).get();
    Map<String, dynamic> dataMap = placeData.data()!;
    int totalNumRatings = dataMap['total_num_ratings'] + 1; //add this user's new review
    double averageRating = (dataMap['average_rating'] + data['rating'])/totalNumRatings; //calculate mean
    await _firestore.collection("place").doc(placeID)
        .set({'average_rating': averageRating, 'total_num_ratings': totalNumRatings});
  }

  //update review
  Future updateReview(String placeID, String userID, Map<String, dynamic> data) async {
    var prevData = await _firestore.collection("place/$placeID/reviews").doc(userID).get();
    Map<String, dynamic> d1 = prevData.data()!;
    double prevRating = d1['rating'];

    await _firestore.collection("place/$placeID/reviews").doc(userID).update(data); //update user review

    //update place average rating and number ratings fields
    var placeData = await _firestore.collection("place").doc(placeID).get();
    Map<String, dynamic> d2 = placeData.data()!;
    int totalNumRatings = d2['total_num_ratings'];
    double ratingsSum = d2['average_rating']*totalNumRatings;
    double averageRating = (ratingsSum - prevRating + data['rating'])/totalNumRatings; //minus previous rating, add new rating
    await _firestore.collection("place").doc(placeID)
        .set({'average_rating': averageRating, 'total_num_ratings': totalNumRatings});
  }

  //delete review -- not used
  Future deleteReview(String placeID, String userID) async {
    await _firestore.collection("place/$placeID/reviews").doc(userID).delete();
  }

  //calculate mean rating -- not used right now
  Future<double> meanRating(String placeID) async {
    List<double> ratingsList = [];

    await _firestore.collection("place/$placeID/reviews").get().then((querySnapshot){
      querySnapshot.docs.forEach((user) {
        ratingsList.add(user['rating']);
      });
    });

    if(ratingsList.isEmpty){
      return 0;
    }

    double sum = ratingsList.sum;
    double mean = sum/(ratingsList.length);
    return mean;
  }

  Future<double> getAverageRating(String placeID) async{
    var placeData = await _firestore.collection("place").doc(placeID).get();
    if (placeData.exists) {
      Map<String, dynamic> data = placeData.data()!;
      var aveRating = data['average_rating'];
      return aveRating;
    }
    return 0;
  }

  Future<bool> placeExists(String placeID) async {
    var result = await _firestore.collection("place").doc(placeID).get();
    return result.exists;
  }

  Future<bool> userReviewExists(String placeID, String userID) async {
    var userReview = await _firestore.collection("place/$placeID/reviews").doc(userID).get();
    return userReview.exists;
  }

  Future<Review?> getReview(String placeID, String userID) async {
    var userReview = await _firestore.collection("place/$placeID/reviews").doc(userID).get();
    if (userReview.exists) {
      Map<String, dynamic> data = userReview.data()!;
      Review r = Review(placeID, userID, data['review_text'], data['rating']);
      return r;
    }
    return null;
  }

  Future<List<Review>> returnAllReviews(String placeID) async {
    bool exists = await placeExists(placeID);
    if(!exists)
      return [];

    List<Review> reviewsList = [];
    await _firestore.collection("place/$placeID/reviews").get().then((querySnapshot){
      querySnapshot.docs.forEach((user) async {
        Review temp = Review(placeID, user['userID'], user['review_text'], user['rating']);
        reviewsList.add(temp);
      });
    });
    return reviewsList;
  }

  Future<String> getUserName(String userID) async {
    var user = await _firestore.collection("users").doc(userID).get();
    if (user.exists) {
      Map<String, dynamic> data = user.data()!;
      String displayName = data['firstName'] + ' ' + data['lastName'];
      return displayName;
    }
    return '';
  }
  Future<String> getPFP(String userID) async {
    var user = await _firestore.collection("users").doc(userID).get();
    if (user.exists) {
      Map<String, dynamic> data = user.data()!;
      String pfp = data['picture'];
      return pfp;
    }
    return '';
  }
}
