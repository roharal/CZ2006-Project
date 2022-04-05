import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class InterestScreen extends StatefulWidget {
  static const routeName = "/interests";

  @override
  State<InterestScreen> createState() => _InterestScreenState();
}

class _InterestScreenState extends State<InterestScreen> {
  @override
  void initState() {
    // TODO: implement initState
    buildMap();
  }

  final interests = [
    "eating",
    "reading",
    "sky diving",
    "camping",
    "sports",
    "zoo",
    "massaging",
    "crafting",
    "writing"
  ];

  var interestsMap = new Map();

  void buildMap(){
    for (var i in interests){
      interestsMap[i] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;

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
                    height: w*116/375, //dimensions from figma lol
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
                          interestsMap[interests[index]] = selected ? true : false;
                        });
                      },
                      backgroundColor: Color(0xfffffcec),
                      selectedColor: Color(0xff6488E5),
                      labelStyle: TextStyle(
                        fontFamily: 'AvenirLtStd',
                        color: isSelected ? Colors.white : Color(0xff6488E5),
                        fontSize: 16,
                      ),
                      side: BorderSide(
                        color: Color(0xff6488E5),
                        width: 2
                      ),
                    );
                    },
                  ).toList(),
                ),
              ),
            ]),
          ),
        ));
  }
}
