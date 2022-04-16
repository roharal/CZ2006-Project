import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:exploresg/helper/auth_controller.dart';
import 'package:exploresg/models/review.dart';
import 'package:exploresg/models/user.dart';

class ReviewsController {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AuthController _authController = AuthController();

  //create review
  Future createReview(Review review) async {
    bool exists = await placeExists(review.getPlaceID());
    DocumentReference placeReviewRef =
        _firestore.collection('place').doc(review.getPlaceID());

    DocumentReference reviewRef = _firestore
        .collection('place/${review.getPlaceID()}/reviews')
        .doc(review.getUserID());

    if (!exists) {
      //create the place first
      PlaceRating placeRating = PlaceRating(0.0, 0);
      await placeReviewRef.set(placeRating.toJson());
    }

    await reviewRef.set(review.toJson()); //add user review

    //update place average rating and number ratings fields
    await placeReviewRef.get().then((value) async {
      PlaceRating placeRating = PlaceRating.fromSnapshot(value);
      placeRating.addRating(review.getUserRating());

      await placeReviewRef.update(placeRating.toJson());
    });
  }

  //update review
  Future updateReview(Review review) async {
    DocumentReference placeReviewRef =
        _firestore.collection('place').doc(review.getPlaceID());

    DocumentReference reviewRef = _firestore
        .collection('place/${review.getPlaceID()}/reviews')
        .doc(review.getUserID());

    var prevData = await reviewRef.get();
    Review prevReview = Review.fromSnapshot(prevData);

    await reviewRef.update(review.toJson()); //update user review

    //update place average rating and number ratings fields
    await placeReviewRef.get().then((value) async {
      PlaceRating placeRating = PlaceRating.fromSnapshot(value);
      placeRating.deductRating(
          prevReview.getUserRating(), review.getUserRating());

      await placeReviewRef.update(placeRating.toJson());
    });
  }

  //delete review -- not used
  Future deleteReview(Review review) async {
    await _firestore
        .collection('place/${review.getPlaceID()}/reviews')
        .doc(review.getUserID())
        .delete();
  }

  //calculate mean rating -- not used right now
  Future<double> meanRating(String placeID) async {
    List<double> ratingsList = [];

    await _firestore
        .collection('place/$placeID/reviews')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((user) {
        ratingsList.add(user['rating']);
      });
    });

    if (ratingsList.isEmpty) {
      return 0;
    }

    double sum = ratingsList.sum;
    double mean = sum / (ratingsList.length);
    return mean;
  }

  Future<PlaceRating> getPlaceRating(String placeID) async => await _firestore.collection('place').doc(placeID).get().then((value) {
      if (value.exists) {
        return PlaceRating.fromSnapshot(value);
      } else {
        return PlaceRating(0.0, 0);
      }
    });

  Future<bool> placeExists(String placeID) async {
    var result = await _firestore.collection('place').doc(placeID).get();
    return result.exists;
  }

  Future<bool> userReviewExists(String placeID, String userID) async {
    var userReview =
        await _firestore.collection('place/$placeID/reviews').doc(userID).get();
    return userReview.exists;
  }

  Future<Review?> getReview(String placeID, String userID) async {
    var userReview =
        await _firestore.collection('place/$placeID/reviews').doc(userID).get();
    if (userReview.exists) {
      return Review.fromSnapshot(userReview);
    }
    return null;
  }

  Future<List<Review>> returnAllReviews(String placeID) async {
    List<Review> reviewsList = [];
    await _firestore
        .collection('place/$placeID/reviews')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((snapshot) async {
        Review temp = Review.fromSnapshot(snapshot);
        reviewsList.add(temp);
      });
    });
    return reviewsList;
  }

  Future<String> getUserName(String userID) async {
    var user = await _authController.getUserFromId(userID);
    if (user.exists) {
      UserModel userModel = UserModel.fromSnapshot(user);
      String displayName =
          userModel.getFirstName() + ' ' + userModel.getLastName();
      return displayName;
    }
    return '';
  }

  Future<String> getPFP(String userID) async {
    var user = await _authController.getUserFromId(userID);
    if (user.exists) {
      UserModel userModel = UserModel.fromSnapshot(user);
      return userModel.getPicture();
    }
    return '';
  }
}
