import 'package:ecoflow_v3/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/login_buttons.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/ecoflow_logo.png',
              height: 200,
            ),
            SizedBox(height: 24),
            Text(
              'Welcome to Ecoflow!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 48),
            LoginButton(
              color: Colors.green.shade800,
              text: 'Continue with Google',
              icon: FontAwesomeIcons.google,
              loginMethod: () {
                AuthService.googleLogin();
              },
            ),
            SizedBox(height: 50),
            LoginButton(
              color: Colors.green.shade300,
              text: 'Continue as Guest',
              icon: FontAwesomeIcons.userSecret,
              loginMethod: () {
                AuthService.anonLogin();
              },
            ),
          ],
        ),
      ),
    );
  }
}
