import 'package:ecoflow_v3/services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ecoflow_v3/services/points.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final isAnonymous = user.isAnonymous;

    Future<String> getPointsString() async {
      int points = await Points().getPoints();
      return points.toString();
    }

    FutureBuilder<String> points = FutureBuilder<String>(
      future: getPointsString(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(
            snapshot.data!,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          );
        } else {
          return const Text('Loading...');
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('ProfileScreen'),
      ),
      body: isAnonymous
          ? anonymousUserDetails(context)
          : userDetails(user, points, context),
    );
  }

  Widget loginDialogue(context) {
    return AlertDialog(
      title: const Text('Log Out'),
      content: const Text('Do you want to log out?'),
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
          child: const Text('Log Out'),
        ),
      ],
    );
  }

  Widget userDetails(user, points, context) {
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
          const SizedBox(height: 5),
          Text(
            user.email!,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 70),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FaIcon(
                FontAwesomeIcons.solidStar,
                color: Colors.yellow,
              ),
              const SizedBox(width: 10),
              points,
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/useractions',
                  );
                },
                child: Container(
                  height: 200,
                  width: 200,
                  child: Card(
                      // set the color of the Card
                      color: Colors.blue,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const SizedBox(height: 20),
                          const FaIcon(
                            size: 60,
                            FontAwesomeIcons.lightbulb,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'My Actions',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      )),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/userbadges',
                  );
                },
                child: Container(
                  height: 200,
                  width: 200,
                  child: Card(
                      // set the color of the Card
                      color: Colors.teal,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const SizedBox(height: 20),
                          const FaIcon(
                            size: 60,
                            FontAwesomeIcons.award,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'My Badges',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      )),
                ),
              ),
            ],
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return loginDialogue(context);
                  },
                );
              },
              child: const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Logout button
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
