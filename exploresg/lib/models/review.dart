import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  String placeID, userID, reviewText;
  double rating;

  Review(this.placeID, this.userID, this.reviewText, this.rating);

  String getPlaceID() {
    return this.placeID;
  }

  String getUserID() {
    return this.userID;
  }

  String getUserReview() {
    return this.reviewText;
  }

  double getUserRating() {
    return this.rating;
  }

  void setPlaceID(placeID) {
    this.placeID = placeID;
  }

  void setUserID(userID) {
    this.userID = userID;
  }

  void setUserReview(review_text) {
    this.reviewText = review_text;
  }

  void setUserRating(rating) {
    this.rating = rating;
  }

  Review.fromSnapshot(DocumentSnapshot snapshot)
      : placeID = snapshot['placeID'],
        userID = snapshot['userID'],
        reviewText = snapshot['reviewText'],
        rating = snapshot['rating'];


  Map<String, dynamic> toJson() =>
      {
        'placeID': placeID,
        'userID': userID,
        'reviewText': reviewText,
        'rating': rating,
      };
}

class PlaceRating {
  double averageRating;
  int totalNumRating;

  PlaceRating(this.averageRating, this.totalNumRating);

  double getAverageRating() {
    return this.averageRating;
  }

  int getTotalNumRating() {
    return this.totalNumRating;
  }

  void addRating(double rating) {
    double newTotal = (this.averageRating * this.totalNumRating + rating);
    this.totalNumRating += 1;
    this.averageRating = newTotal / this.totalNumRating;
  }

  void deductRating(double oldRating, double newRating) {
    double newTotal = (this.averageRating * this.totalNumRating - oldRating +
        newRating);
    this.averageRating = newTotal / this.totalNumRating;
  }

  PlaceRating.fromSnapshot(DocumentSnapshot snapshot)
      :
        averageRating = snapshot['averageRating'],
        totalNumRating = snapshot['totalNumRating'];

  Map<String, dynamic> toJson() =>
      {
        'averageRating': averageRating,
        'totalNumRating': totalNumRating,
      };
}
