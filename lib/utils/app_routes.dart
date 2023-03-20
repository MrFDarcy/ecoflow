import 'package:ecoflow_v3/screens/login_redirect.dart';
import 'package:ecoflow_v3/screens/post_detail.dart';
import 'package:flutter/material.dart';

import '../screens/action_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/metrics_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/post_upload_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/resources_screen.dart';

var appRoutes = {
  // '/': (context) => const LoginRedirect(),
  '/onboarding': (context) => const OnboardingScreen(),

  '/login': (context) => const LoginScreen(),

  '/home': (context) => const HomeScreen(),

  '/postdetail': (context) => PostDetailsScreen(),

  '/postupload': (context) => const PostUploadScreen(),
  '/resource': (context) => const ResourcesScreen(),
  '/action': (context) => const ActionScreen(),
  '/metrics': (context) => const MetricsScreen(),
  '/profile': (context) => const ProfileScreen(),
};
