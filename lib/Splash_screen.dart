import 'package:flutter/material.dart';
import 'dart:async';

import 'main.dart'; // Import main.dart to navigate to HomePage

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Duration of the scaling animation
    );

    // Define the scale animation
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    // Start the animation
    _animationController.forward();

    // Navigate to HomePage after the splash screen duration
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Vibrant, kid-friendly gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFD700), Color(0xFF87CEEB)], // Yellow to Sky Blue
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Centered animated image
          Center(
            child: ScaleTransition(
              scale: _scaleAnimation, // Apply scaling animation to the image
              child: Image.asset(
                'assets/Bg22.png', // Single image for splash screen
                height: 300, // Adjust height as needed
                width: 300, // Adjust width as needed
                fit: BoxFit.contain, // Ensures the image scales proportionally
              ),
            ),
          ),
        ],
      ),
    );
  }
}
