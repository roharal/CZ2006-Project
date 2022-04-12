import 'package:exploresg/helper/auth_controller.dart';
import 'package:exploresg/helper/inbox_controller.dart';
import 'package:exploresg/helper/utils.dart';
import 'package:exploresg/models/invitation.dart';
import 'package:exploresg/models/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class InboxScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _InboxScreen();
  }
}

class _InboxScreen extends State<InboxScreen> {
  InboxController _inboxController = InboxController();
  AuthController _authController = AuthController();
  final DateFormat formatterDate = DateFormat('dd-MM-yyyy');
  final DateFormat formatterTime = DateFormat('HH:MM');
  List<Invitation> _inbox = [];
  bool _isLoaded = false;
  var valueChoose;
  List listItem = ["Filter 1", "Filter 2", "Filter 3", "Filter 4"];

  @override
  void initState() {
    super.initState();
    _loadInbox();
  }

  Widget _invitationContainer(var width, Invitation invitationC, Place place) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      width: width * (10 / 11),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            // color: Colors.green,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    // color: Colors.yellow,
                    height: width * (1 / 10),
                    child: Image(image: AssetImage("assets/img/oshy.png"))),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    alignment: Alignment.center,
                    // color: Colors.blue,
                    child: Text("invites you to...",
                        style: TextStyle(
                            fontFamily: "AvenirLtStd",
                            fontWeight: FontWeight.w100))),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 3),
            width: width * (10 / 11),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  width: width * (9 / 20),
                  // color: Colors.blue,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Image.network(
                      place.images.length != 0
                          ? place.images[0]
                          : "https://upload.wikimedia.org/wikipedia/commons/thumb/4/48/Catsrepublic.jpg/275px-Catsrepublic.jpg",
                      fit: BoxFit.fill,
                      height: 100,
                      width: 100,
                    ),
                  ),
                ),
                Container(
                  height: width * (9 / 20),
                  width: width * (9 / 20),
                  alignment: Alignment.topLeft,
                  // color: Colors.pink,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Spacer(flex: 3),
                      Text(place.placeName,
                          style: TextStyle(
                              fontFamily: "AvenirLtStd",
                              fontSize: 23,
                              fontWeight: FontWeight.bold)),
                      RatingBarIndicator(
                        rating: place.ratings,
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 20.0,
                        direction: Axis.horizontal,
                      ),
                      Spacer(flex: 1),
                      Text(
                        place.placeAddress,
                        style: TextStyle(
                          fontFamily: "AvenirLtStd",
                          fontSize: 12,
                        ),
                      ),
                      Spacer(flex: 5),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
              child: textMinor("Date: ${invitationC.date}", Colors.black),
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
          Container(
              child: textMinor("Time: ${invitationC.time}", Colors.black)),
          Container(
            padding: EdgeInsets.all(1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white)),
                    icon: Icon(Icons.alarm_on_sharp, color: Colors.blue),
                    label: Text("Accept", style: TextStyle(color: Colors.blue)),
                    onPressed: null,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white)),
                    icon: Icon(Icons.alarm_off_sharp, color: Colors.red),
                    label: Text(
                      "Reject",
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: null,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _loadInbox() async {
    var user = _authController.getCurrentUser();
    _inbox = await _inboxController.getConfirmedInvitations(user!.uid);
    setState(() {
      _isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return _isLoaded
        ? Scaffold(
            backgroundColor: Color(0xfffffcec),
            body: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    topBar(
                        "my inbox", height, width, 'assets/img/inbox-top.svg'),
                    SizedBox(height: 20)
                  ],
                ),
              ),
            ),
          )
        : Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
