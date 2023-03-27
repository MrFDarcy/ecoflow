import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResourcesDetails extends StatefulWidget {
  const ResourcesDetails(
      {super.key,
      required this.title,
      required this.description,
      required this.imageUrl});

  final String title;
  final String description;
  final String imageUrl;

  @override
  _ResourcesDetailsState createState() => _ResourcesDetailsState();
}

class _ResourcesDetailsState extends State<ResourcesDetails> {
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5)).then((value) {
      _addResourceToUser();
    });
  }

  String convertNewLine(String content) {
    return content.replaceAll(r'\n', '\n');
  }

  void _addResourceToUser() async {
    // Fetch the resource document based on the title
    final resourceDoc = await FirebaseFirestore.instance
        .collection('resources')
        .where('title', isEqualTo: widget.title)
        .get();

    // Get the user id
    final userId = FirebaseAuth.instance.currentUser!.uid;

    // Fetch the user document
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    // Check if the resource id is already in the user's resources array
    if (userDoc.exists &&
        userDoc.data() != null &&
        userDoc.data()!['resources'] != null &&
        userDoc.data()!['resources'].contains(resourceDoc.docs.first.id)) {
      // Resource already added to user's collection

    } else {
      // Add the resource id to the user's resources array
      FirebaseFirestore.instance.collection('users').doc(userId).update({
        'resources': FieldValue.arrayUnion([resourceDoc.docs.first.id]),
      });
      // Show snackbar to notify the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You have read the resource'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Text(
                convertNewLine(widget.description),
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
