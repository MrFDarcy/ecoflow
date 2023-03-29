import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    Key? key,
    required this.color,
    required this.text,
    required this.icon,
    required this.loginMethod,
  }) : super(key: key);

  final Color color;
  final String text;
  final IconData icon;
  final Function() loginMethod;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          textStyle: TextStyle(fontSize: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        label: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
        onPressed: loginMethod,
      ),
    );
  }
}
