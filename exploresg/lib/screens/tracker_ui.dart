import 'package:exploresg/helper/authController.dart';
import 'package:exploresg/helper/places_api.dart';
import 'package:exploresg/helper/tracker_controller.dart';
import 'package:exploresg/helper/utils.dart';
import 'package:exploresg/models/invitation.dart';
import 'package:exploresg/models/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:exploresg/models/place.dart';

class TrackerScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TrackerScreen();
  }
}

class _TrackerScreen extends State<TrackerScreen> {
  // String _dropdownValue = 'to explore';

  // Widget _trackerContainer(double height, double width, Place place) {
  //   return Container(
  //     decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.all(Radius.circular(20))),
  //     margin: EdgeInsets.symmetric(vertical: 5),
  //     padding: EdgeInsets.symmetric(
  //         vertical: 0.05 * height, horizontal: 0.05 * width),
  //     width: width,
  //     height: height + 30,
  //     child: Column(
  //       children: [
  //         Row(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Image.asset(
  //               "assets/img/catsafari.png",
  //               height: 100,
  //               width: 100,
  //               fit: BoxFit.fill,
  //             ),
  //             SizedBox(width: 20),
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   textMajor(place.placeName, Colors.grey, 20),
  //                   RatingBarIndicator(
  //                     rating: place.ratings,
  //                     itemBuilder: (context, index) => Icon(
  //                       Icons.star,
  //                       color: Colors.amber,
  //                     ),
  //                     itemCount: 5,
  //                     itemSize: width / 20,
  //                     direction: Axis.horizontal,
  //                   ),
  //                   textMinor(place.placeAddress, Colors.black),
  //                 ],
  //               ),
  //             )
  //           ],
  //         ),
  //         SizedBox(
  //           height: 20,
  //         ),
  //         textMinor(place.placeDesc, Colors.black),
  //         SizedBox(
  //           height: 20,
  //         ),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             SizedBox(
  //               width: 20,
  //             ),
  //             Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               crossAxisAlignment: CrossAxisAlignment.end,
  //               children: [
  //                 textMinor("my status: ", Colors.black),
  //                 textMinor("date: ", Colors.black),
  //                 textMinor("time: ", Colors.black),
  //                 textMinor("people: ", Colors.black),
  //               ],
  //             ),
  //             SizedBox(width: 10.0),
  //             Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 _trackerStatus(height),
  //                 textMinor("29/02/2022", Colors.black),
  //                 textMinor("11.30am", Colors.black),
  //                 textMinor("faith ihsan", Colors.black)
  //               ],
  //             )
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }

  // Widget _trackerStatus(double height) {
  //   return Container(
  //       padding: EdgeInsets.symmetric(horizontal: 18),
  //       margin: EdgeInsets.symmetric(vertical: 2),
  //       decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(20),
  //           color: createMaterialColor(Color(0xFFFFF9ED))),
  //       height: height / 6.5,
  //       child: DropdownButtonHideUnderline(
  //           child: DropdownButton<String>(
  //               value: _dropdownValue,
  //               icon: const Icon(Icons.keyboard_arrow_down),
  //               style: const TextStyle(
  //                 color: Colors.blueAccent,
  //                 fontFamily: 'AvenirLtStd',
  //                 fontSize: 14,
  //               ),
  //               onChanged: (String? newValue) {
  //                 setState(() {
  //                   _dropdownValue = newValue!;
  //                 });
  //               },
  //               items: <String>['unexplored', 'to explore', 'explored']
  //                   .map<DropdownMenuItem<String>>((String value) {
  //                 return DropdownMenuItem<String>(
  //                   value: value,
  //                   child: Text(value),
  //                 );
  //               }).toList())));
  // }

  TrackerController _trackerController = TrackerController();
  AuthController _authController = AuthController();
  PlacesApi _placesApi = PlacesApi();
  List<Invitation> _invites = [];
  Map<String, Place> _places = {};
  bool _isLoaded = false;
  String dropDownValue = 'to explore';


  @override
  void initState() {
    super.initState();
    _loadExplores();
  }

  Widget _bottomContainer(int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _dropDown(),
        Container(
            child: textMinor("Date: ${_invites[index].date}", Colors.black),
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
        SizedBox(height: 5,),
        Container(
            child: textMinor("Time: ${_invites[index].time}", Colors.black)
        ),
        Row(
          children: [
            textMinorBold("people", Colors.black),
            SizedBox(width: 20,),
            Container(
              width: 20,
              height: 20,
              child: Image.network(_invites[index].users[0].picture),
            )
          ],
        )
      ],
    );
  }

  Widget _dropDown() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        margin: EdgeInsets.symmetric(vertical: 3),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.white),
        child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
                value: dropDownValue,
                icon: const Icon(Icons.keyboard_arrow_down),
                style: const TextStyle(
                  color: Colors.orange,
                  fontFamily: 'AvenirLtStd',
                  fontSize: 14,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    dropDownValue = newValue!;
                  });
                },
                items: <String>['unexplored', 'to explore', 'explored']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(),
                    ),
                  );
                }).toList())));
  }

  Widget _exploreList(double height, double width) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _invites.length,
      itemBuilder: (context, index) {
        return Column(children: [
          placeContainer(_places[_invites[index].place]!, 0.8 * width, 0.35 * height, _bottomContainer(index), Container()),
          SizedBox(
            height: 10,
          ),
        ]);
      },
    );
  }

  void _loadExplores() async {
    var user = _authController.getCurrentUser();
    _invites = await _trackerController.getConfirmedInvitations(user!.uid);

    if (_invites.length != 0) {
      for (Invitation iv in _invites) {
        var place = await _placesApi.placeDetailsSearchFromText(iv.place);
        if (place != null) {
          _places[iv.place] = place;
          print(place.id);
        }
      }
    }
    setState(() {
      _isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return _isLoaded ? Scaffold(
      backgroundColor: createMaterialColor(Color(0xFFFFF9ED)),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              topBar("my tracker", height, width, 'assets/img/tracker-top.svg'),
              FittedBox(
                  fit: BoxFit.fill,
                  child: SvgPicture.asset('assets/img/tracker-mid.svg',
                      width: width, height: width)
              ),
              textMajor("to explore", Color(0xff22254C), 26),
              SizedBox(
                height: 5,
              ),
              _exploreList(height, width)
            ],
          ),
        ),
      ),
    ) : Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
