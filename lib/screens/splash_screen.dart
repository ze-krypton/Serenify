import 'package:flutter/material.dart';
import 'package:mind_mate/constants/app_constants.dart';
import 'package:mind_mate/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _navigationAttempted = false;
  
  // Color palette to match the app theme
  static const Color warmBeige = Color(0xFFF8D070);
  static const Color warmOrange = Color(0xFFFF9666);
  static const Color warmCoral = Color(0xFFEE6D57);
  static const Color warmRed = Color(0xFFDE3C50);
  static const Color warmTeal = Color(0xFF3A877A);
  static const Color bgColor = Color(0xFFFFF9F0);

  @override
  void initState() {
    super.initState();
    // Delay navigation slightly to ensure app is fully initialized
    Future.delayed(const Duration(milliseconds: 1500), () {
      _navigateToLogin();
    });
  }

  void _navigateToLogin() {
    if (!mounted || _navigationAttempted) return;
    
    setState(() {
      _navigationAttempted = true;
    });
    
    print('SplashScreen: Attempting navigation to login');
    
    try {
      // Use string literal to match route defined in main.dart
      Navigator.pushReplacementNamed(context, '/login');
      print('SplashScreen: Navigation command executed');
    } catch (e) {
      print('SplashScreen: Error navigating to login: $e');
      
      // Try alternative navigation if the first one fails
      if (mounted) {
        try {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/login', 
            (route) => false
          );
        } catch (e2) {
          print('SplashScreen: Second navigation attempt failed: $e2');
          
          // Last resort - try Navigator.push
          try {
            final loginRoute = MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            );
            Navigator.pushReplacement(context, loginRoute);
          } catch (e3) {
            print('SplashScreen: Third navigation attempt failed: $e3');
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('SplashScreen: build method called');
    
    return Scaffold(
      backgroundColor: warmRed,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo or icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.self_improvement,
                  color: warmRed,
                  size: 60,
                ),
              ),
              const SizedBox(height: 24),
              // App name
              const Text(
                'Serenify',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              // Tagline
              Text(
                'Your path to mindfulness',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 36),
              // Loading indicator
              const SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(height: 48),
              // Manual navigation button
              ElevatedButton(
                onPressed: () {
                  print('Manual navigation button pressed');
                  _navigateToLogin();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: warmRed,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 