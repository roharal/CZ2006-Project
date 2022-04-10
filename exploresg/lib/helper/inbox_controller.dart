import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exploresg/models/invitation.dart';

class InboxController {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ignore: body_might_complete_normally_nullable
  Future<List<Invitation>?> getConfirmedInvitations(String uid) async {
    List<Invitation> invites = [];
    await _firestore.collection("users").doc(uid).collection("invites").get().then((value) {
      if (value.size != 0) {
        for (var n in value.docs) {
          Invitation invitation = Invitation.fromSnapshot(n);
          invites.add(invitation);
        }
        return invites;
      } else {
        return null;
      }
    });
  }


}