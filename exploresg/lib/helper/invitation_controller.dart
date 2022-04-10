import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exploresg/helper/authController.dart';
import 'package:exploresg/models/invitation.dart';
import 'package:exploresg/models/user.dart';

class InvitationController {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AuthController _authController = AuthController();


  Future<String?> sendInvitationToUser(List<String> to, String from, String place, String date, String time) async {
    List<UserModel> users = [];
    List<UserModel> unconfirmed = [];
    List<String> uids = [];
    var batch = _firestore.batch();

    await _authController.getUserFromId(from).then((value) {
      UserModel user = UserModel.fromSnapshot(value);
      users.add(user);
    });

    for (String username in to) {
      var uid = await _authController.getUidfromUsername(username);
      uids.add(uid);
    }

    if (uids.length == to.length) {
      await _firestore.collection("users").where(FieldPath.documentId, whereIn: uids).get().then((value) {
        if (value.size != 0) {
          for (var i in value.docs) {
            UserModel user = UserModel.fromSnapshot(i);
            unconfirmed.add(user);
          }
        } else {
          return "unable to send invitation";
        }
      });
      Invitation invitation = Invitation(place, date, time, users);
      var sender = _firestore.collection("users").doc(from).collection("toExplore");
      String key = sender.doc().id;
      await sender.doc(key).set(invitation.toJson());

      for (UserModel u in unconfirmed) {
        batch.set(_firestore.collection("users").doc(u.id).collection("invites").doc(key),invitation.toJson());
      }
      batch.commit();
      return null;
    } else {
      return "unable to send invitation";
    }
  }
}
