// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mind_mate/main.dart';
import 'package:mind_mate/screens/login_screen.dart';
import 'package:mind_mate/screens/register_screen.dart';
import 'package:mind_mate/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:mind_mate/providers/auth_provider.dart';
import 'package:mind_mate/providers/theme_provider.dart';

void main() {
  group('App Tests', () {
    testWidgets('App launches successfully', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ],
          child: const SerenifyApp(),
        ),
      );
      expect(find.byType(SplashScreen), findsOneWidget);
    });

    testWidgets('Login screen renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ],
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('Register screen renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ],
          child: MaterialApp(
            home: RegisterScreen(),
          ),
        ),
      );
      expect(find.byType(TextField), findsNWidgets(3));
      expect(find.text('Register'), findsOneWidget);
    });
  });
}
