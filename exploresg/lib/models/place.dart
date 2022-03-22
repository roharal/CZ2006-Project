class Place {
  late String id, placeName, placeDesc, placeAddress;
  late double ratings;
  late bool likes, openNow;
  late Map<String, String> coordinates;
  late List<dynamic> types;
  late int userTotalRatings;
  late List<String> images;

  //constructor
  Place(
      this.id,
      this.placeName,
      this.placeDesc,
      this.placeAddress,
      this.ratings,
      this.likes,
      this.coordinates,
      this.types,
      this.userTotalRatings,
      this.images,
      this.openNow
      );

  void pressLike() {
    this.likes = !this.likes;
  }

  String getPlaceName() {
    return this.placeName;
  }

  String getPlaceDesc() {
    return this.placeDesc;
  }

  String getPlaceAddress() {
    return this.placeAddress;
  }

  List<String> getImages() {
    return this.images;
  }

  double getRatings() {
    return this.ratings;
  }

  String getId() {
    return this.id;
  }

}
