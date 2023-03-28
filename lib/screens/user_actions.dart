import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecoflow_v3/widgets/action_card.dart';
import 'package:ecoflow_v3/services/points.dart';

class UserActions extends StatelessWidget {
  const UserActions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Actions'),
      ),
      body: Column(
        children: [
          // add the progress bar here
          progress(),
          Expanded(
            // wrap ListView.builder in Expanded to make it scrollable
            child: StreamBuilder<List<String>>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .snapshots()
                  .map((doc) => doc.data()?['actions'])
                  .where((actions) =>
                      actions != null) // Filter out null actions arrays
                  .map((actions) => actions!
                      .cast<String>()
                      .toList()), // Convert dynamic list to String list
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No actions found.');
                }

                final actionIds = snapshot.data!;

                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('actions')
                      .where(FieldPath.documentId, whereIn: actionIds)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Text('No actions found.');
                    }

                    final actionDocs = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: actionDocs.length,
                      itemBuilder: (context, index) {
                        final action =
                            actionDocs[index].data() as Map<String, dynamic>;
                        return ActionCard(
                          title: action['title'],
                          description: action['description'],
                          imageUrl: action['imageUrl'],
                          context: context,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget progress() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.green, // set appbar color to green
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 2),
            blurRadius: 2,
          ),
        ],
      ),
      child: FutureBuilder<int>(
        future: Points().getPoints(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Your Progress',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white, // set text color to white
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 15,
                        color: Colors.white,
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: snapshot.data! / 1500,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: snapshot.data! / 1500,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 15,
                          color: Colors.lightGreenAccent[
                              200], // set progress bar color to light green
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '${1500 - snapshot.data!} points to go',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white, // set text color to white
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
