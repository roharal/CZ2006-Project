import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class InterestScreen extends StatefulWidget {
  static const routeName = "/interests";

  @override
  State<InterestScreen> createState() => _InterestScreenState();
}

class _InterestScreenState extends State<InterestScreen> {
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

  @override
  Widget build(BuildContext context) {
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
                    width: MediaQuery.of(context).size.width,
                  )),
              Text("what are your interests?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'MadeSunflower',
                    fontSize: 36,
                    color: Color(0xff22254C),
                  )),
              Wrap(
                direction: Axis.vertical,
                alignment: WrapAlignment.center,
                spacing:8.0,
                children: List<Widget>.generate(
                  interests.length,
                  (int index) {
                  return ChoiceChip(
                    label: Text(interests[index]),
                    selected: ,
                    onSelected: (bool selected) {
                      setState(() {

                      });
                    },
                  );
                  },
                ).toList(),
              ),
            ]),
          ),
        ));
  }
}
