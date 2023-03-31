import 'package:ecoflow_v3/screens/login_screen.dart';
import 'package:ecoflow_v3/services/authentication_service.dart';
import 'package:flutter/material.dart';

import '../widgets/navbar_widget.dart';

class LoginRedirect extends StatelessWidget {
  const LoginRedirect({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: AuthService().userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return const Scaffold(
              body: Center(
                child: Text('Error'),
              ),
            );
          } else if (snapshot.hasData) {
            return const BottomNavBar();
          } else {
            return const LoginScreen();
          }
        });
  }
}
