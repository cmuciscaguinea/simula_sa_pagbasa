import 'package:flutter/material.dart';
import 'main.dart'; // Import your HomePage

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  double _progressValue = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _simulateLoading();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.forward();
  }

  void _simulateLoading() {
    // Simulate progress (replace with real loading tasks)
    const totalSteps = 30;
    const stepDuration = Duration(milliseconds: 100);

    void updateProgress(int step) {
      if (!mounted) return;
      setState(() => _progressValue = step / totalSteps);
      
      if (step < totalSteps) {
        Future.delayed(stepDuration, () => updateProgress(step + 1));
      } else {
        _navigateToHome();
      }
    }

    updateProgress(0);
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 300)); // Smooth transition
    if (!mounted) return;
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
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
          // Gradient background (unchanged)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFD700), Color(0xFF87CEEB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Main content
          Center(
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo with error handling
                  Image.asset(
                    'assets/Bg22.png',
                    height: 200,
                    width: 200,
                    errorBuilder: (context, error, stackTrace) => 
                      const Icon(Icons.apps, size: 100, color: Colors.white),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Linear progress bar
                  SizedBox(
                    width: 200,
                    child: LinearProgressIndicator(
                      value: _progressValue,
                      backgroundColor: const Color.fromARGB(255, 243, 183, 18).withOpacity(0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(const Color.fromARGB(255, 241, 227, 28)),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  
                  const SizedBox(height: 15),
                  
                  // Percentage text
                  Text(
                    '${(_progressValue * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}