import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InterestController{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void updateUserInterests(Map interestsMap, String userID) async {
    String finalString ="";
    interestsMap.forEach((key, value) {
      if(value == true){
        finalString = finalString + key + ",";
      }
    });
    finalString = finalString.substring(0,finalString.length-1);
    await _firestore.collection("users").doc(userID).update({"interest":finalString});

    var userInterests = await _firestore.collection("users").doc(userID).get();

    Map<String, dynamic> data = userInterests.data()!;
    print("The updated data is" + data.toString());
  }
}