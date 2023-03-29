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
      subtitle: 'Discover how to live sustainably',
      imageAsset: 'assets/images/ecoflow_logo.png',
    ),
    OnboardingPage(
      title: 'Reduce your carbon footprint',
      subtitle: 'Learn how to lower your carbon emissions',
      imageAsset: 'assets/images/onb2.png',
    ),
    OnboardingPage(
      title: 'Track your progress',
      subtitle: 'Monitor your impact on the environment',
      imageAsset: 'assets/images/onb3.png',
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
        color: isActive ? Colors.blue : Colors.grey,
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
          const SizedBox(height: 32.0),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
