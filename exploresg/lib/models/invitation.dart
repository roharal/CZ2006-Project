import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exploresg/models/user.dart';

class Invitation {
  String id, place, date, time;
  bool visited;
  List<UserModel> users;


  Invitation(this.id, this.place ,this.date, this.time ,this.users, this.visited);

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

  void addUsers(UserModel user) {
    this.users.add(user);
  }

  void setVisited() {
    this.visited = true;
  }

  factory Invitation.fromSnapshot(DocumentSnapshot snapshot) {
    var users = snapshot["users"] as List;
    List<UserModel> userModels = users.map((i) => UserModel.fromSnapshot(i)).toList();
    return Invitation(
      snapshot["id"],
      snapshot["place"],
      snapshot["date"],
      snapshot["time"],
      userModels,
      snapshot["visited"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "place": place,
    "date": date,
    "time": time,
    "users": users.map((i) => i.toJson()).toList(),
    "visited": visited,
  };
}