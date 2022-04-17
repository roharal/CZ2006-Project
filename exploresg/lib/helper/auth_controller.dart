import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exploresg/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseMessaging _fcm = FirebaseMessaging.instance;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<void> logOut() {
    return _auth.signOut();
  }

  Future signInEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final User user = result.user!;
      return user;
    } catch (error) {
      return error.toString();
    }
  }

  Future signUpEmail(email, password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final User user = result.user!;
      return user;
    } catch (error) {
      print(error.toString());
      return error.toString();
    }
  }

  Future signOut() async {
    try {
      this.updateUserById(this.getCurrentUser()!.uid, {"token": ""});
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<String?> createUserFromEmail(
      UserModel userModel, String password) async {
    var batch = _firestore.batch();
    try {
      var result = await this.signUpEmail(userModel.getEmail(), password);
      if (result is User) {
        userModel.setId(result.uid);
        var token = await _fcm.getToken();
        userModel.setToken(token);
        userModel.setEmailVerified(result.emailVerified);
        batch.set(_firestore.collection("users").doc(userModel.getId()),
            userModel.toJson());
        batch.set(_firestore.collection("usernames").doc(userModel.getId()),
            {"username": userModel.getUsername()});
        batch.commit();
        return null;
      } else {
        return result;
      }
    } on FirebaseAuthException catch (e) {
      return e.toString();
    }
  }

  Future<String?> createUserFromGoogleSignIn(User user) async {
    var token = await _fcm.getToken();
    try {
      String first = "", last = "";
      if (user.displayName != null) {
        first = user.displayName!.split(" ")[1];
        last = user.displayName!.split(" ")[0];
      }
      UserModel userModel = UserModel(
          user.uid,
          "",
          first,
          last,
          user.email!,
          token,
          user.photoURL == null ? "" : user.photoURL!,
          user.phoneNumber == null
              ? ""
              : user.phoneNumber! == null
                  ? ""
                  : user.phoneNumber!,
          user.emailVerified,
          true,
          "",
          "");
      await this.createUserById(user.uid, userModel.toJson());
      return null;
    } on FirebaseAuthException catch (e) {
      return e.toString();
    }
  }

  Future<String> getUidfromUsername(String username) async {
    String uid;
    final QuerySnapshot query = await _firestore
        .collection("usernames")
        .where("username", isEqualTo: username)
        .limit(1)
        .get();
    List<DocumentSnapshot> documents = query.docs;
    if (documents.length == 1) {
      uid = documents[0].id;
    } else {
      uid = "notFound";
    }
    return uid;
  }

  Future<String?> getToken() async {
    return _fcm.getToken();
  }

  Future<bool> checkUserExist(String id) async {
    var result = await this.getUserFromId(id);
    return result.exists;
  }

  Future createUserById(String id, Map<String, dynamic> data) async {
    await _firestore.collection("users").doc(id).set(data);
  }

  Future<DocumentSnapshot> getUserFromId(String id) async {
    return await _firestore.collection("users").doc(id).get();
  }

  Future updateUserById(String id, Map<String, dynamic> data) async {
    await _firestore.collection("users").doc(id).update(data);
  }

  Future changeUsername(String id, Map<String, dynamic> data) async {
    await _firestore.collection("usernames").doc(id).update(data);
  }
}
