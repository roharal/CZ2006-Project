import 'package:exploresg/helper/auth_controller.dart';
import 'package:exploresg/helper/invitation_controller.dart';
import 'package:exploresg/helper/reviews_controller.dart';
import 'package:exploresg/helper/tracker_controller.dart';
import 'package:exploresg/helper/utils.dart';
import 'package:exploresg/models/invitation.dart';
import 'package:exploresg/models/place.dart';
import 'package:exploresg/models/review.dart';
import 'package:exploresg/screens/review_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:exploresg/helper/favourites_controller.dart';
import 'package:flutter_svg/svg.dart';


class PlaceScreenArguments {
  final Place place;
  final List<String> favourites;

  PlaceScreenArguments(this.place, this.favourites);
}

class PlaceScreen extends StatefulWidget {
  static const routeName = '/placeScreen';
  final Place place;
  final List<String> favourites;

  PlaceScreen(this.place, this.favourites);

  @override
  State<StatefulWidget> createState() {
    return _PlaceScreen();
  }
}

class _PlaceScreen extends State<PlaceScreen> {
  String _dropDownValue = 'unexplored';
  AuthController _authController = AuthController();
  InvitationController _invitationController = InvitationController();
  FavouritesController _favouritesController = FavouritesController();
  ReviewsController _reviewsController = ReviewsController();
  TrackerController _trackerController = TrackerController();
  AuthController _auth = AuthController();
  final _usernameKey = GlobalKey<FormState>();
  List<String> _favourites = [], _usernames = [];
  bool _isLoaded = false,
      _userReviewExists = false,
      _isDate = false,
      _isTime = false,
      _isSending = false;
  String _userID = '', _submittable = 'NA', _selectedTime = '', _username = '';
  Review _prevReview = Review('', '', '', 0); //to view previous review data
  Review _newReview = Review('', '', '', 0); //to store new review data
  late PlaceRating _placeRating;
  DateTime _selectedDate = DateTime.now();
  TextEditingController _textController = new TextEditingController();
  List<Invitation> _exploredPlaces = [];
  List<String> _dropDownValues = ['unexplored', 'to explore', 'explored'];

