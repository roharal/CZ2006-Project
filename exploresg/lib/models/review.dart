class Review{
  late String placeID, userID, review_text;
  late double rating;

  Review(
    this.placeID,
    this.userID,
    this.review_text,
    this.rating
  );

  String getPlaceID(){
    return this.placeID;
  }

  String getUserID(){
    return this.userID;
  }

  String getUserReview(){
    return this.review_text;
  }

  double getUserRating(){
    return this.rating;
  }

  void setPlaceID(placeID){
    this.placeID = placeID;
  }

  void setUserID(userID){
    this.userID = userID;
  }

  void setUserReview(review_text){
    this.review_text = review_text;
  }

  void setUserRating(rating){
    this.rating = rating;
  }
}