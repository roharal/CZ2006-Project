import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';

class Storage {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> uploadFile( String filePath, String fileName, String folder) async{
    File file = File(filePath);

    try{
      await storage.ref('$folder/$fileName').putFile(file);
    } on FirebaseException catch (e){
      print(e);
    }
  }
  Future<ListResult> listFiles() async {
    ListResult results = await storage.ref('test').listAll();

    results.items.forEach((Reference ref) {
      print("Found file: $ref");
    });

    return results;
  }
  Future<String> downloadURL(String imageName, String folder) async {
    var temp = await storage.ref("$folder/$imageName");
    String downloadURL = await temp.getDownloadURL();
    print(downloadURL);

    return downloadURL;
  }
}