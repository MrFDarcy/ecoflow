import 'package:Ecoflow/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/login_buttons.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff0c7e6b),
              Color(0xff8fc95d),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo_clean.png',
              height: 200,
            ),
            const SizedBox(height: 24),
            const Text(
              'Welcome to Ecoflow!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 48),
            LoginButton(
              color: Colors.white,
              outline: Colors.white,
              textColour: Colors.black,
              text: 'Continue with Google',
              icon: FontAwesomeIcons.google,
              loginMethod: () {
                AuthService.googleLogin();
              },
            ),
            const SizedBox(height: 50),
            LoginButton(
              textColour: Colors.white,
              color: Colors.transparent,
              outline: Colors.white,
              text: 'Continue without Signing In',
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
