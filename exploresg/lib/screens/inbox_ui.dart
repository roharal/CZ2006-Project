import 'package:exploresg/helper/auth_controller.dart';
import 'package:exploresg/helper/favourites_controller.dart';
import 'package:exploresg/helper/inbox_controller.dart';
import 'package:exploresg/helper/places_api.dart';
import 'package:exploresg/helper/tracker_controller.dart';
import 'package:exploresg/helper/utils.dart';
import 'package:exploresg/models/invitation.dart';
import 'package:exploresg/models/place.dart';
import 'package:exploresg/models/user.dart';
import 'package:exploresg/screens/place_ui.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class InboxScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _InboxScreen();
  }
}

class _InboxScreen extends State<InboxScreen> {
  InboxController _inboxController = InboxController();
  TrackerController _trackerController = TrackerController();
  AuthController _authController = AuthController();
  PlacesApi _placesApi = PlacesApi();
  Map<String, Place> _places = {};
  List<Invitation> _inbox = [];
  bool _isLoaded = false;
  late UserModel _userModel;
  List<String> _favourites = [];
  FavouritesController _favouritesController = FavouritesController();

  @override
  void initState() {
    super.initState();
    _loadInbox();
  }

  Widget _invitationContainer(
      int index, var width, Invitation invitationC, Place place) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      width: width * (10 / 11),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            // color: Colors.green,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  // color: Colors.yellow,
                  height: width * (1 / 10),
                  child: invitationC.users[0].getPicture() != ''
                      ? Image.network(invitationC.users[0].getPicture())
                      : CircleAvatar(
                          radius: 12.5,
                          backgroundColor: Color(0xff6488E5),
                          child: textMajor(
                              invitationC.users[0].getUsername() != ''
                                  ? invitationC.users[0].getUsername()[0]
                                  : '?',
                              Colors.white,
                              10),
                        ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  alignment: Alignment.center,
                  // color: Colors.blue,
                  child: textMinor(
                    'invites you to ...',
                    Color(0xff22254C),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 3),
            width: width * (10 / 11),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  width: width * (9 / 20),
                  // color: Colors.blue,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Container(
                      height: 100,
                      width: 100,
                      child: place.getImages().length != 0
                          ? Image.network(place.getImages()[0])
                          : Icon(Icons.question_mark),
                    ),
                  ),
                ),
                Container(
                  height: width * (9 / 20),
                  width: width * (9 / 20),
                  alignment: Alignment.topLeft,
                  // color: Colors.pink,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Spacer(flex: 3),
                      textMinorBold(
                        place.getPlaceName(),
                        Color(0xff22254C), 14
                      ),
                      RatingBarIndicator(
                        rating: place.getRatings(),
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 20.0,
                        direction: Axis.horizontal,
                      ),
                      Spacer(flex: 1),
                      textMinor(
                        place.getPlaceAddress(),
                        Color(0xff22254C),
                      ),
                      Spacer(flex: 5),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
              child: textMinor(
                  'date: ${invitationC.getDate()}', Color(0xff22254C)),
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
          Container(
              child: textMinor(
                  'time: ${invitationC.getTime()}', Color(0xff22254C))),
          Container(
            padding: EdgeInsets.all(1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white)),
                    icon: Icon(Icons.alarm_on_sharp, color: Color(0xff6488E5)),
                    label: Text('accept',
                        style: TextStyle(color: Color(0xff6488E5))),
                    onPressed: () {
                      _trackerController.acceptInvite(invitationC, _userModel);
                      _removeInvite(index);
                      setState(() {});
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white)),
                    icon: Icon(Icons.alarm_off_sharp, color: Color(0xffE56372)),
                    label: Text(
                      'reject',
                      style: TextStyle(color: Color(0xffE56372)),
                    ),
                    onPressed: () {
                      _trackerController.rejectInvite(invitationC, _userModel);
                      _removeInvite(index);
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _inboxList(double width) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _inbox.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, PlaceScreen.routeName,
                    arguments: PlaceScreenArguments(
                        _places[_inbox[index].getPlace()]!, _favourites));
              },
              child: _invitationContainer(index, width, _inbox[index],
                  _places[_inbox[index].getPlace()]!),
            ),
            SizedBox(
              height: 5,
            )
          ],
        );
      },
    );
  }

  void _removeInvite(int index) {
    _inbox.removeAt(index);
  }

  void _loadInbox() async {
    _favourites = await _favouritesController.getFavouritesList();
    var user = _authController.getCurrentUser();
    await _authController.getUserFromId(user!.uid).then((value) {
      _userModel = UserModel.fromSnapshot(value);
    });
    _inbox = await _inboxController.getConfirmedInvitations(_userModel.getId());

    if (_inbox.length != 0) {
      for (Invitation iv in _inbox) {
        var place = await _placesApi.placeDetailsSearchFromText(iv.getPlace());
        if (place != null) {
          _places[iv.getPlace()] = place;
          print(place.id);
        }
      }
    }
    setState(() {
      _isLoaded = true;
    });
  }

  void _reload() async {
    _isLoaded = false;
    setState(() {});
    _loadInbox();
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
              body: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _reload();
                        },
                        child: topBar('my inbox', height, width,
                            'assets/img/inbox-top.svg'),
                      ),
                      _inboxList(width),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Container(
            color: Color(0XffFFF9ED),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
