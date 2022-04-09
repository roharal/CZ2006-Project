import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exploresg/helper/authController.dart';
import 'package:exploresg/helper/firebase_api.dart';
import 'package:exploresg/helper/utils.dart';
import 'package:exploresg/models/user.dart';
import 'package:exploresg/screens/login.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:exploresg/helper/storage_service.dart';
import 'package:exploresg/screens/changePassword.dart';
import 'package:exploresg/helper/profileController.dart';

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
  FirebaseApi _firebaseApi = FirebaseApi();
  AuthController _auth = AuthController();
  ProfileController _profileController = ProfileController();
  late UserModel _userModel;
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    String uid = _auth.getCurrentUser()!.uid;
    _firebaseApi.getDocumentByIdFromCollection("users", uid).then((value) {
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
                  _firebaseApi.updateDocumentByIdFromCollection("users",
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
    if (_userModel.picture == "") {
      // If user does not have pfp
      return Container(child: Image.asset("assets/img/Profile picture.png"));
    } else {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        width: width * 1 / 3,
        height: width * 1 / 3,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: FittedBox(
              child: Image(
                image: NetworkImage(_userModel.picture),
              ),
              fit: BoxFit.cover),
        ),
      );
    }
  }

  Widget _showPFPOLD(width) {
    return FutureBuilder(
      // check if user.picture attribute is blank (First time user)
      future: _userModel.picture == ""
          ? storage.downloadURL("user.png", "adminAssets")
          : storage.downloadURL(_userModel.picture, "user_pfp"),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        print("Hello" + snapshot.data.toString());
        print(_userModel.picture);
        // If image isnt there for some reason
        if (snapshot.data.toString() == "oops") {
          return Column(
            children: [
              Container(
                  width: 0.3 * width,
                  child: Image(
                      image: AssetImage("assets/img/close.png"),
                      fit: BoxFit.fitWidth)),
              Text("Error, image not found",
                  style: TextStyle(
                      fontSize: 10,
                      fontFamily: "AvenirLtStd",
                      fontWeight: FontWeight.normal)),
            ],
          );
        }
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            width: width * 1 / 3,
            height: width * 1 / 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(
                snapshot.data!,
                fit: BoxFit.cover,
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return CircularProgressIndicator();
        }
        return Container();
      },
    );
  }

  Widget _changeUsername() {
    return ElevatedButton(
        child: Text("Change username"),
        onPressed: () async {
          await showInformationDialog(context, "username");
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.grey),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ))));
  }

  Widget _changePFP() {
    return ElevatedButton(
      onPressed: () async {
        _changePFPFunc();
      },
      child: Text("Change profile picture"),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.grey),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ))),
    );
  }

  Widget _changePassword(width) {
    return Row(children: [
      Container(
          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
          width: width * (3 / 4),
          // color: Colors.red,
          alignment: Alignment.centerLeft,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("password",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: "AvenirLtStd",
                  fontWeight: FontWeight.bold,
                )),
            Text("must be between 8-20 characters",
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: "AvenirLtStd",
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
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ChangePasswordScreen(),
                ));
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.grey),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  )))))
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
              onPressed: null,
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.grey),
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
            Text("Sign out from account",
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
                  backgroundColor: MaterialStateProperty.all(Colors.grey),
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
    if (results == null) { // If user did not pick a file (Pressed back)
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
    DocumentSnapshot snapShot = await _firebaseApi.getDocumentByIdFromCollection("users", _userModel.id);
    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        _userModel = UserModel.fromSnapshot(snapShot);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return _isLoaded
        ? Scaffold(
            backgroundColor: createMaterialColor(Color(0xfffffcec)),
            body: Container(
              child: SingleChildScrollView(
                  child: Container(
                      child: Column(
                children: [
                  topBar(
                      "my account", height, width, 'assets/img/accountTop.png'),
                  _showPFP(width),
                  Text("@" + _userModel.username,
                      style:
                          TextStyle(fontSize: 20, fontFamily: "AvenirLtStd")),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _changeUsername(),
                      _changePFP(),
                    ],
                  ),

                  Container(
                      width: double.infinity,
                      child: Image(
                          image: AssetImage("assets/img/stringAccent.png"),
                          fit: BoxFit.fitWidth)),
                  Container(
                      padding: EdgeInsets.all(5),
                      child: Text("Account settings",
                          style: TextStyle(
                              fontSize: 25,
                              fontFamily: "AvenirLtStd",
                              fontWeight: FontWeight.bold))),
                  _changePassword(width),
                  _manageInterests(width),
                  _signOut(width),
                  Container(height: 20), //Space for the nav bar to scroll
                ],
              ))),
            ),
          )
        : Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
