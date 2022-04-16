class Place {
  late String id, placeName, placeAddress;
  late double ratings;
  late bool likes, openNow;
  late Map<String, String> coordinates;
  late List<dynamic> types;
  late int userTotalRatings, price;
  late List<String> images;
  late List<String> opening_hours;

  //constructor
  Place(
    this.id,
    this.placeName,
    this.placeAddress,
    this.ratings,
    this.likes,
    this.coordinates,
    this.types,
    this.userTotalRatings,
    this.images,
    this.openNow,
    this.price,
  );

  void pressLike() {
    this.likes = !this.likes;
  }

  String getPlaceName() {
    return this.placeName;
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

  void setOpeningHours(opening_hours) {
    this.opening_hours = opening_hours;
  }
}
