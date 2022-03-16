//testtt//
class Place {
  late String placename;
  late String placedesc;
  late String placeaddress;
  late double ratings;
  late bool likes;

  //constructor
  Place(String placename, String placedesc, String placeaddress, double ratings,
      bool likes) {
    this.placename = placename;
    this.placedesc = placedesc;
    this.placeaddress = placeaddress;
    this.ratings = ratings;
    this.likes = likes;
  }

  void pressLike() {
    this.likes = !this.likes;
  }
}
