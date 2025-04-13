import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mind_mate/services/firebase_service.dart';
import 'package:mind_mate/themes/app_theme.dart';
import 'package:mind_mate/constants/app_constants.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:mind_mate/screens/splash_screen.dart';
import 'package:mind_mate/screens/login_screen.dart';
import 'package:mind_mate/screens/register_screen.dart';
import 'package:mind_mate/screens/home_screen.dart';
import 'package:mind_mate/screens/assessment_screen.dart';
import 'package:mind_mate/screens/chatbot_screen.dart';
import 'package:mind_mate/screens/resources_screen.dart';
import 'package:mind_mate/screens/profile_screen.dart';
import 'package:mind_mate/screens/mood_tracker_screen.dart';
import 'package:mind_mate/screens/exercises_screen.dart';
import 'package:mind_mate/screens/emergency_screen.dart';
import 'package:mind_mate/screens/mood_stats_screen.dart';
import 'package:mind_mate/providers/auth_provider.dart';
import 'package:mind_mate/providers/theme_provider.dart';
import 'package:mind_mate/utils/route_observer.dart';

void main() {
  // Add error handlers to catch and log all errors
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    print('Flutter error: ${details.exception}');
    print('Stack trace: ${details.stack}');
  };
  
  // Handle errors that occur during app startup
  ErrorWidget.builder = (FlutterErrorDetails details) {
    print('Error in building widget: ${details.exception}');
    print('Stack trace: ${details.stack}');
    return Material(
      child: Container(
        color: Colors.red,
        child: Center(
          child: Text(
            'An error occurred: ${details.exception}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  };

  // Handle errors outside Flutter
  PlatformDispatcher.instance.onError = (error, stack) {
    print('Platform error: $error');
    print('Stack trace: $stack');
    return true;
  };
  
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const SerenifyApp(),
    );
  }
}

class SerenifyApp extends StatelessWidget {
  const SerenifyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Serenify',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
