import 'package:exploresg/helper/auth_controller.dart';

class InterestController {
  AuthController _authController = AuthController();

  void updateUserInterests(Map interestsMap, String userID) async {
    String finalString = '';
    interestsMap.forEach((key, value) {
      if (value == true) {
        finalString = finalString + key + ',';
      }
    });
    print('The final string is here ' + finalString);
    if (finalString != '') {
      // String is not empty
      finalString = finalString.substring(0, finalString.length - 1);
      print('Interests are not empty');
    }
    await _authController.updateUserById(userID, {'interest': finalString});
  }
}
