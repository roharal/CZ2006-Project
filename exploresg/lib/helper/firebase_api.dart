import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exploresg/helper/authController.dart';
import 'package:exploresg/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  AuthController _auth = AuthController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<String?> createUserFromEmail(UserModel userModel, String password) async {
    var batch = _firestore.batch();
    var token;
    try {
      User user = await _auth.signUpEmail(userModel.getEmail(), password);
      userModel.setId(user.uid);
      token = await _fcm.getToken();
      userModel.setToken(token);
      userModel.setEmailVerified(user.emailVerified);
      batch.set(_firestore.collection("users").doc(userModel.getId()), userModel.toJson());
      batch.set(_firestore.collection("usernames").doc(userModel.getId()), {"username": userModel.getUsername()});
      batch.commit();
      return null;

    } on FirebaseAuthException catch (e) {
      return e.toString();
    }
  }

  Future<String> getUidfromUsername(String username) async {
    String uid;
    final QuerySnapshot query = await _firestore.collection("usernames")
        .where("username", isEqualTo: username).limit(1)
        .get();
    List<DocumentSnapshot> documents = query.docs;
    if (documents.length == 1) {
      uid = documents[0].id;
    } else {
      uid = "notFound";
    }
    return uid;
  }

  Future<String?> loginUsingEmail(String email, String password) async {
    var token;
    try {
      User user = await _auth.signInEmail(email, password);
      token = await _fcm.getToken();
      this.updateDocumentByIdFromCollection("users", user.uid, {"token":token});
      return null;

    } on FirebaseAuthException catch (e) {
      return e.toString();
    }
  }

  Future createDocumentByIdFromCollection(String collection, bool useOwnID, Map<String, dynamic> data, [String? id]) async {
    if (useOwnID) {
      await _firestore.collection(collection).doc(id).set(data);
    } else {
      String key = _firestore.collection(collection).doc().id;
      await _firestore.collection(collection).doc(key).set(data);
    }
  }

  Future<DocumentSnapshot> getDocumentByIdFromCollection(String collection, String id) async {
    return await _firestore.collection(collection).doc(id).get();
  }

  Future updateDocumentByIdFromCollection(String collection, String id, Map<String, dynamic> data) async {
    await _firestore.collection(collection).doc(id).update(data);
  }

  Future deleteDocumentByIdFromCollection(String collection, String id) async {
    await _firestore.collection(collection).doc(id).delete();
  }
}

