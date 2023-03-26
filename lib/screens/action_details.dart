import 'package:flutter/material.dart';

class ActionDetails extends StatefulWidget {
  const ActionDetails({super.key});

  @override
  State<ActionDetails> createState() => _ActionDetailsState();
}

class _ActionDetailsState extends State<ActionDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ActionDetails'),
      ),
      body: const Center(
        child: Text('ActionDetails'),
      ),
    );
  }
}
