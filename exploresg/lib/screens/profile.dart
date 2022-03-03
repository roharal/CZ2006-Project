import 'package:exploresg/helper/utils.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfileScreen();
  }

}

class _ProfileScreen extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
          child: textMajor("my profile", Colors.black, 36),
        )
    );
  }
}