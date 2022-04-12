import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exploresg/helper/utils.dart';
import 'package:exploresg/models/user.dart';
import 'package:exploresg/screens/login.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:exploresg/helper/storage_service.dart';
import 'package:exploresg/screens/changePassword.dart';
import 'package:exploresg/screens/interests_ui.dart';
import 'package:flutter_svg/svg.dart';

import '../helper/auth_controller.dart';
import '../helper/profile_controller.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfileScreen();
  }
}

class _ProfileScreen extends State<ProfileScreen> {
  var value = "";
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
        print("User id is " + _userModel.id);
      });
    }).onError((error, stackTrace) {
      showAlert(context, "Retrieve User Profile", error.toString());
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
                  Text("Change $attr"),
                  TextFormField(
                    controller: _textEditingController,
                    validator: (value) {
                      return value!.isNotEmpty ? null : "Invalid field";
                    },
                    decoration: InputDecoration(hintText: "Enter some text"),
                  )
                ],
              )),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Submit"),
              onPressed: () {
                if (_formkey.currentState!.validate()) {
                  _auth.updateUserById(
                      _userModel.id, {attr: _textEditingController.text});
                  Future.delayed(Duration(milliseconds: 1000), () {
                    setState(() {
                      switch (attr) {
                        case "username":
                          {
                            _userModel.username = _textEditingController.text;
                          }
                          break;
                        case "email":
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

  Widget _showPFP(width) {
    return CircleAvatar(
      radius: 45,
      foregroundImage: NetworkImage(_userModel.picture),
      backgroundColor: Color(0xff6488E5),
      child: textMajor(_userModel.username != "" ? _userModel.username[0] : "?",
          Colors.white, 35),
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
          child: Text(
            _userModel.firstName + " " + _userModel.lastName,
            style: TextStyle(
              fontSize: 18,
              fontFamily: "AvenirLtStd",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
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
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field is empty";
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
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field is empty";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                  child: Text("change",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: "AvenirLtStd",
                        fontWeight: FontWeight.bold,
                      )),
                  onPressed: () {
                    print("Button pressed");
                    if (_formkey2.currentState!.validate()) {
                      print("Form is valid!");
                      _auth.updateUserById(_userModel.id, {
                        "firstName": _textControllerFirst.text,
                        "lastName": _textControllerLast.text
                      });
                      String _firstName = _textControllerFirst.text;
                      String _lastName = _textControllerLast.text;
                      setState(() {
                        FocusManager.instance.primaryFocus?.unfocus();
                        _userModel.firstName = _firstName;
                        _userModel.lastName = _lastName;
                        _textControllerFirst.clear();
                        _textControllerLast.clear();
                      });
                    } else {
                      print("Form not valid!");
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xffF9BE7D)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      )))),
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
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            width: width * (3 / 4),
            // color: Colors.red,
            alignment: Alignment.centerLeft,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("profile picture",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: "AvenirLtStd",
                    fontWeight: FontWeight.bold,
                  )),
            ])),
        Container(
            child: ElevatedButton(
                child: Text("change",
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: "AvenirLtStd",
                      fontWeight: FontWeight.bold,
                    )),
                onPressed: () async {
                  _changePFPFunc();
                },
                style: ButtonStyle(
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
            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
            width: width * (3 / 4),
            // color: Colors.red,
            alignment: Alignment.centerLeft,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("username",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: "AvenirLtStd",
                    fontWeight: FontWeight.bold,
                  )),
              Text("@" + _userModel.username,
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: "AvenirLtStd",
                  ))
            ])),
        Container(
          child: ElevatedButton(
            child: Text(
              "change",
              style: TextStyle(
                fontSize: 12,
                fontFamily: "AvenirLtStd",
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () async {
              await showInformationDialog(context, "username");
            },
            style: ButtonStyle(
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
    return Row(children: [
      Container(
        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
        width: width * (3 / 4),
        // color: Colors.red,
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "password",
              style: TextStyle(
                fontSize: 18,
                fontFamily: "AvenirLtStd",
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "must be between 8-20 characters",
              style: TextStyle(
                fontSize: 13,
                fontFamily: "AvenirLtStd",
              ),
            )
          ],
        ),
      ),
      Container(
        child: ElevatedButton(
          child: Text("change",
              style: TextStyle(
                fontSize: 12,
                fontFamily: "AvenirLtStd",
                fontWeight: FontWeight.bold,
              )),
          onPressed: () {
            Navigator.pushNamed(context, ChangePasswordScreen.routeName,
                arguments: ChangePasswordArguments(_userModel.email));
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Color(0xffF9BE7D)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
          ),
        ),
      ),
    ]);
  }

  Widget _manageInterests(width) {
    return Row(children: [
      Container(
          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
          width: width * (3 / 4),
          // color: Colors.red,
          alignment: Alignment.centerLeft,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("manage interest",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: "AvenirLtStd",
                  fontWeight: FontWeight.bold,
                ))
          ])),
      Container(
          child: ElevatedButton(
              child: Text("change",
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: "AvenirLtStd",
                    fontWeight: FontWeight.bold,
                  )),
              onPressed: () async {
                DocumentSnapshot snapShot =
                    await _auth.getUserFromId(_userModel.id);
                _userModel = UserModel.fromSnapshot(snapShot);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      InterestScreen(_userModel.id, _userModel.interest),
                ));
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xffF9BE7D)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  )))))
    ]);
  }

  Widget _signOut(width) {
    return Row(children: [
      Container(
          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
          width: width * (3 / 4),
          // color: Colors.red,
          alignment: Alignment.centerLeft,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("sign out from account",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: "AvenirLtStd",
                  fontWeight: FontWeight.bold,
                ))
          ])),
      Container(
          child: ElevatedButton(
              child: Text("signout",
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: "AvenirLtStd",
                    fontWeight: FontWeight.bold,
                  )),
              onPressed: () {
                _auth.logOut();
                Navigator.of(context, rootNavigator: true)
                    .pushNamedAndRemoveUntil(
                        LoginScreen.routeName, (Route<dynamic> route) => false);
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xffF9BE7D)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  )))))
    ]);
  }

  void _changePFPFunc() async {
    // Selecting file from phone using file picker
    final results = await _profileController.getFile();
    // final results = await FilePicker.platform.pickFiles(
    //     allowMultiple: false,
    //     type: FileType.custom,
    //     allowedExtensions: ['png', 'jpg']);
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
    _profileController.uploadFileAndUpdateUser(results, _userModel);
    // // Setting file name and details etc
    // final path = results.files.single.path!;
    // final fileName = _userModel.id + "_pfp";
    //
    // print(path);
    // print(fileName);
    // // Uploading the file to firebase here
    // storage
    //     .uploadFile(path, fileName, "user_pfp")
    //     .then((value) => print('Done'));
    //
    // //Obtain the URL of the uploaded picture
    // String fileURL = await storage.downloadURL(fileName, "user_pfp");
    // final updateUserMap = {'picture': fileURL};
    //
    // // Update the users picture attribute to be the url of the chosen picture
    // _firebaseApi.updateDocumentByIdFromCollection(
    //     "users", _userModel.id, updateUserMap);

    //Setting the state to update profile picture displayed
    Future.delayed(Duration(milliseconds: 1000)).then((value) async {
      await _auth.getUserFromId(_userModel.id).then((value) {
        _userModel = UserModel.fromSnapshot(value);
        setState(() {

        });
      });
    });
  }

  void _reload() {
    _isLoaded = false;
    setState(() {

    });
    _init();
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
                    child: topBar("my account", height, width,
                        'assets/img/account-top.svg'),
                  ),
                  SizedBox(height: 35),
                  _showPFP(width),
                  _displayName(width),
                  Container(
                      width: double.infinity,
                      child: FittedBox(
                          fit: BoxFit.fill,
                          child: SvgPicture.asset('assets/img/account-mid.svg',
                              width: width, height: width / 375 * 148))),
                  Container(
                      padding: EdgeInsets.all(10),
                      child: textMajor("account settings", Colors.black, 30)),
                  _changePFP(width),
                  _changeUsername(width),
                  _changePassword(width),
                  _manageInterests(width),
                  _signOut(width),
                  Container(height: 20), //Space for the nav bar to scroll
                ],
              ))),
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
