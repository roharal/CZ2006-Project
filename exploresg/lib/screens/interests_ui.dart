import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:exploresg/helper/interestController.dart';
import 'dart:convert';

class InterestScreen extends StatefulWidget {
  static const routeName = "/interests";
  late String userID;
  late List userInts;

  InterestScreen(String userID,String userInts){
    this.userID = userID;
    this.userInts =userInts.split(",");

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

  void updateInterestChoices(){
    interestsMap.forEach((key, value) {
      for(String i in widget.userInts){
        if(i == key){
          interestsMap[key] = true;
          break;
        }
      }
    });
    widget.userInts.clear();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    updateInterestChoices();
    return Scaffold(
        backgroundColor: Color(0xfffffcec),
        body: Container(
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              FittedBox(
                  fit: BoxFit.fill,
                  child: SvgPicture.asset(
                    'assets/img/interests-top.svg',
                    width: w,
                    height: w * 116 / 375, //dimensions from figma lol
                  )),
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
              Container(
                  child: ElevatedButton(
                onPressed: () async {
                  _interestController.updateUserInterests(
                      interestsMap, widget.userID);
                  Navigator.pop(context);
                },
                child: Text(
                  "Save changes",
                  style: TextStyle(
                    fontFamily: 'AvenirLtStd',
                    fontSize: 16,
                  ),
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ))),
              )),
              Container(height: 20)
            ]),
          ),
        ));
  }
}
