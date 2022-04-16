import 'package:exploresg/helper/auth_controller.dart';
import 'package:exploresg/helper/favourites_controller.dart';
import 'package:exploresg/helper/places_api.dart';
import 'package:exploresg/helper/tracker_controller.dart';
import 'package:exploresg/helper/utils.dart';
import 'package:exploresg/models/invitation.dart';
import 'package:exploresg/models/place.dart';
import 'package:exploresg/screens/place_ui.dart';
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
  TrackerController _trackerController = TrackerController();
  AuthController _authController = AuthController();
  PlacesApi _placesApi = PlacesApi();
  FavouritesController _favouritesController = FavouritesController();
  List<Invitation> _invites = [], _toExplore = [], _explored = [];
  Map<String, Place> _places = {};
  bool _isLoaded = false;
  String _dropDownValue = 'to explore';
  List<String> _dropDownValues = ['unexplored', 'to explore', 'explored'];
  List<String> _favourites = [];

  @override
  void initState() {
    super.initState();
    _loadExplores();
  }

  Widget _dropDown(Invitation invite) {
    if (invite.visited) {
      _dropDownValue = 'explored';
      _dropDownValues = ['explored'];
    } else {
      _dropDownValue = 'to explore';
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      margin: EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0XffFFF9ED),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _dropDownValue,
          icon: const Icon(Icons.keyboard_arrow_down),
          style: const TextStyle(
            color: Colors.orange,
            fontFamily: 'AvenirLtStd',
            fontSize: 14,
          ),
          onChanged: (String? newValue) {
            setState(() {
              _dropDownValue = newValue!;
              _checkAction(invite);
            });
          },
          items: _dropDownValues
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _inviteContainer(Invitation invite, double width) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _dropDown(invite),
        Container(
            child: textMinor('date: ${invite.date}', Color(0xff22254C)),
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
        SizedBox(
          height: 5,
        ),
        Container(child: textMinor('time: ${invite.time}', Color(0xff22254C))),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            textMinorBold('people', Color(0xff22254C), 14),
            SizedBox(
              width: 20,
            ),
            Container(
              width: width * 0.5,
              height: 25,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: invite.users.length,
                itemBuilder: (BuildContext context, int idx) => ClipOval(
                  child: Column(
                    children: [
                      invite.users[idx].getPicture() == ''
                          ? CircleAvatar(
                              radius: 12.5,
                              backgroundColor: Color(0xff6488E5),
                              child: textMajor(
                                  invite.users[idx].getUsername() != ''
                                      ? invite.users[idx].getUsername()[0]
                                      : '?',
                                  Colors.white,
                                  10),
                            )
                          : Image.network(
                              invite.users[idx].getPicture(),
                              height: width / 16,
                              width: width / 16,
                              fit: BoxFit.cover,
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _exploreList(List<Invitation> list, double height, double width) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, PlaceScreen.routeName,
                    arguments: PlaceScreenArguments(
                        _places[list[index].getPlace()]!, _favourites));
              },
              child: placeContainer(
                  _places[list[index].getPlace()]!,
                  0.8 * width,
                  0.3 * height,
                  _inviteContainer(list[index], width),
                  Container()),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        );
      },
    );
  }

  void _checkAction(Invitation invite) async {
    var user = _authController.getCurrentUser();
    if (_dropDownValue == 'explored' && !invite.visited) {
      await _trackerController.setExplored(invite, user!.uid);
    } else if (_dropDownValue == 'to explore' && invite.visited) {
      await _trackerController.setToExplored(invite, user!.uid);
    } else if (_dropDownValue == 'unexplored') {
      await _trackerController.setUnexplored(invite, user!.uid);
    }
    setState(() {
      _loadExplores();
    });
  }

  void _loadExplores() async {
    _favourites = await _favouritesController.getFavouritesList();
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
    var result =
        await _trackerController.sortBasedOnToExploreAndExplored(_invites);
    _toExplore = result[0];
    _explored = result[1];
    setState(() {
      _isLoaded = true;
    });
  }

  void _reload() {
    _isLoaded = false;
    setState(() {});
    _loadExplores();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return _isLoaded
        ? RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _isLoaded = false;
              });
              _reload();
            },
            child: Scaffold(
              body: Container(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _reload();
                        },
                        child: topBar('my tracker', height, width,
                            'assets/img/tracker-top.svg'),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      textMajor('to explore', Color(0xff22254C), 26),
                      _toExplore.length != 0
                          ? _exploreList(_toExplore, height, width)
                          : Container(),
                      FittedBox(
                          fit: BoxFit.fill,
                          child: SvgPicture.asset('assets/img/tracker-mid.svg',
                              width: width, height: width)),
                      textMajor('explored', Color(0xff22254C), 26),
                      _explored.length != 0
                          ? _exploreList(_explored, height, width)
                          : Container(),
                      SizedBox(
                        height: 35,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
