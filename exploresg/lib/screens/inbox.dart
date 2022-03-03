import 'package:exploresg/helper/utils.dart';
import 'package:flutter/material.dart';

class InboxScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _InboxScreen();
  }

}

class _InboxScreen extends State<InboxScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
          child: textMajor("my inbox", Colors.black, 36),
        )
    );
  }
}