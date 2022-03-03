import 'package:exploresg/helper/utils.dart';
import 'package:flutter/material.dart';

class TrackerScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TrackerScreen();
  }
}

class _TrackerScreen extends State<TrackerScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
        child: Stack(
          children: [
            topBar("my tracker", height, width, 'assets/img/trackerTop.png')
          ],
        )
    );
  }
}