//testtt//
class Place {
  late String placename;
  late String placedesc;
  late String placeaddress;
  late double ratings;
  late bool likes;
  late String image;

  //constructor
  Place(this.placename, this.placedesc, this.placeaddress, this.ratings,
      this.likes, this.image) {}

  void pressLike() {
    this.likes = !this.likes;
  }
}
