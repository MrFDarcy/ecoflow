import 'package:ecoflow_v3/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/login_buttons.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('LoginScreen'),
        ),
        body: Container(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const FlutterLogo(
                  size: 150,
                ),
                Flexible(
                  child: LoginButton(
                    color: Colors.red,
                    text: 'Login with Google',
                    icon: FontAwesomeIcons.google,
                    loginMethod: () {
                      AuthService.googleLogin();
                    },
                  ),
                ),
                Flexible(
                  child: LoginButton(
                    color: Colors.black,
                    text: 'Login as Guest',
                    icon: FontAwesomeIcons.userSecret,
                    loginMethod: () {
                      AuthService.anonLogin();
                    },
                  ),
                ),
              ],
            )));
  }
}
