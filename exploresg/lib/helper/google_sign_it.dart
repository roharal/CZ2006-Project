import 'package:exploresg/helper/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;
  UserCredential? userCredential;

  Future<User?> googleLogin({required BuildContext context}) async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return null;

    _user = googleUser;
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try {
      userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == "account-exists-with-different-credential") {
        showAlert(
            context, "Account exists with different credential", e.toString());
      } else if (e.code == "invalid-credential") {
        showAlert(context, "Invalid credential", e.toString());
      }
    } catch (e) {
      showAlert(context, "Google Sign in", e.toString());
    }
    if (userCredential!.user != null) {
      return userCredential!.user;
    } else {
      return null;
    }
  }

  Future googleSignOut() async {
    await googleSignIn.signOut();
  }
}
