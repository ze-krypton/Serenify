import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  
  // Updated color palette based on the warm palette image
  static const Color warmBeige = Color(0xFFF8D070);
  static const Color warmOrange = Color(0xFFFF9666);
  static const Color warmCoral = Color(0xFFEE6D57);
  static const Color warmRed = Color(0xFFDE3C50);
  static const Color warmTeal = Color(0xFF3A877A);
  
  // Background color for the app
  static const Color bgColor = Color(0xFFFFF9F0);
  
  // Original pastel palette (keeping for reference)
  static const Color lavender = Color(0xFFE0B7F4);
  static const Color softPink = Color(0xFFF2B5E1);
  static const Color lightBlue = Color(0xFFBFDFF3);
  static const Color mint = Color(0xFFB9E9E9);
  static const Color peach = Color(0xFFFFC9B4);

  @override
  void initState() {
    super.initState();
    // Pre-fill with demo credentials
    _emailController.text = 'demo@serenify.com';
    _passwordController.text = 'Demo@123';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Validate inputs
    if (_emailController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter an email';
        _isLoading = false;
      });
      return;
    }

    if (_passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a password';
        _isLoading = false;
      });
      return;
    }

    // Simple validation for demo mode
    if (_emailController.text == 'demo@serenify.com' && _passwordController.text == 'Demo@123') {
      // Navigate to home on successful login
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pushReplacementNamed('/home');
      });
    } else {
      // Show error for wrong credentials
      Future.delayed(const Duration(milliseconds: 800), () {
        setState(() {
          _errorMessage = 'Invalid credentials. Use demo@serenify.com / Demo@123';
          _isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('LoginScreen: build method called');
    
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Login', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: warmCoral,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [bgColor, bgColor, Color(0xFFFFF5E7)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo area
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: warmOrange.withOpacity(0.2),
                  ),
                  child: Icon(
                    Icons.spa,
                    size: 72,
                    color: warmOrange,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Serenify',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = LinearGradient(
                        colors: [warmOrange, warmCoral],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                // Email field
                TextField(
                  controller: _emailController,
                  style: const TextStyle(
                    fontSize: 16, 
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: warmCoral),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFDED5CD),
                    prefixIcon: Icon(Icons.email, color: warmCoral),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: warmCoral, width: 2),
                    ),
                    hintStyle: TextStyle(color: Colors.grey[700]),
                  ),
                ),
                const SizedBox(height: 16),
                // Password field
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(
                    fontSize: 16, 
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: warmCoral),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFDED5CD),
                    prefixIcon: Icon(Icons.lock, color: warmCoral),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: warmCoral, width: 2),
                    ),
                    hintStyle: TextStyle(color: Colors.grey[700]),
                  ),
                ),
                // Error message area
                if (_errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage!,
                    style: TextStyle(color: warmRed),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 24),
                // Login button
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: warmCoral,
                    disabledBackgroundColor: warmCoral.withOpacity(0.5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading 
                    ? const SizedBox(
                        height: 20, 
                        width: 20, 
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        )
                      )
                    : const Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 16),
                // Register link
                TextButton(
                  onPressed: () {
                    // Navigate to register screen
                    Navigator.of(context).pushNamed('/register');
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: warmCoral,
                  ),
                  child: const Text('Don\'t have an account? Register'),
                ),
                const SizedBox(height: 16),
                // Demo mode info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: warmBeige.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Demo Mode',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: warmBeige.darker(),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Use demo@serenify.com / Demo@123',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Extension to get darker color variants
extension ColorExtension on Color {
  Color darker() {
    const factor = 0.8;
    return Color.fromARGB(
      alpha,
      (red * factor).round(),
      (green * factor).round(),
      (blue * factor).round(),
    );
  }
} 