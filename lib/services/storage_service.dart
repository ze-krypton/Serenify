import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service for handling local data storage
class StorageService {
  static const String _moodEntriesKey = 'mood_entries';
  static const String _assessmentResultsKey = 'assessment_results';
  static const String _userKey = 'user_data';
  static const String _chatHistoryKey = 'chat_history';
  static const String _appSettingsKey = 'app_settings';
  
  // Instance of secure storage for sensitive data
  static final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  // Save mood entries to local storage
  static Future<bool> saveMoodEntries(List<Map<String, dynamic>> entries) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_moodEntriesKey, jsonEncode(entries));
    } catch (e) {
      print('Error saving mood entries: $e');
      return false;
    }
  }
  
  // Get mood entries from local storage
  static Future<List<Map<String, dynamic>>> getMoodEntries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final entriesJson = prefs.getString(_moodEntriesKey);
      
      if (entriesJson == null) {
        return [];
      }
      
      final List<dynamic> decoded = jsonDecode(entriesJson);
      return List<Map<String, dynamic>>.from(decoded);
    } catch (e) {
      print('Error retrieving mood entries: $e');
      return [];
    }
  }
  
  // Add a single mood entry (append to existing entries)
  static Future<bool> addMoodEntry(Map<String, dynamic> entry) async {
    try {
      final entries = await getMoodEntries();
      entries.add(entry);
      return await saveMoodEntries(entries);
    } catch (e) {
      print('Error adding mood entry: $e');
      return false;
    }
  }
  
  // Save assessment results
  static Future<bool> saveAssessmentResults(List<Map<String, dynamic>> results) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_assessmentResultsKey, jsonEncode(results));
    } catch (e) {
      print('Error saving assessment results: $e');
      return false;
    }
  }
  
  // Get assessment results
  static Future<List<Map<String, dynamic>>> getAssessmentResults() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final resultsJson = prefs.getString(_assessmentResultsKey);
      
      if (resultsJson == null) {
        return [];
      }
      
      final List<dynamic> decoded = jsonDecode(resultsJson);
      return List<Map<String, dynamic>>.from(decoded);
    } catch (e) {
      print('Error retrieving assessment results: $e');
      return [];
    }
  }
  
  // Add a single assessment result
  static Future<bool> addAssessmentResult(Map<String, dynamic> result) async {
    try {
      final results = await getAssessmentResults();
      results.add(result);
      return await saveAssessmentResults(results);
    } catch (e) {
      print('Error adding assessment result: $e');
      return false;
    }
  }
  
  // Save user data securely
  static Future<bool> saveUserData(Map<String, dynamic> userData) async {
    try {
      await _secureStorage.write(
        key: _userKey,
        value: jsonEncode(userData),
      );
      return true;
    } catch (e) {
      print('Error saving user data: $e');
      return false;
    }
  }
  
  // Get user data
  static Future<Map<String, dynamic>?> getUserData() async {
    try {
      final userJson = await _secureStorage.read(key: _userKey);
      
      if (userJson == null) {
        return null;
      }
      
      return jsonDecode(userJson) as Map<String, dynamic>;
    } catch (e) {
      print('Error retrieving user data: $e');
      return null;
    }
  }
  
  // Clear user data (for logout)
  static Future<bool> clearUserData() async {
    try {
      await _secureStorage.delete(key: _userKey);
      return true;
    } catch (e) {
      print('Error clearing user data: $e');
      return false;
    }
  }
  
  // Save chat history
  static Future<bool> saveChatHistory(List<Map<String, dynamic>> messages) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_chatHistoryKey, jsonEncode(messages));
    } catch (e) {
      print('Error saving chat history: $e');
      return false;
    }
  }
  
  // Get chat history
  static Future<List<Map<String, dynamic>>> getChatHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final messagesJson = prefs.getString(_chatHistoryKey);
      
      if (messagesJson == null) {
        return [];
      }
      
      final List<dynamic> decoded = jsonDecode(messagesJson);
      return List<Map<String, dynamic>>.from(decoded);
    } catch (e) {
      print('Error retrieving chat history: $e');
      return [];
    }
  }
  
  // Add a chat message
  static Future<bool> addChatMessage(Map<String, dynamic> message) async {
    try {
      final messages = await getChatHistory();
      messages.add(message);
      return await saveChatHistory(messages);
    } catch (e) {
      print('Error adding chat message: $e');
      return false;
    }
  }
  
  // Save app settings
  static Future<bool> saveAppSettings(Map<String, dynamic> settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_appSettingsKey, jsonEncode(settings));
    } catch (e) {
      print('Error saving app settings: $e');
      return false;
    }
  }
  
  // Get app settings
  static Future<Map<String, dynamic>> getAppSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_appSettingsKey);
      
      if (settingsJson == null) {
        return {};
      }
      
      return jsonDecode(settingsJson) as Map<String, dynamic>;
    } catch (e) {
      print('Error retrieving app settings: $e');
      return {};
    }
  }
  
  // Update a specific setting
  static Future<bool> updateSetting(String key, dynamic value) async {
    try {
      final settings = await getAppSettings();
      settings[key] = value;
      return await saveAppSettings(settings);
    } catch (e) {
      print('Error updating setting: $e');
      return false;
    }
  }
  
  // Clear all data (factory reset)
  static Future<bool> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      await _secureStorage.deleteAll();
      return true;
    } catch (e) {
      print('Error clearing all data: $e');
      return false;
    }
  }
} 