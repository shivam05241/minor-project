import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:music_recommender/constants.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  bool _isSigningIn;

  GoogleSignInProvider() {
    _isSigningIn = false;
  }
  bool get isSigningIn => _isSigningIn;

  set isSigningIn(bool isSigningIn) {
    _isSigningIn = isSigningIn;
    notifyListeners();
  }

  Future<bool> login() async {
    //isSigningIn = true;
    try {
      final user = await googleSignIn.signIn();
      if (user == null) {
        print("--------------------null user------------------");
        //isSigningIn = false;
        return false;
        // showDialog(context: , builder: (context)=>CupertinoAlertDialog(title: Text('New User ?'),content: Text("welcome"),),);
      } else {
        print("--------------------not null user------------------");
        final googleAuth = await user.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
        isSigningIn = false;
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  void logOut() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
    await googleSignIn.signOut();
  }
}
