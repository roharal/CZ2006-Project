import 'package:exploresg/models/place.dart';

class Invitation {
  late Place place;
  late DateTime inviteTime;
  late var inviter;
  late bool accepted = false;

  Invitation(this.place,this.inviteTime,this.accepted,this.inviter);
}