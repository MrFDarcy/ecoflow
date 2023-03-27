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
    initPrefs();
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
          ButtonWidget(
            title: widget.title,
            actionId: actionId,
            addAction: addAction,
            removeAction: removeAction,
          ),
        ],
      ),
    );
  }
}

class ButtonWidget extends StatefulWidget {
  const ButtonWidget({
    Key? key,
    required this.title,
    required this.actionId,
    required this.addAction,
    required this.removeAction,
  }) : super(key: key);

  final String title;
  final String actionId;
  final Function() addAction;
  final Function() removeAction;

  @override
  _ButtonWidgetState createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  late bool isActionAdded;

  @override
  void initState() {
    super.initState();
    isActionAdded = (widget.actionId.isNotEmpty);

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        isActionAdded = prefs.getBool(widget.title) ?? false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () async {
          setState(() {
            isActionAdded = !isActionAdded;
          });

          if (isActionAdded) {
            await widget.addAction();
          } else {
            await widget.removeAction();
          }

          SharedPreferences.getInstance().then((prefs) {
            prefs.setBool(widget.title, isActionAdded);
          });
        },
        child: Text(
          isActionAdded ? 'Remove from My Actions' : 'Add to My Actions',
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: isActionAdded ? Colors.red : Colors.green,
        ),
      ),
    );
  }
}
