import 'package:exploresg/helper/utils.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfileScreen();
  }
}

class _ProfileScreen extends State<ProfileScreen> {
  var displayName = "<Display Name>";
  var emailAddress = "<EmailAddress@email.com>";

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
        child: Container(
            child: Column(
      children: [
        topBar("my account", height, width, 'assets/img/accountTop.png'),
        Container(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Image(
              image: AssetImage("assets/img/Profile picture.png"),
            )),
        Text(displayName,
            style: TextStyle(fontSize: 20, fontFamily: "AvenirLtStd")),
        Container(
            padding: EdgeInsets.all(5),
            width: 200,
            height: 40,
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter a display name"),
            )),
        Container(
            width: double.infinity,
            child: Image(
                image: AssetImage("assets/img/stringAccent.png"),
                fit: BoxFit.fitWidth)),
        Container(
            padding: EdgeInsets.all(5),
            child: Text("Account settings",
                style: TextStyle(
                    fontSize: 25,
                    fontFamily: "AvenirLtStd",
                    fontWeight: FontWeight.bold))),
        Row(children: [
          Container(
              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              width: width * (3 / 4),
              // color: Colors.red,
              alignment: Alignment.centerLeft,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("email address",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: "AvenirLtStd",
                          fontWeight: FontWeight.bold,
                        )),
                    Text(emailAddress,
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: "AvenirLtStd",
                        ))
                  ])),
          Container(
              child: ElevatedButton(
                  child: Text("change",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: "AvenirLtStd",
                        fontWeight: FontWeight.bold,
                      )),
                  onPressed: null,
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.grey),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      )))))
        ]),
        Row(children: [
          Container(
              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              width: width * (3 / 4),
              // color: Colors.red,
              alignment: Alignment.centerLeft,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("password",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: "AvenirLtStd",
                          fontWeight: FontWeight.bold,
                        )),
                    Text("must be between 8-20 characters",
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: "AvenirLtStd",
                        ))
                  ])),
          Container(
              child: ElevatedButton(
                  child: Text("change",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: "AvenirLtStd",
                        fontWeight: FontWeight.bold,
                      )),
                  onPressed: null,
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.grey),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      )))))
        ]),
        Row(children: [
          Container(
              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              width: width * (3 / 4),
              // color: Colors.red,
              alignment: Alignment.centerLeft,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("email address",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: "AvenirLtStd",
                          fontWeight: FontWeight.bold,
                        )),
                    Text(emailAddress,
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: "AvenirLtStd",
                        ))
                  ])),
          Container(
              child: ElevatedButton(
                  child: Text("change",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: "AvenirLtStd",
                        fontWeight: FontWeight.bold,
                      )),
                  onPressed: null,
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.grey),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      )))))
        ]),
        Container(height: 20), //Space for the nav bar to scroll
      ],
    )));
  }
}
