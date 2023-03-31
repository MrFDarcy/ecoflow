import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    Key? key,
    required this.color,
    required this.text,
    required this.icon,
    required this.loginMethod,
    required this.outline,
    required this.textColour,
  }) : super(key: key);

  final Color color;
  final String text;
  final IconData icon;
  final Function() loginMethod;
  final Color outline;
  final Color textColour;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(
          icon,
          color: textColour,
          size: 20,
        ),
        style: ElevatedButton.styleFrom(
          // set outline to border color

          backgroundColor: color,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          textStyle: const TextStyle(fontSize: 20),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: outline, width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        label: Text(
          text,
          style: TextStyle(color: textColour),
        ),
        onPressed: loginMethod,
      ),
    );
  }
}
