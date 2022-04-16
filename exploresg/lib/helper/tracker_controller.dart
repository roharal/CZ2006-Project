import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exploresg/models/invitation.dart';
import 'package:exploresg/models/user.dart';

class TrackerController {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Invitation>> getConfirmedInvitations(String uid) async {
    List<Invitation> invites = [];
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('toExplore')
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

  Future<List<List<Invitation>>> sortBasedOnToExploreAndExplored(
      List<Invitation> invites) async {
    List<Invitation> toExplore = [], explored = [];
    for (Invitation invite in invites) {
      if (invite.visited) {
        explored.add(invite);
      } else {
        toExplore.add(invite);
      }
    }
    return [toExplore, explored];
  }

  Future acceptInvite(Invitation invite, UserModel user) async {
    DocumentReference invitesRef = _firestore
        .collection('users')
        .doc(user.id)
        .collection('invites')
        .doc(invite.id);
    for (UserModel u in invite.users) {
      DocumentReference toExploreRef = _firestore
          .collection('users')
          .doc(u.id)
          .collection('toExplore')
          .doc(invite.id);
      late Invitation currentInvite;
      await toExploreRef.get().then((value) {
        currentInvite = Invitation.fromSnapshot(value);
        currentInvite.addUsers(user);
      });
      await toExploreRef
          .update(currentInvite.toJson());
    }
    invite.addUsers(user);
    await _firestore
        .collection('users')
        .doc(user.id)
        .collection('toExplore')
        .doc(invite.id)
        .set(invite.toJson());
    await invitesRef
        .delete();
  }

  Future rejectInvite(Invitation invite, UserModel user) async {
    await _firestore
        .collection('users')
        .doc(user.id)
        .collection('invites')
        .doc(invite.id)
        .delete();
  }

  Future setExplored(Invitation invite, String user) async {
    invite.visited = true;
    await _firestore
        .collection('users')
        .doc(user)
        .collection('toExplore')
        .doc(invite.id)
        .update(invite.toJson());
  }

  Future setToExplored(Invitation invite, String user) async {
    invite.visited = false;
    await _firestore
        .collection('users')
        .doc(user)
        .collection('toExplore')
        .doc(invite.id)
        .update(invite.toJson());
  }

  Future setUnexplored(Invitation invite, String user) async {
    await _firestore
        .collection('users')
        .doc(user)
        .collection('toExplore')
        .doc(invite.id)
        .delete();
  }
}
