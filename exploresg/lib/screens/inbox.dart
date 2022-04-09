import 'package:exploresg/helper/utils.dart';
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
  final DateFormat formatterDate = DateFormat('dd-MM-yyyy');
  final DateFormat formatterTime = DateFormat('HH:MM');
  var valueChoose;
  List<Invitation> invitationList = [
    Invitation(DateTime.now(), "Oshwad", "Cat Safari", 4.5, "56 Nanyang Ave",
        "Dog day center in Singapore", "assets/img/catsafari.png"),
    Invitation(DateTime.now(), "Albers", "Dog Safari", 1.7, "56 Doggo street",
        "Cat day center in Singapore", "assets/img/dog.jpg")
  ];
  List listItem = ["Filter 1", "Filter 2", "Filter 3", "Filter 4"];

  Widget _invitationWidget(var width, Invitation invitationC) {
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
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
            // color: Colors.green,
            width: double.infinity,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
            ])),
        Container(
            padding: EdgeInsets.symmetric(vertical: 3),
            width: width * (10 / 11),
            alignment: Alignment.center,
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                  padding: EdgeInsets.all(5),
                  width: width * (9 / 20),
                  // color: Colors.blue,
                  child: Image(
                      fit: BoxFit.fitWidth,
                      image: AssetImage(
                        invitationC.placeImage,
                      ))),
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
                        Text(invitationC.placeName,
                            style: TextStyle(
                                fontFamily: "AvenirLtStd",
                                fontSize: 23,
                                fontWeight: FontWeight.bold)),
                        RatingBarIndicator(
                          rating: invitationC.placeRating,
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 20.0,
                          direction: Axis.horizontal,
                        ),
                        Spacer(flex: 1),
                        Text(invitationC.placeAddress,
                            style: TextStyle(
                              fontFamily: "AvenirLtStd",
                              fontSize: 12,
                            )),
                        Spacer(flex: 5),
                      ]))
            ])),
        Container(
            alignment: Alignment.centerLeft,
            // color: Colors.purple,
            width: width * (10 / 11),
            child: Text(invitationC.placeDesc,
                style: TextStyle(
                    fontFamily: "AvenirLtStd", fontWeight: FontWeight.w100))),
        Container(
            child: Text("Date: " + formatterDate.format(invitationC.inviteTime),
                style: TextStyle(
                  fontFamily: "AvenirLtStd",
                  fontSize: 14,
                )),
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
        Container(
            child: Text("Time: " + formatterTime.format(invitationC.inviteTime),
                style: TextStyle(
                  fontFamily: "AvenirLtStd",
                  fontSize: 14,
                ))),
        Container(
            padding: EdgeInsets.all(1),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white)),
                    icon: Icon(Icons.alarm_on_sharp, color: Colors.blue),
                    label: Text("Accept", style: TextStyle(color: Colors.blue)),
                    onPressed: null,
                  )),
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
                  ))
            ]))
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Color(0xfffffcec),
        body: SingleChildScrollView(
            child: Container(
                child: Column(children: [
          topBar("my inbox", height, width, 'assets/img/inboxTop.png'),
          Padding(
              padding: EdgeInsets.all(16),
              child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                  child: DropdownButton(
                      icon: Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: Colors.black,
                      ),
                      underline: SizedBox(),
                      isExpanded: true,
                      hint: Text("filter...",
                          style: TextStyle(
                              fontFamily: "AvenirLtStd",
                              fontWeight: FontWeight.bold,
                              color: Colors.grey)),
                      value: valueChoose,
                      items: listItem.map((valueItem) {
                        return DropdownMenuItem(
                            value: valueItem,
                            child: Text(valueItem,
                                style: TextStyle(
                                    fontFamily: "AvenirLtStd",
                                    fontWeight: FontWeight.bold)));
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          valueChoose = newValue;
                        });
                      }))),
          //MAIN CONTAINER
          Column(children: invitationList.map((invite){return _invitationWidget(width, invite);}).toList(),),
          SafeArea(child: Container(child: Text(" ")))
        ]))));
  }
}

class Invitation {
  DateTime inviteTime;
  var inviter;
  var placeName;
  double placeRating;
  var placeAddress;
  var placeImage;
  var placeDesc;
  bool accepted = false;

  Invitation(this.inviteTime, this.inviter, this.placeName, this.placeRating,
      this.placeAddress, this.placeDesc, this.placeImage);
}
