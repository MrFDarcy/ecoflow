import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushReplacementNamed('/loginredirect');
        },
        child: const Icon(Icons.arrow_forward),
      ),
      body: // create a onboading screen with pageview with buttons at bottom for skip and next

          PageView(
        children: [
          Container(
            child: Image.asset('assets/images/onb0.png',
                fit: BoxFit.cover, width: double.infinity),
          ),
          Container(
            child: Image.asset('assets/images/onb1.png',
                fit: BoxFit.cover, width: double.infinity),
          ),
          Container(
            child: Image.asset('assets/images/onb2.png',
                fit: BoxFit.cover, width: double.infinity),
          ),
          Container(
            child: Image.asset('assets/images/onb3.png',
                fit: BoxFit.cover, width: double.infinity),
          ),
          Container(
            child: Image.asset('assets/images/onb4.png',
                fit: BoxFit.cover, width: double.infinity),
          ),
          Container(
            child: Image.asset('assets/images/onb5.png',
                fit: BoxFit.cover, width: double.infinity),
          )
        ],
      ),
    );
  }
}
