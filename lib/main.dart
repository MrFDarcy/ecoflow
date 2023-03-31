import 'package:dynamic_color/dynamic_color.dart';
import 'package:Ecoflow/screens/onb_redirect.dart';
import 'package:Ecoflow/utils/app_routes.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return FutureBuilder(

          // Initialize FlutterFire:
          future: _initialization,
          builder: (context, snapshot) {
            // Check for errors

            if (snapshot.hasError) {
              print(snapshot.error.toString());
              return const MaterialApp(
                home: Scaffold(
                  body: Center(
                    child: Text('Error'),
                  ),
                ),
              );
            }

            // Once complete, show your application
            if (snapshot.connectionState == ConnectionState.done) {
              return MaterialApp(
                title: 'Flutter Demo',
                theme: ThemeData(
                  useMaterial3: true,
                  primaryColor: Colors.green,
                  colorScheme: ColorScheme.fromSwatch(
                    primarySwatch: Colors.green,
                  ),
                  pageTransitionsTheme: const PageTransitionsTheme(
                    builders: {
                      TargetPlatform.android:
                          const CupertinoPageTransitionsBuilder(),
                      TargetPlatform.iOS:
                          const CupertinoPageTransitionsBuilder(),
                    },
                  ),
                ),

                themeMode: ThemeMode.light,

                darkTheme: ThemeData(
                  brightness: Brightness.dark,
                  primaryColor: Colors.green,
                  colorScheme: ColorScheme.fromSwatch(
                    primarySwatch: Colors.green,
                    brightness: Brightness
                        .dark, // Add this line to match ThemeData brightness
                  ),
                  useMaterial3: true,
                  pageTransitionsTheme: const PageTransitionsTheme(
                    builders: {
                      TargetPlatform.android:
                          const CupertinoPageTransitionsBuilder(),
                      TargetPlatform.iOS:
                          const CupertinoPageTransitionsBuilder(),
                    },
                  ),
                ),

                routes: appRoutes,
                // initialRoute: '/'
                home: const OnboardingRedirect(),
              );
            }

            // Otherwise, show something whilst waiting for initialization to complete
            return const MaterialApp(
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          });
    });
  }
}
