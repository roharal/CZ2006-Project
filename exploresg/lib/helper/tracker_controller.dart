import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exploresg/models/invitation.dart';
import 'package:exploresg/models/user.dart';

class TrackerController {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Invitation>> getConfirmedInvitations(String uid) async {
    List<Invitation> invites = [];
    await _firestore
        .collection("users")
        .doc(uid)
        .collection("toExplore")
        .get()
        .then((value) {
      if (value.size != 0) {
        for (var n in value.docs) {
          Invitation invitation = Invitation.fromSnapshot(n);
          invites.add(invitation);
        }
      }
    });
    return invites;
  }

  Future<List<List<Invitation>>> sortBasedOnToExploreAndExplored(List<Invitation> invites) async {
    List<Invitation> toExplore = [], explored = [];
    String now = DateTime.now().toString().split(" ")[0];
    String month, day, nowMonth, nowDay;
    for (Invitation invite in invites) {
      month = invite.date.split("-")[1];
      day = invite.date.split("-")[2];
      nowMonth = now.split("-")[1];
      nowDay = now.split("-")[2];
      if (int.parse(nowMonth) > int.parse(month)) {
        explored.add(invite);
      } else if (int.parse(nowDay) > int.parse(day)) {
        explored.add(invite);
      } else {
        toExplore.add(invite);
      }
    }
    return [toExplore, explored];
  }

  Future acceptInvite(Invitation invite, UserModel user) async {
    invite.addUsers(user);
    await _firestore.collection("users").doc(user.id).collection("toExplore").doc(invite.id).set(invite.toJson());
    await _firestore.collection("users").doc(user.id).collection("invites").doc(invite.id).delete();
  }

  Future rejectInvite(Invitation invite, UserModel user) async {
    await _firestore.collection("users").doc(user.id).collection("invites").doc(invite.id).delete();
  }
}
