import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exploresg/helper/auth_controller.dart';
import 'package:exploresg/helper/profile_controller.dart';
import 'package:exploresg/helper/utils.dart';
import 'package:exploresg/models/user.dart';
import 'package:exploresg/screens/login_ui.dart';
import 'package:flutter/material.dart';
import 'package:exploresg/helper/storage_controller.dart';
import 'package:exploresg/screens/change_password_ui.dart';
import 'package:exploresg/screens/interests_ui.dart';
import 'package:flutter_svg/svg.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfileScreen();
  }
}

class _ProfileScreen extends State<ProfileScreen> {
  var value = '';
  final Storage storage = Storage();
  bool _isLoaded = false;
  AuthController _auth = AuthController();
  ProfileController _profileController = ProfileController();
  late UserModel _userModel;
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  GlobalKey<FormState> _formkey2 = GlobalKey<FormState>();
  TextEditingController _textControllerFirst = new TextEditingController();
  TextEditingController _textControllerLast = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    String uid = _auth.getCurrentUser()!.uid;
    _auth.getUserFromId(uid).then((value) {
      _userModel = UserModel.fromSnapshot(value);
      setState(() {
        _isLoaded = true;
        print('User id is ' + _userModel.id);
        print(_userModel.picture);
      });
    }).onError((error, stackTrace) {
      showAlert(context, 'Retrieve User Profile', error.toString());
    });
  }

  Future<void> showInformationDialog(BuildContext context, String attr) async {
    return await showDialog(
      context: context,
      builder: (context) {
        final TextEditingController _textEditingController =
            TextEditingController();
        return AlertDialog(
          content: Form(
            key: _formkey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('change $attr'),
                TextFormField(
                  controller: _textEditingController,
                  validator: (value) {
                    return value!.isNotEmpty ? null : 'invalid field';
                  },
                  decoration: InputDecoration(hintText: 'enter some text'),
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('submit'),
              onPressed: () {
                if (_formkey.currentState!.validate()) {
                  _auth.updateUserById(
                      _userModel.id, {attr: _textEditingController.text});
                  Future.delayed(Duration(milliseconds: 1000), () {
                    setState(() {
                      switch (attr) {
                        case 'username':
                          {
                            _userModel.username = _textEditingController.text;
                          }
                          break;
                        case 'email':
                          {
                            _userModel.email = _textEditingController.text;
                          }
                      }
                    });
                  });
                  Navigator.of(context).pop();
                }
              },
            )
          ],
        );
      },
    );
  }

  Widget _showPFP() {
    String picturez = _userModel.getPicture();
    print('Hello im here ' + picturez);
    imageCache!.clear();
    return CircleAvatar(
      radius: 45,
      foregroundImage: NetworkImage(picturez),
      backgroundColor: Colors.white,
      child: textMajor(
          _userModel.getUsername() != '' ? _userModel.getUsername()[0] : '?',
          Color(0xff22254C),
          35),
    );
  }

  Widget _displayName(width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding:
                EdgeInsets.symmetric(horizontal: width * (1 / 9), vertical: 5),
            width: width,
            child: textMinorBold(
              'display name: ' +
                  _userModel.getFirstName() +
                  ' ' +
                  _userModel.getLastName(),
              Color(0xff22254C), 18
            )),
        Form(
          key: _formkey2,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: width * (1 / 80)),
                    width: width * (4 / 10),
                    child: TextFormField(
                      autofocus: false,
                      controller: _textControllerFirst,
                      decoration: new InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'first name',
                        hintMaxLines: 3,
                        hintStyle: avenirLtStdStyle(
                          Color(0xffD1D1D6),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: const BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      style: avenirLtStdStyle(
                        Color(0xff22254C),
                      ),
                      maxLines: null,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Field is empty';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: width * (1 / 80)),
                    width: width * (4 / 10),
                    child: TextFormField(
                      autofocus: false,
                      controller: _textControllerLast,
                      decoration: new InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'last name',
                        hintMaxLines: 3,
                        hintStyle: avenirLtStdStyle(
                          Color(0xffD1D1D6),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: const BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      style: avenirLtStdStyle(
                        Color(0xff22254C),
                      ),
                      maxLines: null,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Field is empty';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: width * (1 / 9), vertical: 5),
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  child: textMinorBold(
                    'change',
                    Color(0xff22254C), 14
                  ),
                  onPressed: () {
                    print('Button pressed');
                    if (_formkey2.currentState!.validate()) {
                      print('Form is valid!');
                      _auth.updateUserById(_userModel.getId(), {
                        'firstName': _textControllerFirst.text,
                        'lastName': _textControllerLast.text
                      });
                      String _firstName = _textControllerFirst.text;
                      String _lastName = _textControllerLast.text;
                      setState(() {
                        FocusManager.instance.primaryFocus?.unfocus();
                        _userModel.setFirstName(_firstName);
                        _userModel.setLastName(_lastName);
                        _textControllerFirst.clear();
                        _textControllerLast.clear();
                      });
                    } else {
                      print('Form not valid!');
                    }
                  },
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xffF9BE7D)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _changePFP(width) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
          width: width * (3 / 4),
          // color: Colors.red,
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textMinorBold(
                'profile picture',
                Color(0xff22254C), 14
              ),
            ],
          ),
        ),
        Container(
            child: ElevatedButton(
                child: textMinorBold(
                  'change',
                  Color(0xff22254C), 14
                ),
                onPressed: () async {
                  _changePFPFunc();
                },
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xffF9BE7D)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    )))))
      ],
    );
  }

  Widget _changeUsername(width) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
          width: width * (3 / 4),
          // color: Colors.red,
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textMinorBold(
                'username',
                Color(0xff22254C), 14
              ),
              Text(
                '@' + _userModel.getUsername(),
                style: avenirLtStdStyle(
                  Color(0xff22254C),
                ),
              ),
            ],
          ),
        ),
        Container(
          child: ElevatedButton(
            child: textMinorBold(
              'change',
              Color(0xff22254C), 14
            ),
            onPressed: () async {
              await showInformationDialog(context, 'username');
            },
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              backgroundColor: MaterialStateProperty.all(Color(0xffF9BE7D)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _changePassword(width) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
          width: width * (3 / 4),
          // color: Colors.red,
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textMinorBold(
                'password',
                Color(0xff22254C), 14
              ),
              textMinorBold(
                'must be between 8 - 20 characters',
                Color(0xff22254C), 14
              ),
            ],
          ),
        ),
        Container(
          child: ElevatedButton(
            child: textMinorBold(
              'change',
              Color(0xff22254C), 14
            ),
            onPressed: () {
              Navigator.pushNamed(context, ChangePasswordScreen.routeName,
                  arguments: ChangePasswordArguments(_userModel.email));
            },
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              backgroundColor: MaterialStateProperty.all(Color(0xffF9BE7D)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _manageInterests(width) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
          width: width * (3 / 4),
          // color: Colors.red,
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textMinorBold(
                'manage interests',
                Color(0xff22254C), 14
              ),
            ],
          ),
        ),
        Container(
            child: ElevatedButton(
                child: textMinorBold(
                  'change',
                  Color(0xff22254C), 14
                ),
                onPressed: () async {
                  DocumentSnapshot snapShot =
                      await _auth.getUserFromId(_userModel.getId());
                  _userModel = UserModel.fromSnapshot(snapShot);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => InterestScreen(
                        _userModel.getId(), _userModel.getInterest()),
                  ));
                },
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xffF9BE7D)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    )))))
      ],
    );
  }

  Widget _signOut(width) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
          width: width * (3 / 4),
          // color: Colors.red,
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textMinorBold(
                'sign out from account',
                Color(0xff22254C), 14
              ),
            ],
          ),
        ),
        Container(
          child: ElevatedButton(
            child: textMinorBold(
              'signout',
              Color(0xff22254C), 14
            ),
            onPressed: () {
              _auth.logOut();
              Navigator.of(context, rootNavigator: true)
                  .pushNamedAndRemoveUntil(
                      LoginScreen.routeName, (Route<dynamic> route) => false);
            },
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              backgroundColor: MaterialStateProperty.all(Color(0xffF9BE7D)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  void _changePFPFunc() async {
    // Selecting file from phone using file picker
    final results = await _profileController.getFile();
    print(results.runtimeType);
    if (results == null) {
      // If user did not pick a file (Pressed back)
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Container(
          child: Text('No file selected'),
          height: 30,
          alignment: Alignment.topCenter,
        ),
        duration: Duration(seconds: 1),
      ));
      return null;
    }
    // Upload file and Update the User picture attribute
    String fileUrl =
        await _profileController.uploadFileAndUpdateUser(results, _userModel);
    _userModel.picture = fileUrl;
    setState(() {});
  }

  void _reload() {
    _isLoaded = false;
    _init();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return _isLoaded
        ? Scaffold(
            body: Container(
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _reload();
                        },
                        child: topBar('my account', height, width,
                            'assets/img/account-top.svg'),
                      ),
                      SizedBox(height: 35),
                      _showPFP(),
                      SizedBox(
                        height: 10,
                      ),
                      _displayName(width),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: SvgPicture.asset('assets/img/account-mid.svg',
                              width: width, height: width / 375 * 148),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: textMajor(
                            'account settings', Color(0xff22254C), 30),
                      ),
                      _changePFP(width),
                      _changeUsername(width),
                      _changePassword(width),
                      _manageInterests(width),
                      _signOut(width),
                      Container(height: 20), //Space for the nav bar to scroll
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
