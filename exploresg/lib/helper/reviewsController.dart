import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';

class ReviewsController {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //create review
  Future createReview(String placeID, String userID, Map<String, dynamic> data) async {
    bool exists = await placeExists(placeID);

    if(!exists) {
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

  //read all reviews (doesnt work)
  Future<DocumentSnapshot> getReviews(String placeID) async {
    var placeReviews;
    // check if a place document exists already
    bool exists = await placeExists(placeID);
    if (exists) {
      placeReviews = await _firestore.collection("place/$placeID/reviews").doc().get();
    } else {
      placeReviews = null;
    }
    print(placeReviews);
    return placeReviews;
  }

  //update review
  Future updateReview(String placeID, String userID, Map<String, dynamic> data) async {
    await _firestore.collection("place/$placeID/reviews").doc(userID).update(data);
  }

  //delete review -- not used
  Future deleteReview(String placeID, String userID) async {
    await _firestore.collection("place/$placeID/reviews").doc(userID).delete();
  }

  //tabulate exploreSG ratings
  // Future<double> tabulateRatings(String placeID) async{
  //   var placeReviews;
  //   // check if a place document exists already
  //   bool exists = await checkPlaceExist(placeID);
  //   if (exists) {
  //     placeReviews = await _firestore.collection("place/$placeID/reviews").doc().get();
  //   } else {
  //     return 0;
  //   }
  // }
  Future<double> meanRating(String placeID) async {
    List<double> _ratingsList = [];

    _firestore.collection("place/$placeID/reviews").get().then((querySnapshot){
      querySnapshot.docs.forEach((user) {
        _ratingsList.add(user['rating']);
      });
    });

    if(_ratingsList.isEmpty){
      return 0;
    }
    double sum = _ratingsList.sum;
    double mean = sum/(_ratingsList.length);
    print(_ratingsList);
    return mean;
  }

  Future<bool> placeExists(String placeID) async {
    var result = await _firestore.collection("place").doc(placeID).get();
    return result.exists;
  }

  Future<bool> userReviewExists(String placeID, String userID) async {
    var userReview = await _firestore.collection("place/$placeID/reviews").doc(userID).get();
    return userReview.exists;
  }

  Future<double> getUserRating(String placeID, String userID) async {
    var userReview = await _firestore.collection("place/$placeID/reviews").doc(userID).get();
    if (userReview.exists) {
      Map<String, dynamic> data = userReview.data()!;
      var rating = data['rating'];
      return rating;
    }
    return 0;
  }

  Future<String> getUserReview(String placeID, String userID) async {
    var userReview = await _firestore.collection("place/$placeID/reviews").doc(userID).get();
    if (userReview.exists) {
      Map<String, dynamic> data = userReview.data()!;
      var review = data['review_text'];
      return review;
    }
    return '';
  }
}
