import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mind_mate/constants/app_constants.dart';

class ThemeProvider extends ChangeNotifier {
  // Theme mode: light, dark, or system
  ThemeMode _themeMode = ThemeMode.system;
  
  // Constructor - load saved theme preference
  ThemeProvider() {
    _loadThemePreference();
  }
  
  // Get the current theme mode
  ThemeMode get themeMode => _themeMode;
  
  // Check if dark mode is active
  bool isDarkMode(BuildContext context) {
    if (_themeMode == ThemeMode.system) {
      return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }
  
  // Load saved theme preference
  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeModeString = prefs.getString(AppConstants.themePreferenceKey);
      if (themeModeString != null) {
        _themeMode = _stringToThemeMode(themeModeString);
        notifyListeners();
      }
    } catch (e) {
      print('Error loading theme preference: $e');
    }
  }
  
  // Save theme preference
  Future<void> _saveThemePreference(ThemeMode mode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        AppConstants.themePreferenceKey,
        _themeModeToString(mode),
      );
    } catch (e) {
      print('Error saving theme preference: $e');
    }
  }
  
  // Set theme mode
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _saveThemePreference(mode);
    notifyListeners();
  }
  
  // Toggle between light and dark theme
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _saveThemePreference(_themeMode);
    notifyListeners();
  }
  
  // Convert ThemeMode to string for storage
  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
      default:
        return 'system';
    }
  }
  
  // Convert string to ThemeMode
  ThemeMode _stringToThemeMode(String modeString) {
    switch (modeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }
} 