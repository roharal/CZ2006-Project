import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exploresg/models/place.dart';
import 'package:exploresg/models/user.dart';

class Invitation {
  Place place;
  DateTime dateTime;
  List<UserModel> users;


  Invitation(this.place,this.dateTime,this.users);

  Place getPlace() {
    return this.place;
  }

  DateTime getDateTime() {
    return this.dateTime;
  }

  List<UserModel> getUsers() {
    return this.users;
  }

  factory Invitation.fromSnapshot(DocumentSnapshot snapshot) {
    var users = snapshot["users"] as List;
    List<UserModel> userModels = users.map((i) => UserModel.fromSnapshot(i)).toList();
    return Invitation(
      snapshot["place"],
      snapshot["dateTime"],
      userModels
    );
  }

  Map<String, dynamic> toJson() => {
    "place": place,
    "datetime": dateTime,
    "users": users.map((i) => i.toJson()).toList()
  };
}