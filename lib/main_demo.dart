import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'config/demo_config.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'services/auth_service.dart';

Future<void> main() async {
  // Ensure Flutter is initialized
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  
  // Keep splash screen until initialization is complete
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  
  try {
    print('Starting app initialization...');
    
    // Load demo environment variables
    print('Loading .env.demo file...');
    await dotenv.load(fileName: '.env.demo');
    print('Environment variables loaded: ${dotenv.env}');
    
    // Initialize Firebase with demo configuration
    print('Initializing Firebase...');
    final firebaseOptions = FirebaseOptions(
      apiKey: dotenv.env['FIREBASE_API_KEY'] ?? '',
      appId: dotenv.env['FIREBASE_APP_ID'] ?? '',
      messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '',
      projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? '',
      storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? '',
    );
    print('Firebase options: $firebaseOptions');
    
    await Firebase.initializeApp(options: firebaseOptions);
    print('Firebase initialized successfully');
    
    runApp(const DemoApp());
  } catch (e, stackTrace) {
    print('Initialization error: $e');
    print('Stack trace: $stackTrace');
    FlutterNativeSplash.remove();
    runApp(ErrorApp(error: e.toString()));
  }
}

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Remove splash screen after initialization
    FlutterNativeSplash.remove();
    
    return MaterialApp(
      title: 'Serenify Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
    );
  }
}

class ErrorApp extends StatelessWidget {
  final String error;
  
  const ErrorApp({super.key, this.error = ''});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Serenify Demo - Error',
      theme: ThemeData(
        primarySwatch: Colors.red,
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Failed to initialize the app.\nPlease check your configuration.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                if (error.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text(
                    'Error details:\n$error',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Colors.red),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        
        if (snapshot.hasData) {
          return const HomeScreen();
        }
        
        return const LoginScreen();
      },
    );
  }
} 