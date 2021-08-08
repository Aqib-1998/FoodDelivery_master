import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
final _auth = FirebaseAuth.instance;
final firestore = FirebaseFirestore.instance;
// ignore: camel_case_types
bool newGoogleUser;

class giveUser {
  giveUser({@required this.uid});
  final String uid;
}

abstract class AuthBase {
  Stream<giveUser> get onAuthStateChanged;
  Future<giveUser> currentUser();
  Future<giveUser> signInWithGoogle();
  Future<void> signOut();

}

class Auth implements AuthBase {
  giveUser _userFromFirebase(User user) {
    if (user == null) {
      return null;
    }
    return giveUser(uid: user.uid);
  }
  @override
  Stream<giveUser> get onAuthStateChanged {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  @override
  Future<giveUser> currentUser() async {
    final user = _auth.currentUser;
    return _userFromFirebase(user);
  }

  @override
  Future<giveUser> signInWithGoogle() async {

    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final authResult = await _auth.signInWithCredential(
          GoogleAuthProvider.credential(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken,
          ),
        );
        //to check new user
        firestore.collection("Shop Users").doc(_auth.currentUser.uid).set({
          'New user?' : authResult.additionalUserInfo.isNewUser,
        });

        print("New user = ${authResult.additionalUserInfo.isNewUser}");
        return _userFromFirebase(authResult.user);

      } else {

        throw PlatformException(
          code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
          message: 'Missing Google Auth Token',
        );
      }
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }


  @override
  Future<void> signOut() async {
    await _auth.signOut();
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }

  Future<UserCredential> signInWithCredential(AuthCredential credential) => _auth.signInWithCredential(credential);
  Future<void> logout() => _auth.signOut();
}
