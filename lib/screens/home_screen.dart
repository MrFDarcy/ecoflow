import 'package:flutter/material.dart';

import '../services/authentication_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeScreen'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // check if AuthService().user is not null and isAnonymous is true
          if (AuthService().user != null &&
              AuthService().user!.isAnonymous == true) {
            // show a dialog to ask user to login
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Login'),
                  content: const Text('Please login to continue'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        AuthService.signOut();
                      },
                      child: const Text('Login'),
                    ),
                  ],
                );
              },
            );
          }

          // if user is logged in with google, navigate to post upload screen
          else {
            Navigator.of(context).pushNamed('/postupload');
          }
        },
        child: const Icon(Icons.add),
      ),
      body: const Center(
        child: Text('HomeScreen'),
      ),
    );
  }
}
