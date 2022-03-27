import 'package:exploresg/helper/auth.dart';
import 'package:exploresg/helper/firebase_api.dart';
import 'package:exploresg/helper/utils.dart';
import 'package:exploresg/models/user.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:exploresg/helper/storage_service.dart';

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
  Auth _auth = Auth();
  late UserModel _userModel;

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
                    future: storage.downloadURL(_userModel.picture,"user_pfp"),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
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
                  Row( mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          padding: EdgeInsets.all(5),
                          width: 200,
                          height: 40,
                          child: TextField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Enter a display name"),
                            onChanged: (value){
                              setState(() {
                                value = value;
                                print(value);
                              });
                            },
                          )),
                      ElevatedButton(
                          child: Icon(Icons.done),
                          onPressed: (){
                            if(value != ""){
                              setState(() {
                                _firebaseApi.updateDocumentByIdFromCollection("users", _userModel.id,
                                    {'name':value});
                              });
                            }
                          },
                          style: ButtonStyle(
                              backgroundColor:
                              MaterialStateProperty.all(Colors.grey),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ))))
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final results = await FilePicker.platform.pickFiles(
                          allowMultiple: false,
                          type: FileType.custom,
                          allowedExtensions: ['png', 'jpg']);
                      if (results == null) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('No file selected'),
                        ));
                        return null;
                      }
                      final path = results.files.single.path!;
                      final fileName = _userModel.username + "_pfp";
                      final updateUserMap = {'picture':fileName};

                      print(path);
                      print(fileName);

                      storage
                          .uploadFile(path, fileName,"user_pfp")
                          .then((value) => print('Done'));
                      setState(() {
                        _firebaseApi.updateDocumentByIdFromCollection("users", _userModel.id, updateUserMap);
                        _userModel.picture = fileName;
                      });

                    },
                    child: Text("Change profile picture"),
                    style:ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Colors.grey),
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ))),
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
