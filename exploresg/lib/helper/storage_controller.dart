import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class Storage {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> uploadFile(
      String filePath, String fileName, String folder) async {
    File file = File(filePath);

    try {
      await storage.ref('$folder/$fileName').putFile(file);
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future<ListResult> listFiles() async {
    ListResult results = await storage.ref('test').listAll();

    results.items.forEach((Reference ref) {
      print('Found file: $ref');
    });

    return results;
  }

  Future<String> downloadURL(String imageName, String folder) async {
    print('Getting download url');
    var temp = await storage.ref('$folder/$imageName');
    print('temp is ' + temp.toString());
    String downloadURL = '';
    try {
      downloadURL = await temp.getDownloadURL();
      print('the download url is ' + downloadURL.toString());
    } catch (e) {
      print('the error is ' + e.toString());
      print('Returning ooooops');
      return 'oops';
    }

    return downloadURL;
  }
}
