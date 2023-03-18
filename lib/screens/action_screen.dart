import 'package:flutter/material.dart';

class ActionScreen extends StatelessWidget {
  const ActionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Action Screen'),
      ),
      body: const Center(
        child: Text('Action Screen'),
      ),
    );
  }
}
