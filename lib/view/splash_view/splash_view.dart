import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Add Firebase Auth
import 'package:welllink/utils/routes/app_routes.dart';

import '../onboarding_view/onboarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _startAnimationAndCheckAuth();
  }

  void _startAnimationAndCheckAuth() async {
    await _controller.forward(); // Play fade-in and scale-up animation
    await Future.delayed(const Duration(seconds: 1)); // Wait for a moment

    // Check if user is logged in
    User? user = FirebaseAuth.instance.currentUser;

    await _controller.reverse(); // Play fade-out and scale-down animation

    // Navigate based on authentication status
    if (user != null) {
      // User is logged in, go to home page
      Get.offAllNamed(AppRoutes.homeScreenView);
    } else {
      // User is not logged in, go to onboarding page
      Get.offAll(() => const OnboardingScreen());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Center(
            child: Image.asset(
              'assets/images/splash_view.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
      ),
    );
  }
}