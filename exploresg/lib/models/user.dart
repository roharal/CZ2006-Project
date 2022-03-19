import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {

  late String id, username, firstName, lastName, email, picture, mobileNumber;
  late String? token;
  late bool emailVerified, numberVerified;

  UserModel(this.id, this.username, this.firstName, this.lastName, this.email, this.token, this.picture, this.mobileNumber, this.emailVerified, this.numberVerified);

  void setId(String id) {
    this.id = id;
  }

  void setToken(String? token) {
    this.token = token;
  }

  void setEmailVerified(bool verified) {
    this.emailVerified = verified;
  }

  String getId() {
    return this.id;
  }
  String getUsername() {
    return this.username;
  }
  String getEmail() {
    return this.email;
  }

  UserModel.fromSnapshot(DocumentSnapshot snapshot) :
        id = snapshot["id"],
        username = snapshot["username"],
        firstName = snapshot["firstName"],
        lastName = snapshot["lastName"],
        email = snapshot["email"],
        token = snapshot["token"],
        picture = snapshot["picture"],
        mobileNumber = snapshot["mobileNumber"],
        emailVerified = snapshot["emailVerified"],
        numberVerified = snapshot["numberVerified"];

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "token": token,
    "picture": picture,
    "mobileNumber": mobileNumber,
    "emailVerified": emailVerified,
    "numberVerified": numberVerified,
  };
}