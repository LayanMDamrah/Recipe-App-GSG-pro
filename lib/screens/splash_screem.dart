import 'package:flutter/material.dart';
import 'package:recipe_gsg/services/shared_prefs.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateNext();
  }

  void _navigateNext() async {
    await Future.delayed(const Duration(seconds: 3));
    final bool seenOnboarding = await SharedPrefs.isOnboardingCompleted();
    final bool loggedIn = await SharedPrefs.isLoggedIn();

    if (!seenOnboarding) {
      Navigator.pushReplacementNamed(context, '/onboarding');
    } else if (!loggedIn) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset('assets/img/public/Logo.png')),
    );
  }
}