  @override
  void initState() {
    super.initState();
    _init();
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
        ),
      ),
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
            Icon(
              Icons.arrow_back_ios,
              color: Color(0xff22254C),
            ),
            textMinor(
              'back',
              Color(0xff22254C),
            ),
          ],
        ),
      ),
    );
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
          : Icon(Icons.question_mark),
    );
  }

  Widget _ratingsLabel() {
    return Container(
      padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          textMinor('google ratings: ', Color(0xff22254C)),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ReviewsScreen(widget.place),
              ));
            },
            child: textMinor('exploreSG ratings: ', Color(0xff22254C)),
          ),
        ],
      ),
    );
  }

  Widget _starRatings(Place place) {
    return Container(
      padding: const EdgeInsets.fromLTRB(40, 0, 40, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
                textMinor(
                  '(' + _placeRating.getTotalNumRating().toString() + ')',
                  Color(0xff6488E5),
                ),
                SizedBox(
                  width: 2,
                ),
                RatingBarIndicator(
                  rating: _placeRating.averageRating,
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
        ],
      ),
    );
  }

  Widget _placeDetails(Place place) {
    return Container(
      padding: const EdgeInsets.fromLTRB(40, 5, 40, 0),
      child: Column(
        children: [
          Row(
            children: [
              textMinor('address', Color(0xff22254C)),
              Flexible(
                child: textMinor(
                  place.placeAddress,
                  Color(0xff22254C),
                ),
              ),
            ],
          ),
          Row(
            children: [
              textMinor(
                'operating status: ',
                Color(0xff22254C),
              ),
              textMinor(
                place.openNow ? 'open' : 'closed',
                place.openNow ? Color(0xff6488E5) : Color(0xffE56372),
              ),
            ],
          ),
          SizedBox(height: 15),
          Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ReviewsScreen(widget.place),
                  ));
                },
                child: textMinor(
                  'see exploreSG reviews',
                  Color(0xff6488E5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _addFav(Place place, double height, double width) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0XffFFF9ED),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      width: width,
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () async {
                  await _favouritesController.addOrRemoveFav(place.id);
                  _favourites = await _favouritesController.getFavouritesList();
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
                      ),
              ),
              SizedBox(
                width: 10,
              ),
              textMinor(
                _favourites.contains(place.id)
                    ? 'added to favourites'
                    : 'add to favourites',
                Color(0xffD1D1D6),
              ),
            ],
          ),
        ],
      ),
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
      ),
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
          value: _dropDownValue,
          icon: Icon(Icons.keyboard_arrow_down),
          style: avenirLtStdStyle(Colors.orange),
          onChanged: (String? newValue) {
            setState(() {
              _dropDownValue = newValue!;
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

  Widget _toExplore() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
      child: Column(
        children: [
          Row(
            children: [
              Align(
                alignment: Alignment.centerLeft,
              ),
              textMinorBold('select date: ', Colors.black, 14),
              SizedBox(width: 20),
              InkWell(
                onTap: () {
                  _showDatePicker(context);
                },
                child: _isDate
                    ? textMinor(
                        _selectedDate.toString().split(' ')[0],
                        Color(0xff22254C),
                      )
                    : Image.asset('assets/img/placesCalendar.png',
                        height: 25, width: 25),
              ),
            ],
          ),
          SizedBox(height: 25),
          Row(
            children: [
              textMinorBold('select time: ', Colors.black, 14),
              SizedBox(width: 20),
              InkWell(
                onTap: () {
                  _showTimePicker(context);
                },
                child: _isTime
                    ? textMinor(
                        _selectedTime,
                        Color(0xff22254C),
                      )
                    : Image.asset('assets/img/placesClock.png',
                        height: 25, width: 25),
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            child: Column(
              children: [
                Row(
                  children: [
                    textMinorBold(
                      'friends:',
                      Color(0xff22254C), 14
                    ),
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
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _usernameForm(),
                    ElevatedButton(
                      child: textMinor('add', Colors.white),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xffD1D1D6),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        _validate();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: _isSending
                    ? textMinor('sending...', Colors.white)
                    : textMinor('invite', Colors.white),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  primary: Color(0xffD1D1D6),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  if (_isTime && _isDate && !_isSending) {
                    if (_pastTense(_selectedDate.toString().split(' ')[0])) {
                      if (_usernames.length == 0) {
                        showAlert(
                            context, 'no usernames', 'add usernames to invite');
                      } else {
                        _isSending = true;
                        _sendInvitation(
                            _usernames,
                            widget.place.id,
                            _selectedDate.toString().split(' ')[0],
                            _selectedTime);
                        setState(() {});
                      }
                    } else {
                      showAlert(context, 'invalid date and time',
                          'Please valid date and time');
                    }
                  } else {
                    showAlert(context, 'invalid date and time',
                        'Please select a date and time');
                  }
                },
              ),
              SizedBox(width: 8),
              Container(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  child: textMinor('add to explore', Colors.white),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    primary: Color(0xffD1D1D6),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    if (_isTime && _isDate) {
                      _invitationController.addToExplore(
                          widget.place.id,
                          _selectedDate.toString().split(' ')[0],
                          _selectedTime);
                      showAlert(context, 'Place added to explore', '');
                    } else {
                      showAlert(context, 'invalid date and time',
                          'Please select a date and time');
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
            child: Icon(
              Icons.clear,
              color: Color(0xffD1D1D6),
            ),
          ),
          SizedBox(
            width: 5,
          ),
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
          hintText: 'enter username',
          hintStyle: TextStyle(
            color: Color(0xffD1D1D6),
          ),
          icon: Icon(
            Icons.alternate_email,
            color: Color(0xffD1D1D6),
          ),
        ),
        style: avenirLtStdStyle(
          Color(0xff22254C),
        ),
        keyboardType: TextInputType.text,
        validator: _validateUsername,
        onSaved: (saved) {
          _username = saved!.trim().toLowerCase();
        },
      ),
    );
  }

  Widget _usernameForm() {
    return Form(
      key: _usernameKey,
      child: Column(
        children: <Widget>[_usernameTextField()],
      ),
    );
  }

  Widget _explored() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
      child: Column(
        children: [
          Row(
            children: [
              Align(
                alignment: Alignment.centerLeft,
              ),
              textMinor(
                'my rating',
                Color(0xff22254C),
              ),
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
            ],
          ),
          SizedBox(height: 25),
          Row(
            children: [
              textMinor(
                'my review',
                Color(0xff22254C),
              )
            ],
          ),
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
                  hintStyle: avenirLtStdStyle(
                    Color(0xffD1D1D6),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        30.0,
                      ),
                    ),
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                  ),
                ),
                style: avenirLtStdStyle(
                  Color(0xff22254C),
                ),
                maxLines: null,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          _submitReviewText(),
          SizedBox(height: 8),
          Container(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
                child: textMinor('submit review', Colors.white),
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    primary: Color(0xff6488E5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0),
                onPressed: () {
                  submitReview(_textController.text);
                }),
          ),
        ],
      ),
    );
  }

  Widget _statusText() {
    if (_dropDownValue == 'explored') {
      return _explored();
    } else if (_dropDownValue == 'to explore') {
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
  }

  void submitReview(String review) async {
    _userReviewExists =
        await _reviewsController.userReviewExists(widget.place.id, _userID);
    setState(() {
      _newReview.setUserReview(review);
      _newReview.setPlaceID(widget.place.id);
      _newReview.setUserID(_userID);
      if (_newReview.getUserRating() == 0 || _newReview.getUserReview() == '') {
        //either field is empty--invalid input
        _submittable = 'NO';
        null;
      } else if (_userReviewExists) {
        //if user's review already exists, just update review
        _reviewsController.updateReview(_newReview);
        _submittable = 'YES';
      } else {
        //user's review does not exist, create new one
        _reviewsController.createReview(_newReview);
        _submittable = 'YES';
      }
      _prevReview.setUserReview(review);
    });
  }

  Future _showDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2022),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _isDate = true;
        _selectedDate = picked;
      });
  }

  Future _showTimePicker(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      setState(() {
        _isTime = true;
        _selectedTime = picked.format(context);
      });
    }
  }

  bool _pastTense(String select) {
    String now = DateTime.now().toString().split(' ')[0];
    String month, day, nowMonth, nowDay;
    print(select);
    month = select.split('-')[1];
    day = select.split('-')[2];
    nowMonth = now.split('-')[1];
    nowDay = now.split('-')[2];
    if (int.parse(nowMonth) > int.parse(month)) {
      return false;
    } else if (int.parse(nowDay) > int.parse(day)) {
      return false;
    } else {
      return true;
    }
  }

  void _sendInvitation(
      List<String> usernames, String place, String date, String time) async {
    var currentUser = _authController.getCurrentUser();
    var result = await _invitationController.sendInvitationToUser(
        usernames, currentUser!.uid, place, date, time);
    if (result != null) {
      showAlert(context, 'unable to send invite', result);
    } else {
      showAlert(context, 'invitation sent!', '');
    }
    setState(() {
      _isSending = false;
    });
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username cannot be empty';
    }
    return null;
  }

  void _validate() async {
    if (_usernameKey.currentState!.validate()) {
      _usernameKey.currentState!.save();
      if (_usernames.contains(_username)) {
        showAlert(context, 'illegal move', 'username already entered');
      } else {
        var uid = await _authController.getUidfromUsername(_username);
        if (uid == _authController.getCurrentUser()!.uid) {
          showAlert(context, 'illegal move', 'you cannot invite yourself');
        } else {
          if (uid != 'notFound') {
            _usernames.add(_username);
          } else {
            showAlert(context, 'invalid username', 'enter a valid username');
          }
        }
      }
      setState(() {});
    }
  }

  void _removeUsername(int index) {
    setState(() {
      _usernames.removeAt(index);
    });
  }

  void _init() async {
    _favourites = widget.favourites;
    _userID = _auth.getCurrentUser()!.uid;
    _userReviewExists =
        await _reviewsController.userReviewExists(widget.place.id, _userID);
    if (_userReviewExists) {
      _prevReview =
          (await _reviewsController.getReview(widget.place.id, _userID))!;
      _newReview = _prevReview;
    }
    setMyStatus();
    _placeRating = await _reviewsController.getPlaceRating(widget.place.id);
    _textController.text = _prevReview.getUserReview();
    var results = await _trackerController.getConfirmedInvitations(_userID);
    if (results.length != 0) {
      var sorted = await _trackerController.sortBasedOnToExploreAndExplored(results);
      _exploredPlaces = sorted[1];
      if (_exploredPlaces.length != 0) {
        for (Invitation iv in _exploredPlaces) {
          if (iv.getPlace() == widget.place.id) {
            _dropDownValues = ['to explore', 'explored'];
            _dropDownValue = 'explored';
            break;
          }
        }
      }
    }
    setState(() {
      _isLoaded = true;
    });

  }

  void setMyStatus() {
    if (_userReviewExists)
      _dropDownValue = 'explored';
    else
      _dropDownValue = 'unexplored';
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return _isLoaded
        ? Scaffold(
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
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
                          child: textMajor(widget.place.getPlaceName(),
                              Color(0xff22254C), 36),
                        ),
                        SizedBox(height: 20),
                        _placeImg(widget.place),
                        _ratingsLabel(),
                        _starRatings(widget.place),
                        _placeDetails(widget.place),
                        SizedBox(height: 20),
                        _addFav(widget.place, height * 0.05, width),
                        _midVector(),
                        Container(
                          child: Text(
                            'my details',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'MadeSunflower',
                              fontSize: 26,
                              color: Color(0xff22254C),
                            ),
                          ),
                        ),
                        SizedBox(height: 7),
                        Container(
                          padding: EdgeInsets.fromLTRB(40, 5, 40, 5),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Text(
                                      'my status: ',
                                      style: TextStyle(
                                        fontFamily: 'AvenirLtStd',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff22254C),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    _dropDown(),
                                    //_renderDropdown();
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        _statusText(),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        : Container(
            color: Color(0xfffffcec),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
