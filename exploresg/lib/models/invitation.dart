import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exploresg/models/user.dart';

class Invitation {
  String place, date, time;
  List<UserModel> users;


  Invitation(this.place ,this.date, this.time ,this.users);

  String getPlace() {
    return this.place;
  }

  String getDate() {
    return this.date;
  }

  String getTime() {
    return this.time;
  }

  List<UserModel> getUsers() {
    return this.users;
  }

  factory Invitation.fromSnapshot(DocumentSnapshot snapshot) {
    var users = snapshot["users"] as List;
    List<UserModel> userModels = users.map((i) => UserModel.fromSnapshot(i)).toList();
    return Invitation(
      snapshot["place"],
      snapshot["date"],
      snapshot["time"],
      userModels
    );
  }

  Map<String, dynamic> toJson() => {
    "place": place,
    "date": date,
    "time": time,
    "users": users.map((i) => i.toJson()).toList()
  };
}