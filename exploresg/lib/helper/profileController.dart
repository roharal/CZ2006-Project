import 'package:exploresg/helper/authController.dart';
import 'package:exploresg/helper/firebase_api.dart';
import 'package:exploresg/helper/utils.dart';
import 'package:exploresg/models/user.dart';
import 'package:exploresg/screens/login.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:exploresg/helper/storage_service.dart';
import 'package:exploresg/screens/changePassword.dart';

class ProfileController {

  final Storage storage = Storage();
  FirebaseApi _firebaseApi = FirebaseApi();

  Future<FilePickerResult?> getFile() async {
    FilePickerResult? r = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg']);
    return r;
  }

  Future uploadFileAndUpdateUser(FilePickerResult results, UserModel _userModel) async{
    // Setting file name and details etc
    final path = results.files.single.path!;
    final fileName = _userModel.id + "_pfp";

    print(path);
    print(fileName);
    // Uploading the file to firebase here
    storage
        .uploadFile(path, fileName, "user_pfp")
        .then((value) => print('Done'));

    //Obtain the URL of the uploaded picture
    String fileURL = await storage.downloadURL(fileName, "user_pfp");
    final updateUserMap = {'picture': fileURL};

    // Update the users picture attribute to be the url of the chosen picture
    _firebaseApi.updateDocumentByIdFromCollection(
        "users", _userModel.id, updateUserMap);
  }
}
