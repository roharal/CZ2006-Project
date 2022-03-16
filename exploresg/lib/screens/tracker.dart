import 'package:exploresg/helper/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/Place.dart';

class TrackerScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TrackerScreen();
  }
}

class _TrackerScreen extends State<TrackerScreen> {
  String _dropdownValue = 'to explore';

  Widget _trackerContainer(double height, double width, Place place) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(
          vertical: 0.05 * height, horizontal: 0.05 * width),
      width: width,
      height: height + 30,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                "assets/img/catsafari.png",
                height: 100,
                width: 100,
                fit: BoxFit.fill,
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textMajor(place.placename, Colors.grey, 20),
                    RatingBarIndicator(
                      rating: place.ratings,
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: width / 20,
                      direction: Axis.horizontal,
                    ),
                    textMinor(place.placeaddress),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          textMinor(place.placedesc),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  textMinor("my status: "),
                  textMinor("date: "),
                  textMinor("time: "),
                  textMinor("people: "),
                ],
              ),
              SizedBox(width: 10.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _trackerStatus(height),
                  textMinor("29/02/2022"),
                  textMinor("11.30am"),
                  textMinor("faith ihsan")
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _trackerStatus(double height) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 18),
        margin: EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: createMaterialColor(Color(0xFFFFF9ED))),
        height: height / 6.5,
        child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
                value: _dropdownValue,
                icon: const Icon(Icons.keyboard_arrow_down),
                style: const TextStyle(
                  color: Colors.blueAccent,
                  fontFamily: 'AvenirLtStd',
                  fontSize: 14,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _dropdownValue = newValue!;
                  });
                },
                items: <String>['unexplored', 'to explore', 'explored']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList())));
  }

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
              topBar("my tracker", height, width, 'assets/img/trackerTop.png'),
              SizedBox(
                height: 20,
              ),
              SearchBar(width: 0.8 * width, height: 0.3 * height),
              SizedBox(
                height: 10,
              ),
              Search(width: 0.8 * width, height: 0.3 * height),
              SizedBox(
                height: 40,
              ),
              Image.asset('assets/img/myTrackerAccents.png'),
              textMajor("to explore", Colors.black, 26),
              SizedBox(
                height: 10,
              ),
              _trackerContainer(
                  0.3 * height,
                  0.8 * width,
                  Place('Cat Safari', 'Cattos', 'Sunshine View', 3.00, false,
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/4/48/Catsrepublic.jpg/275px-Catsrepublic.jpg')),
              _trackerContainer(
                  0.3 * height,
                  0.8 * width,
                  Place('Cat Safari', 'Cattos', 'Sunshine View', 3.00, false,
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/4/48/Catsrepublic.jpg/275px-Catsrepublic.jpg')),
              SizedBox(
                height: 40,
              ),
              Image.asset('assets/img/myTrackerAccents2.png'),
              _trackerContainer(
                  0.3 * height,
                  0.8 * width,
                  Place('Cat Safari', 'Cattos', 'Sunshine View', 3.00, false,
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/4/48/Catsrepublic.jpg/275px-Catsrepublic.jpg')),
              _trackerContainer(
                  0.3 * height,
                  0.8 * width,
                  Place('Cat Safari', 'Cattos', 'Sunshine View', 3.00, false,
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/4/48/Catsrepublic.jpg/275px-Catsrepublic.jpg')),
            ],
          ),
        ),
      ),
    );
  }
}
