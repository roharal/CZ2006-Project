import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exploresg/helper/authController.dart';
import 'package:exploresg/helper/firebase_api.dart';
import 'package:exploresg/helper/invitation_controller.dart';
import 'package:exploresg/helper/reviewsController.dart';
import 'package:exploresg/helper/utils.dart';
import 'package:exploresg/models/place.dart';
import 'package:exploresg/screens/exploreReviews.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:exploresg/helper/favourites_controller.dart';
import 'package:flutter_svg/svg.dart';

import '../models/review.dart';

class PlaceScreenArguments {
  final Place place;
  final List<String> favourites;

  PlaceScreenArguments(this.place, this.favourites);
}

class PlaceScreen extends StatefulWidget {
  static const routeName = "/placeScreen";
  final Place place;
  final List<String> favourites;
  PlaceScreen(this.place, this.favourites);

  @override
  State<StatefulWidget> createState() {
    return _PlaceScreen();
  }
}

class _PlaceScreen extends State<PlaceScreen> {
  String dropDownValue = 'unexplored';
  AuthController _authController = AuthController();
  InvitationController _invitationController = InvitationController();
  FavouritesController _favouritesController = FavouritesController();
  ReviewsController _reviewsController = ReviewsController();
  AuthController _auth = AuthController();
  final _usernameKey = GlobalKey<FormState>();
  List<String> _favourites = [], _usernames = [];
  bool _isLoaded = false, _userReviewExists= false, _isDate = false, _isTime = false, _isSending = false;
  String _userID = '', _submittable = "NA", _selectedTime = "", _username = "";
  Review _prevReview = Review('', '', '', 0); //to view previous review data
  Review _newReview = Review('', '', '', 0); //to store new review data
  double _meanRating = 0;
  int _numRatings = 0;
  DateTime _selectedDate = DateTime.now();
  TextEditingController _textController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    _userID = _auth.getCurrentUser()!.uid;
    _userReviewExists =
        await _reviewsController.userReviewExists(widget.place.id, _userID);
    if (_userReviewExists) {
      _prevReview =
          (await _reviewsController.getReview(widget.place.id, _userID))!;
      _newReview = _prevReview;
    }
    setMyStatus();
    _meanRating = await _reviewsController.getAverageRating(widget.place.id);
    _numRatings = await _reviewsController.getNumRatings(widget.place.id);
    _textController.text = _prevReview.getUserReview();
    setState(() {
      _isLoaded = true;
    });
  }

  void setMyStatus() {
    if (_userReviewExists)
      dropDownValue = 'explored';
    else
      dropDownValue = 'unexplored';
  }

  Widget _topVector() {
    double _width = MediaQuery.of(context).size.width;
    return SafeArea(
      top: true,
      child: FittedBox(
          fit: BoxFit.fill,
          child: SvgPicture.asset(
            'assets/img/place-top.svg',
            width: _width,
            height: _width * 116 / 375,
          )),
    );
  }

  Widget _back() {
    return Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.only(left: 16),
        child: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Row(
            children: [
              Icon(Icons.arrow_back_ios, color: Color(0xff22254C)),
              Text("back",
                  style: TextStyle(
                      fontFamily: 'AvenirLtStd',
                      fontSize: 14,
                      color: Color(0xff22254C)))
            ],
          ),
        ));
  }

  Widget _placeImg(Place place) {
    return Container(
        height: 200,
        width: 330,
        decoration: BoxDecoration(
          color: Color(0xffd1d1d6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: place.images.length > 0
            ? Image.network(place.images[0])
            : Image.asset('assets/img/catsafari.png'));
  }

  Widget _ratingsLabel() {
    return Container(
        padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Google ratings:",
                style: TextStyle(
                    fontFamily: 'AvenirLtStd',
                    fontSize: 14,
                    color: Color(0xff22254C))),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ReviewsScreen(place: widget.place),
                ));
              },
              child: Text("exploreSG ratings:",
                  style: TextStyle(
                      fontFamily: 'AvenirLtStd',
                      fontSize: 14,
                      color: Color(0xff22254C))),
            )
          ],
        ));
  }

  Widget _starRatings(Place place) {
    return Container(
        padding: const EdgeInsets.fromLTRB(40, 0, 40, 10),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              RatingBarIndicator(
                rating: place.ratings,
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                itemCount: 5,
                itemSize: 20,
                direction: Axis.horizontal,
              ),
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    textMinor('('+ _numRatings.toString() + ')', Color(0xff6488E5)),
                    SizedBox(width: 2,),
                    RatingBarIndicator(
                      rating: _meanRating,
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 20,
                      direction: Axis.horizontal,
                    ),
                  ],
                ),
              ),
        ]));
  }

  Widget _placeDetails(Place place) {
    return Container(
        padding: const EdgeInsets.fromLTRB(40, 5, 40, 0),
        child: Column(children: [
          Row(children: [
            Text('address: ',
                style: TextStyle(
                    fontFamily: 'AvenirLtStd',
                    fontSize: 14,
                    color: Color(0xff22254C))),
            Flexible(
              child: Text(place.placeAddress,
                  style: TextStyle(
                      fontFamily: 'AvenirLtStd',
                      fontSize: 14,
                      color: Color(0xff22254C))),
            ),
          ]),
          Row(
            children: [
              Text('operating status: ',
                  style: TextStyle(
                      fontFamily: 'AvenirLtStd',
                      fontSize: 14,
                      color: Color(0xff22254C))),
              Text(place.openNow ? 'Open' : 'Closed',
                  style: TextStyle(
                    fontFamily: 'AvenirLtStd',
                    fontSize: 14,
                    color:
                        place.openNow ? Color(0xff6488E5) : Color(0xffE56372),
                  )),
            ],
          ),
          SizedBox(height: 15),
          Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ReviewsScreen(place: widget.place),
                  ));
                },
                child: Text("see exploreSG reviews",
                    style: TextStyle(
                      fontFamily: 'AvenirLtStd',
                      fontSize: 14,
                      color: Color(0xff6488E5),
                      decoration: TextDecoration.underline,
                    )),
              ),
            ],
          )
        ]));
  }

  Widget _addFav(Place place, double height, double width) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        width: width,
        height: height,
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(children: [
                InkWell(
                    onTap: () async {
                      await _favouritesController.addOrRemoveFav(place.id);
                      _favourites =
                      await _favouritesController.getFavouritesList();
                      print('<3 pressed');
                      setState(() {
                        place.likes = !place.likes;
                      });
                      print(place.likes);
                    },
                    child: _favourites.contains(place.id)
                        ? Icon(
                      Icons.favorite,
                      color: Color(0xffE56372),
                    )
                        : Icon(
                      Icons.favorite_border,
                      color: Color(0xffE56372),
                    )),
                SizedBox(
                  width: 10,
                ),
                textMinor(_favourites.contains(place.id) ? 'added to favourites' : "add to favourites", Color(0xffD1D1D6))
              ])
            ]));
  }

  Widget recommendedList(List<Place> places, double height, double width) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: places.length,
      itemBuilder: (context, index) {
        return Column(children: [
          Stack(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, PlaceScreen.routeName,
                        arguments: PlaceScreenArguments(places[index], _favourites));
                  },
                  child: placeContainer(places[index], 0.8 * width, 0.215 * height, _addFav(places[index], 0.05 * height, 0.8 * width), Container()),
                ),
              ]
          ),
          SizedBox(
            height: 15,
          )
        ]);
      },
    );
  }

  Widget _midVector() {
    double _width = MediaQuery.of(context).size.width;
    return FittedBox(
        fit: BoxFit.fill,
        child: SvgPicture.asset(
          'assets/img/place-mid.svg',
          width: _width,
          height: _width * 215 / 375,
        ));
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

  Widget _toExplore() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
        child: Column(children: [
          Row(children: [
            Align(
              alignment: Alignment.centerLeft,
            ),
            Text("select date: ",
                style: TextStyle(
                  fontFamily: 'AvenirLtStd',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(width: 20),
            InkWell(
              onTap: () {
                _showDatePicker(context);
              },
              child: _isDate ? textMinor(_selectedDate.toString().split(" ")[0], Colors.black) : Image.asset('assets/img/placesCalendar.png', height: 25, width: 25),
            ),
          ]),
          SizedBox(height: 25),
          Row(children: [
            Text("select time: ",
                style: TextStyle(
                  fontFamily: 'AvenirLtStd',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(width: 20),
            InkWell(
              onTap: () {
                _showTimePicker(context);
              },
              child: _isTime ? textMinor(_selectedTime, Colors.black) : Image.asset('assets/img/placesClock.png', height: 25, width: 25),
            ),
          ]),
          SizedBox(height: 20),
          Container(
            child: Column(
              children: [
                Row(
                  children: [
                    textMinorBold("friends:", Colors.black),
                    SizedBox(width: 20),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: 30,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: _usernames.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _usernameContainer(index);
                        },
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _usernameForm(),
                    ElevatedButton(
                      child: Text('add',
                          style: TextStyle(
                            fontFamily: 'AvenirLtStd',
                            color: Colors.white,
                            fontSize: 16,
                          )),
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xffD1D1D6),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      onPressed: () {
                        _validateLogin();
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              child: _isSending ? Text('Sending invite...',
                  style: TextStyle(
                    fontFamily: 'AvenirLtStd',
                    color: Colors.white,
                    fontSize: 16,
                  )) :
              Text('invite',
                  style: TextStyle(
                    fontFamily: 'AvenirLtStd',
                    color: Colors.white,
                    fontSize: 16,
                  )),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  primary: Color(0xffD1D1D6),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              onPressed: () {
                if (_isTime && _isDate && !_isSending) {
                  if (_usernames.length == 0) {
                    showAlert(context, "no usernames", "add usernames to invite");
                  } else {
                    _isSending = true;
                    _sendInvitation(_usernames, widget.place.id, _selectedDate.toString().split(" ")[0], _selectedTime);
                    setState(() {});
                  }
                } else {
                  showAlert(context, "invalid date and time", "Please select a date and time");
                }
              },
            ),
            SizedBox(width: 8),
            Container(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                child: Text('add-to-explore',
                    style: TextStyle(
                      fontFamily: 'AvenirLtStd',
                      color: Colors.white,
                      fontSize: 16,
                    )),
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    primary: Color(0xffD1D1D6),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                onPressed: () {},
              ),
            )
          ])
        ]));
  }

  Widget _usernameContainer(int index) {
    return Container(
      child: Row(
        children: [
          textMinor(_usernames[index], Colors.black),
          InkWell(
            onTap: () {
              _removeUsername(index);
            },
            child: Icon(Icons.clear, color: Color(0xffD1D1D6),),
          ),
          SizedBox(width: 5,)
        ],
      ),
    );
  }

  Widget _usernameTextField() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.6,
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: TextFormField(
          obscureText: false,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "enter username",
            hintStyle: TextStyle(
              color: Color(0xffD1D1D6),
            ),
            icon: Icon(
              Icons.alternate_email,
              color: Color(0xffD1D1D6),
            ),
          ),
          style: TextStyle(
            fontFamily: 'AvenirLtStd',
            color: Color(0xff22254C),
            fontSize: 14,
          ),
          keyboardType: TextInputType.text,
          validator: _validateUsername,
          onSaved: (saved) {
            _username = saved!.trim().toLowerCase();
          },
        ));
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return "Username cannot be empty";
    }
    return null;
  }

  void _validateLogin() async {
    if (_usernameKey.currentState!.validate()) {
      _usernameKey.currentState!.save();
      if (_usernames.contains(_username)) {
        showAlert(context, "illegal move", "username already entered");
      } else {
        var uid = await _authController.getUidfromUsername(_username);
        print(uid);
        if (uid == _authController.getCurrentUser()!.uid) {
          showAlert(context, "illegal move", "you cannot invite yourself");
        }
        if (uid != "notFound") {
          _usernames.add(_username);
        } else {
          showAlert(context, "invalid username", "enter a valid username");
        }
      }
      setState(()  {});
    }
  }

  void _removeUsername(int index) {
    setState(() {
      _usernames.removeAt(index);
    });
  }

  Widget _usernameForm() {
    return Form(
      key: _usernameKey,
      child: Column(
        children: <Widget>[
          _usernameTextField()
        ],
      ),
    );
  }

  void _sendInvitation(List<String> usernames, String place, String date, String time) async {
    var currentUser = _authController.getCurrentUser();
    var result = await _invitationController.sendInvitationToUser(usernames, currentUser!.uid, place, date, time);
    if (result != null) {
      showAlert(context, "unable to send invite", result);
    } else {
      showAlert(context, "invitation sent!", "");
    }
    setState(() {
      _isSending = false;
    });
  }

  Widget _explored() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
        child: Column(children: [
          Row(children: [
            Align(
              alignment: Alignment.centerLeft,
            ),
            Text("my rating: ",
                style: TextStyle(
                    fontFamily: 'AvenirLtStd',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff22254C))),
            SizedBox(width: 7),
            RatingBar.builder(
              initialRating:
                  _userReviewExists ? _prevReview.getUserRating() : 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 22,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                _newReview.setUserRating(rating);
              },
            ),
          ]),
          SizedBox(height: 25),
          Row(children: [
            Text("my review: ",
                style: TextStyle(
                  fontFamily: 'AvenirLtStd',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff22254C),
                )),
          ]),
          SizedBox(height: 7),
          Container(
              height: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
              child: Container(
                  child: TextFormField(
                    controller: _textController,
                    decoration: new InputDecoration(
                      hintText:
                          'describe your experience or record some nice memories...',
                      hintMaxLines: 3,
                      hintStyle: TextStyle(
                        fontFamily: 'AvenirLtStd',
                        fontSize: 14,
                        color: Color(0xffD1D1D6),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    style: TextStyle(
                      fontFamily: 'AvenirLtStd',
                      color: Color(0xff22254C),
                      fontSize: 14,
                    ),
                    maxLines: null,
              ))),
          SizedBox(
            height: 5,
          ),
          _submitReviewText(),
          SizedBox(height: 8),
          Container(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
                child: Text('submit review',
                    style: TextStyle(
                      fontFamily: 'AvenirLtStd',
                      color: Colors.white,
                      fontSize: 16,
                    )),
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    primary: Color(0xff6488E5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    elevation: 0),
                onPressed: () {
                  submitReview(_textController);
                }),
          ),
        ]));
  }

  void submitReview(var textController) {
    setState(() {
      _newReview.setUserReview(textController.text);
      var _data = {
        'userID': _userID,
        'rating': _newReview.getUserRating(),
        'review_text': _newReview.getUserReview()
      };
      if (_newReview.getUserRating() == 0 || _newReview.getUserReview() == '') {
        //either field is empty--invalid input
        _submittable = 'NO';
        null;
      } else if (_userReviewExists) {
        //if user's review already exists, just update review
        _reviewsController.updateReview(widget.place.id, _userID, _data);
        _submittable = 'YES';
      } else {
        //user's review does not exist, create new one
        _reviewsController.createReview(widget.place.id, _userID, _data);
        _submittable = 'YES';
      }
      _prevReview.setUserReview(textController.text);
    });
  }

  Future _showDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime(2022),lastDate: DateTime(2025),);
    if (picked != null && picked != _selectedDate)
      setState(() {
        _isDate = true;
        _selectedDate = picked;
      });
  }

  Future _showTimePicker(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      setState(() {
        _isTime = true;
        _selectedTime = picked.format(context);
      });
    }
  }

  Widget _statusText() {
    if (dropDownValue == 'explored') {
      return _explored();
    } else if (dropDownValue == 'to explore') {
      return _toExplore();
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _submitReviewText() {
    switch (_submittable) {
      case 'NA':
        return Container();
      case 'NO':
        return Container(
          alignment: Alignment.centerLeft,
          child: textMinor(
              'please fill up rating & review field', Color(0xffE56372)),
        );
      case 'YES':
        return Container(
          alignment: Alignment.centerLeft,
          child: textMinor('review submitted!', Color(0xff6488E5)),
        );
      default:
        return Container();
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    // List<DropdownMenuItem<String>> get dropdownItems {
    //   List<DropdownMenuItem<String>> statusItems = [
    //     DropdownMenuItem(child: Text("Unexplored"), value: "USA"),
    //     DropdownMenuItem(child: Text("To explore"), value: "Canada"),
    //     DropdownMenuItem(child: Text("Explored"), value: "Brazil"),
    //   ];
    //   return statusItems;
    // }

    return _isLoaded
        ? Scaffold(
            backgroundColor: createMaterialColor(Color(0xFFFFF9ED)),
            body: Column(children: [
              Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _topVector(),
                        _back(),
                        SizedBox(
                          height: 7,
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 40),
                            child: Text(widget.place.placeName,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'MadeSunflower',
                                  fontSize: 36,
                                  color: Color(0xff22254C)
                              ),
                            ),
                        ),
                        SizedBox(height: 20),
                        _placeImg(widget.place),
                        _ratingsLabel(),
                        _starRatings(widget.place),
                        _placeDetails(widget.place),
                        SizedBox(height: 20),
                        _midVector(),
                        Container(
                            //padding: const EdgeInsets.fromLTRB(25, 5, 40, 8),
                            child: Text("my details",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'MadeSunflower',
                                    fontSize: 26,
                                    color: Color(0xff22254C)))),
                        SizedBox(height: 7),
                        Container(
                          padding: EdgeInsets.fromLTRB(40, 5, 40, 5),
                          child: Column(children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Text("my status: ",
                                        style: TextStyle(
                                            fontFamily: 'AvenirLtStd',
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff22254C))),
                                    SizedBox(width: 5),
                                    _dropDown(),
                                    //_renderDropdown();
                                  ],
                                ))
                          ]),
                        ),
                        _statusText(),
                        SizedBox(
                          height: 20,
                        )
                  ])))
            ]))
        : Container(
      color: Color(0XffFFF9ED),
      child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
