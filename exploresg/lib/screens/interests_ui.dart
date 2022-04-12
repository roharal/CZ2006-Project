import 'package:exploresg/screens/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:exploresg/helper/interestController.dart';
import 'dart:convert';

class InterestScreenArguments {
  final String userID;
  final String userInts;

  InterestScreenArguments(this.userID, this.userInts);
}

class InterestScreen extends StatefulWidget {
  static const routeName = "/interests";
  String userID = "";
  List intList = [];

  InterestScreen(String userID, String userInts){
    this.userID = userID;
    this.intList = userInts.split(",");
  }

  @override
  State<InterestScreen> createState() => _InterestScreenState();
}

class _InterestScreenState extends State<InterestScreen> {
  InterestController _interestController = InterestController();

  @override
  void initState() {
    super.initState();
    buildMap();
  }

  final interests = [
    'airport',
    'amusement_park',
    'aquarium',
    'art_gallery',
    'bakery',
    'bar',
    'beauty_salon',
    'book_store',
    'bowling_alley',
    'cafe',
    'casino',
    'cemetery',
    'clothing_store',
    'department_store',
    'florist',
    'gym',
    'hair_care',
    'library',
    'lodging',
    'movie_theater',
    'museum',
    'night_club',
    'park',
    'restaurant',
    'shopping_mall',
    'spa',
    'stadium',
    'tourist_attraction',
    'university',
    'zoo',
  ];

  var interestsMap = new Map();

  void buildMap() {
    for (var i in interests) {
      interestsMap[i] = false;
    }
  }

  void updateInterestChoices() {
    interestsMap.forEach((key, value) {
      for (String i in widget.intList) {
        if (i == key) {
          interestsMap[key] = true;
          break;
        }
      }
    });
    widget.intList.clear();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    updateInterestChoices();
    return Scaffold(
      backgroundColor: Color(0xfffffcec),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                fit: BoxFit.fill,
                child: SvgPicture.asset(
                  'assets/img/interests-top.svg',
                  width: w,
                  height: w * 116 / 375, //dimensions from figma lol
                ),
              ),
              Text("what are your interests?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'MadeSunflower',
                    fontSize: 36,
                    color: Color(0xff22254C),
                  )),
              SizedBox(height: 15),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12.0,
                  children: List<Widget>.generate(
                    interests.length,
                    (int index) {
                      bool isSelected = interestsMap[interests[index]];
                      return ChoiceChip(
                        label: Text(interests[index]),
                        selected: isSelected,
                        onSelected: (bool selected) {
                          setState(() {
                            interestsMap[interests[index]] =
                                selected ? true : false;
                          });
                          print(interestsMap);
                        },
                        backgroundColor: Color(0xfffffcec),
                        selectedColor: Color(0xff6488E5),
                        labelStyle: TextStyle(
                          fontFamily: 'AvenirLtStd',
                          color: isSelected ? Colors.white : Color(0xff6488E5),
                          fontSize: 16,
                        ),
                        side: BorderSide(color: Color(0xff6488E5), width: 2),
                      );
                    },
                  ).toList(),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                child: ElevatedButton(
                  onPressed: () async {
                    _interestController.updateUserInterests(
                        interestsMap, widget.userID);
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushReplacementNamed(context, BaseScreen.routeName);
                    }
                  },
                  child: Text(
                    "save changes",
                    style: TextStyle(
                      color: Color(0xff22254C),
                      fontFamily: 'AvenirLtStd',
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor:
                    MaterialStateProperty.all(Color(0xffF9BE7D)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                  ),
                ),
              ),
              Container(height: 20)
            ],
          ),
        ),
      ),
    );
  }
}
