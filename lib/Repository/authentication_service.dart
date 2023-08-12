import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/foundation.dart';
import 'package:nuduwa_flutter/models/user.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService {
  firebase.FirebaseAuth auth = firebase.FirebaseAuth.instance;

  Stream<User> retrieveCurrentUser() {
    return auth.authStateChanges().map((firebase.User? user) {
      if (user != null) {
        return User(id: user.uid, name: user.displayName, email: user.email);
      } else {
        return  User(id: "uid", name: 'non');
      }
    });
  }
  Future<firebase.UserCredential?> signInWithGoogle() async {
    try {
      late firebase.UserCredential userCredential;
      if (kIsWeb) {
        // Create a new provider
        firebase.GoogleAuthProvider googleProvider = firebase.GoogleAuthProvider();

        googleProvider
            .addScope('https://www.googleapis.com/auth/contacts.readonly');
        googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

        // Once signed in, return the UserCredential
        userCredential =
            await auth.signInWithPopup(googleProvider);

        // Or use signInWithRedirect
        // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
      } else if (Platform.isAndroid || Platform.isIOS) {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;

        final credential = firebase.GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        userCredential =
            await auth.signInWithCredential(credential);
      } else {
        debugPrint('에러!! 지원하지 않는 플랫폼입니다');
        return null;
      }

      return userCredential;
      // final user = userCredential.user;

      // if (user == null) return;

      // final currentUser = await usermodel.UserRepository.read(user.uid);
      // if (currentUser == null) {
      //   await _registerUser(user);
      // }
    } catch (e) {
      debugPrint("에러!! 로그인에러: ${e.toString()}");
      rethrow;
    }
  }
/*
  Future<firebase.UserCredential?> signUp(User user) async {
    try {
      firebase.UserCredential userCredential = await firebase.FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: user.email!,password: user.password!);
          verifyEmail();
      return userCredential;
    } on firebase.FirebaseAuthException catch (e) {
      throw firebase.FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  Future<firebase.UserCredential?> signIn(User user) async {
    try {
      firebase.UserCredential userCredential = await firebase.FirebaseAuth.instance
          .signInWithEmailAndPassword(email: user.email!, password: user.password!);
      return userCredential;
    } on firebase.FirebaseAuthException catch (e) {
      throw firebase.FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  Future<void> verifyEmail() async {
    firebase.User? user = firebase.FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      return await user.sendEmailVerification();
    }
  }
*/
  Future<void> signOut() async {
    await Future.wait([
      auth.signOut(),
      GoogleSignIn().signOut(),
    ]);
  }
}