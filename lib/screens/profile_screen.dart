import 'package:ecoflow_v3/services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final isAnonymous = user.isAnonymous;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ProfileScreen'),
      ),
      body: isAnonymous ? anonymousUserDetails(context) : userDetails(user),
    );
  }

  Widget loginDialogue(context) {
    return AlertDialog(
      title: const Text('Login'),
      content: const Text('Do you want to login?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(
              context,
            ).pop();
            AuthService.signOut();
          },
          child: const Text('Login'),
        ),
      ],
    );
  }

  Widget userDetails(user) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 70,
            backgroundImage: NetworkImage(user.photoURL!),
          ),
          const SizedBox(height: 20),
          Text(
            user.displayName!,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget anonymousUserDetails(context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'This action requires authentication. Please log in with google',
            style: TextStyle(
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return loginDialogue(context);
                },
              );
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}
