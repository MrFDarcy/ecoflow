import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'action_details.dart';
import 'package:ecoflow_v3/widgets/action_card.dart';

class ActionScreen extends StatelessWidget {
  const ActionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Action Screen'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('actions').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ActionCard(
                context: context,
                title: data['title'],
                description: data['description'],
                imageUrl: data['imageUrl'],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
