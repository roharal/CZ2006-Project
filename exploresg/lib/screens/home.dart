import 'package:flutter/material.dart';
import 'package:exploresg/helper/utils.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';


class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: createMaterialColor(Color(0xFFFFF9ED)),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              topBar("home", height, width, 'assets/img/homeTop.png'),
              textMajor("find places", Colors.black, 26),

            ],
          )
        ),
      )
    );
  }
}