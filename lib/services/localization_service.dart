import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationService {
  static const String _languageKey = 'language';
  static const String _defaultLanguage = 'en';

  static final List<Locale> supportedLocales = [
    const Locale('en', 'US'),
    const Locale('es', 'ES'),
    const Locale('fr', 'FR'),
    const Locale('de', 'DE'),
    const Locale('it', 'IT'),
    const Locale('pt', 'BR'),
    const Locale('ru', 'RU'),
    const Locale('zh', 'CN'),
    const Locale('ja', 'JP'),
    const Locale('ar', 'SA'),
  ];

  static final List<LocalizationsDelegate> localizationsDelegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static Future<Locale> getLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageKey) ?? _defaultLanguage;
    return Locale(languageCode);
  }

  static Future<void> setLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }

  static String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      case 'fr':
        return 'Français';
      case 'de':
        return 'Deutsch';
      case 'it':
        return 'Italiano';
      case 'pt':
        return 'Português';
      case 'ru':
        return 'Русский';
      case 'zh':
        return '中文';
      case 'ja':
        return '日本語';
      case 'ar':
        return 'العربية';
      default:
        return 'English';
    }
  }

  static bool isRTL(String languageCode) {
    return languageCode == 'ar';
  }

  static String formatDate(DateTime date, String languageCode) {
    // Implement date formatting based on language
    return date.toString();
  }

  static String formatNumber(double number, String languageCode) {
    // Implement number formatting based on language
    return number.toString();
  }

  static String formatCurrency(double amount, String languageCode) {
    // Implement currency formatting based on language
    return '\$${amount.toStringAsFixed(2)}';
  }

  static String getDirectionality(String languageCode) {
    return isRTL(languageCode) ? 'rtl' : 'ltr';
  }
} 