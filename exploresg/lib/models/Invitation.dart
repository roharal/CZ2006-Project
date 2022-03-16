import 'package:exploresg/models/Place.dart';

class Invitation {
  late Place place;
  late DateTime inviteTime;
  late var inviter;
  late bool accepted = false;

  Invitation(this.place,this.inviteTime,this.accepted,this.inviter);
}