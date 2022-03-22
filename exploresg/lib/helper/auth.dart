import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth auth = FirebaseAuth.instance;

  User? getCurrentUser() {
    return auth.currentUser;
  }

  Future<void> logOut() {
    return auth.signOut();
  }

  Future<User> signInEmail(String email, String password) async {
    UserCredential result = await auth.signInWithEmailAndPassword(email: email, password: password);
    final User user = result.user!;
    return user;
  }

  Future<User> signUpEmail(email, password) async {
    UserCredential result = await auth.createUserWithEmailAndPassword(email: email, password: password);
    final User user = result.user!;
    return user;
  }

}