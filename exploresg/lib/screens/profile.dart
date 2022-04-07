import 'package:exploresg/helper/authController.dart';
import 'package:exploresg/helper/firebase_api.dart';
import 'package:exploresg/helper/utils.dart';
import 'package:exploresg/models/user.dart';
import 'package:exploresg/screens/login.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:exploresg/helper/storage_service.dart';
import 'package:exploresg/screens/changePassword.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfileScreen();
  }
}

class _ProfileScreen extends State<ProfileScreen> {
  var value = "";
  final Storage storage = Storage();
  var displayName = "<Display Name>";
  var emailAddress = "<EmailAddress@email.com>";
  bool _isLoaded = false;
  FirebaseApi _firebaseApi = FirebaseApi();
  AuthController _auth = AuthController();
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
                  Future.delayed(Duration(milliseconds: 100), () {
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
        final results = await FilePicker.platform.pickFiles(
            allowMultiple: false,
            type: FileType.custom,
            allowedExtensions: ['png', 'jpg']);
        if (results == null) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('No file selected'),
          ));
          return null;
        }
        final path = results.files.single.path!;
        final fileName = _userModel.username + "_pfp";
        final updateUserMap = {'picture': fileName};

        print(path);
        print(fileName);

        storage
            .uploadFile(path, fileName, "user_pfp")
            .then((value) => print('Done'));
        _firebaseApi.updateDocumentByIdFromCollection(
            "users", _userModel.id, updateUserMap);
        Future.delayed(Duration(milliseconds: 100), () {
          setState(() {
            _userModel.picture = fileName;
          });
        });
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
                  FutureBuilder(
                    future: _userModel.picture == "" ? storage.downloadURL("user.png", "adminAssets"):storage.downloadURL(_userModel.picture, "user_pfp"),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      print("Hello" + snapshot.data.toString());
                      print(_userModel.picture);
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
                  ),
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
                  Row(children: [
                    Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        width: width * (3 / 4),
                        // color: Colors.red,
                        alignment: Alignment.centerLeft,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("email address",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: "AvenirLtStd",
                                    fontWeight: FontWeight.bold,
                                  )),
                              textMinor(_userModel.email, Colors.black)
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
                              await showInformationDialog(context, "email");
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.grey),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                )))))
                  ]),
                  Row(children: [
                    Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        width: width * (3 / 4),
                        // color: Colors.red,
                        alignment: Alignment.centerLeft,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.grey),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                )))))
                  ]),
                  Row(children: [
                    Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        width: width * (3 / 4),
                        // color: Colors.red,
                        alignment: Alignment.centerLeft,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.grey),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                )))))
                  ]),
                  Row(children: [
                    Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        width: width * (3 / 4),
                        // color: Colors.red,
                        alignment: Alignment.centerLeft,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Sign out from account",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: "AvenirLtStd",
                                    fontWeight: FontWeight.bold,
                                  ))
                            ])),
                    Container(
                        child: ElevatedButton(
                            child: Text("signou",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: "AvenirLtStd",
                                  fontWeight: FontWeight.bold,
                                )),
                            onPressed: () {
                              _auth.logOut();
                              Navigator.of(context, rootNavigator: true)
                                  .pushNamedAndRemoveUntil(
                                      LoginScreen.routeName,
                                      (Route<dynamic> route) => false);
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.grey),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                )))))
                  ]),
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
