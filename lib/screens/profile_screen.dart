import 'package:ecoflow_v3/services/authentication_service.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProfileScreen'),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: (() {
              AuthService.signOut();
            }),
            child: const Text('Logout')),
      ),
    );
  }
}
