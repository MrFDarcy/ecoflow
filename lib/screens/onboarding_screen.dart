import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OnboardingScreen'),
      ),
      body: const Center(
        child: Text('OnboardingScreen'),
      ),
    );
  }
}
