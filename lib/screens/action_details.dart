import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActionDetails extends StatefulWidget {
  const ActionDetails({
    Key? key,
    required this.title,
    required this.description,
    required this.imageUrl,
  }) : super(key: key);

  final String title;
  final String description;
  final String imageUrl;

  @override
  _ActionDetailsState createState() => _ActionDetailsState();
}

class _ActionDetailsState extends State<ActionDetails> {
  Color buttonColor = Colors.green;
  String buttonText = 'Take Action';
  String actionId = '';
  CollectionReference<Map<String, dynamic>> actions =
      FirebaseFirestore.instance.collection('actions');
  late SharedPreferences prefs;

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    actionId = prefs.getString('actionId') ?? '';
  }

  Future<void> addAction() async {
    QuerySnapshot snapshot =
        await actions.where('title', isEqualTo: widget.title).get();

    if (snapshot.docs.length > 0) {
      setState(() {
        actionId = snapshot.docs[0].id;
      });
      await prefs.setString('actionId', actionId);

      String userId = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'actions': FieldValue.arrayUnion([actionId])
      });
    }
  }

  Future<void> updateButton() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    List<dynamic> actions = userSnapshot.data()!['actions'];

    if (actionId.isNotEmpty && actions.contains(actionId)) {
      print('Action Taken');
      setState(() {
        buttonColor = Colors.grey;
        buttonText = 'Action Taken';
      });
    } else {
      print('Take Action');
      setState(() {
        buttonColor = Colors.green;
        buttonText = 'Take Action';
      });
    }
  }

  Future<void> removeAction() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'actions': FieldValue.arrayRemove([actionId])
    });
  }

  String convertNewLine(String content) {
    return content.replaceAll(r'\n', '\n');
  }

  @override
  void initState() {
    super.initState();
    initPrefs().then((_) {
      updateButton();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ActionDetails'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: widget.title,
                    child: Container(
                      height: 400,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(widget.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      convertNewLine(widget.description),
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.symmetric(vertical: 10),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),
                onPressed: () async {
                  if (buttonColor == Colors.grey) {
                    await removeAction();
                  } else {
                    await addAction();
                  }

                  // Call updateButton again to update the button color and text
                  await updateButton();
                },
                child: Text(
                  buttonText,
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
