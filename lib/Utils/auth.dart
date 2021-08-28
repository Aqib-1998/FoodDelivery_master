import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
final _auth = FirebaseAuth.instance;
final firestore = FirebaseFirestore.instance;

bool newGoogleUser;

class GiveUser {
  GiveUser({@required this.uid});
  final String uid;
}

abstract class AuthBase {
  Stream<GiveUser> get onAuthStateChanged;
  Future<GiveUser> currentUser();
  Future<GiveUser> signInWithGoogle();
  Future<void> signOut();

}

class Auth implements AuthBase {
  GiveUser _userFromFirebase(User user) {
    if (user == null) {
      return null;
    }
    return GiveUser(uid: user.uid);
  }
  @override
  Stream<GiveUser> get onAuthStateChanged {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  @override
  Future<GiveUser> currentUser() async {
    final user = _auth.currentUser;
    return _userFromFirebase(user);
  }

  @override
  Future<GiveUser> signInWithGoogle() async {

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
        var status = await OneSignal.shared.getPermissionSubscriptionState();
        String tokenId = status.subscriptionStatus.userId;
        //to check new user
       if(authResult.additionalUserInfo.isNewUser){
         firestore.collection("Shop Users").doc(_auth.currentUser.uid).set({
           'New user?' : authResult.additionalUserInfo.isNewUser,
           'Account Type?': "Google",
           'Username': authResult.user.displayName
         });
       }
       if(!authResult.additionalUserInfo.isNewUser){
         firestore.collection("Shop Users").doc(_auth.currentUser.uid).update({
           'New user?' : authResult.additionalUserInfo.isNewUser,
           'Account Type?': "Google",
           'Username': authResult.user.displayName,
           'token Id': tokenId
         });
       }


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
