import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      print('User signed in: ${googleUser?.displayName}');

      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      final user = FirebaseAuth.instance.currentUser;

      if (user != null && !user.isAnonymous) {
        // Create a document for the user in the "users" collection
        FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': user.displayName,
          'email': user.email,
          'userPhoto': user.photoURL,
          // Add any other user data you want to store
        });
      }
    } on FirebaseAuthException catch (e) {
      // Handle login error
    }
  }
}
