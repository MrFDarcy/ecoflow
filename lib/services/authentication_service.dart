import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final userStream = FirebaseAuth.instance.authStateChanges();

  final user = FirebaseAuth.instance.currentUser;

  final FirebaseAuth auth = FirebaseAuth.instance;

  static Future<void> anonLogin() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } on FirebaseAuthException catch (e) {}
  }

  static Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e) {}
  }

  static Future<void> googleLogin() async {
    try {
      // final googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      print('User signed in: ${googleUser?.displayName}');

      // if (googleUser != null) return;

      final googleAuth = await googleUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      final user = FirebaseAuth.instance.currentUser;
    } on FirebaseAuthException catch (e) {}
  }
}
