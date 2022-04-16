import 'package:exploresg/helper/utils.dart';
import 'package:exploresg/screens/base_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:exploresg/helper/interest_controller.dart';

class InterestScreenArguments {
  final String userID;
  final String userInts;

  InterestScreenArguments(this.userID, this.userInts);
}

class InterestScreen extends StatefulWidget {
  static const routeName = '/interests';
  final String userID;
  final String userInts;

  InterestScreen(this.userID, this.userInts);

  @override
  State<InterestScreen> createState() => _InterestScreenState();
}

class _InterestScreenState extends State<InterestScreen> {
  InterestController _interestController = InterestController();
  var _interestsMap = new Map();
  List _intList = [];

  @override
  void initState() {
    super.initState();
    buildMap();
  }

  void buildMap() {
    for (var i in placeType) {
      _interestsMap[i] = false;
    }
    _intList = widget.userInts.split(',');
  }

  void updateInterestChoices() {
    _interestsMap.forEach((key, value) {
      for (String i in _intList) {
        if (i == key) {
          _interestsMap[key] = true;
          break;
        }
      }
    });
    _intList.clear();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    updateInterestChoices();
    return Scaffold(
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
                  ),),
              SizedBox(height: 15),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12.0,
                  children: List<Widget>.generate(
                    placeType.length,
                    (int index) {
                      bool isSelected = _interestsMap[placeType[index]];
                      return ChoiceChip(
                        label: Text(placeType[index]),
                        selected: isSelected,
                        onSelected: (bool selected) {
                          setState(() {
                            _interestsMap[placeType[index]] =
                                selected ? true : false;
                          });
                        },
                        backgroundColor: Color(0xfffffcec),
                        selectedColor: Color(0xff6488E5),
                        labelStyle: avenirLtStdStyle(
                          isSelected ? Colors.white : Color(0xff6488E5),
                        ),
                        side: BorderSide(color: Color(0xff6488E5), width: 2),
                      );
                    },
                  ).toList(),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: ElevatedButton(
                  onPressed: () async {
                    print(widget.userID);
                    _interestController.updateUserInterests(
                        _interestsMap, widget.userID);
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushReplacementNamed(
                          context, BaseScreen.routeName);
                    }
                  },
                  child: textMinor(
                    'save changes',
                    Color(0xff22254C),
                  ),
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor: MaterialStateProperty.all(
                      Color(0xffF9BE7D),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                  ),
                ),
              ),
              Container(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
