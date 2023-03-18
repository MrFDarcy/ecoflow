import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required this.color,
    required this.text,
    required this.icon,
    required this.loginMethod,
  });

  final Color color;
  final String text;
  final IconData icon;
  final Function loginMethod;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 10),
        child: ElevatedButton.icon(
          icon: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
          style: TextButton.styleFrom(
            backgroundColor: color,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
          label: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          onPressed: () {
            loginMethod();
          },
        ));
  }
}
