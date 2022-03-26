import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth auth = FirebaseAuth.instance;

  User? getCurrentUser() {
    return auth.currentUser;
  }

  Future<void> logOut() {
    return auth.signOut();
  }

  Future signInEmail(String email, String password) async {
    try {
      UserCredential result = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      final User user = result.user!;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future signUpEmail(email, password) async {
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final User user = result.user!;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
