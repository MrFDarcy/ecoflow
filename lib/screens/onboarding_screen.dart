import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPageIndex = 0;
  final PageController _pageController = PageController();

  List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Welcome to Ecoflow',
      subtitle: 'EcoFlow: A Social Platform for Positive Environmental Impact.',
      imageAsset: 'assets/images/ecoflow_logo.png',
    ),
    OnboardingPage(
      title: 'Upload Posts',
      subtitle: 'Share your positive impact on the environment with the world.',
      imageAsset: 'assets/images/onb1.png',
    ),
    OnboardingPage(
      title: 'Take Actions',
      subtitle: 'Take actions to protect the environment and preserve nature.',
      imageAsset: 'assets/images/onb2.png',
    ),
    OnboardingPage(
      title: 'Learning Resources',
      subtitle:
          'Learn more about environmental issues and how to make a positive impact.',
      imageAsset: 'assets/images/onb3.png',
    ),
    OnboardingPage(
      title: 'Metrics and Tracking',
      subtitle: 'Track and measure your positive impact on the environment.',
      imageAsset: 'assets/images/onb4.png',
    ),
    OnboardingPage(
      title: 'Earn Rewards',
      subtitle: 'Earn rewards for your positive environmental impact.',
      imageAsset: 'assets/images/onb5.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int index) {
              setState(() {
                _currentPageIndex = index;
              });
            },
            children: _pages,
          ),
          Positioned(
            bottom: 32.0,
            left: 16.0,
            right: 16.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed('/loginredirect');
                      },
                      child: const Text('SKIP'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        if (_currentPageIndex == _pages.length - 1) {
                          Navigator.of(context)
                              .pushReplacementNamed('/loginredirect');
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: _currentPageIndex == _pages.length - 1
                          ? const Text('GET STARTED')
                          : const Text('NEXT'),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _pages.length; i++) {
      list.add(
        i == _currentPageIndex ? _indicator(true) : _indicator(false),
      );
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return Container(
      width: isActive ? 16.0 : 8.0,
      height: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: isActive ? Colors.green : Colors.grey,
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageAsset;

  const OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFE8F5E9),
            Color(0xFFE8F5E9),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imageAsset,
            width: double.infinity,
            height: 400.0,
          ),
          const SizedBox(
            height: 32.0,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
