import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mind_mate/models/mood_entry_model.dart';
import 'package:mind_mate/services/firebase_service.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';

class MoodService {
  final FirebaseFirestore _firestore = FirebaseService.firestore;
  final CollectionReference _moodCollection = FirebaseService.getCollection('moods');

  // Add a new mood entry
  Future<MoodEntry?> addMoodEntry({
    required String userId,
    required MoodLevel mood,
    String? note,
    List<String> tags = const [],
  }) async {
    try {
      final String id = const Uuid().v4();
      final DateTime timestamp = DateTime.now();
      
      final MoodEntry moodEntry = MoodEntry(
        id: id,
        userId: userId,
        mood: mood,
        note: note,
        tags: tags,
        timestamp: timestamp,
      );
      
      await _moodCollection.doc(id).set(moodEntry.toMap());
      return moodEntry;
    } catch (e) {
      if (kDebugMode) {
        print('Error adding mood entry: $e');
      }
      return null;
    }
  }

  // Get all mood entries for a user
  Stream<List<MoodEntry>> getMoodEntries(String userId) {
    try {
      return _moodCollection
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return MoodEntry.fromMap(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error getting mood entries: $e');
      }
      return Stream.value([]);
    }
  }

  // Get mood entries for a user within a date range
  Stream<List<MoodEntry>> getMoodEntriesInRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) {
    try {
      return _moodCollection
          .where('userId', isEqualTo: userId)
          .where('timestamp', isGreaterThanOrEqualTo: startDate)
          .where('timestamp', isLessThanOrEqualTo: endDate)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return MoodEntry.fromMap(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error getting mood entries in range: $e');
      }
      return Stream.value([]);
    }
  }

  // Update a mood entry
  Future<bool> updateMoodEntry(MoodEntry moodEntry) async {
    try {
      await _moodCollection.doc(moodEntry.id).update(moodEntry.toMap());
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error updating mood entry: $e');
      }
      return false;
    }
  }

  // Delete a mood entry
  Future<bool> deleteMoodEntry(String moodEntryId) async {
    try {
      await _moodCollection.doc(moodEntryId).delete();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting mood entry: $e');
      }
      return false;
    }
  }

  // Get the latest mood entry for a user
  Future<MoodEntry?> getLatestMoodEntry(String userId) async {
    try {
      final QuerySnapshot snapshot = await _moodCollection
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();
      
      if (snapshot.docs.isNotEmpty) {
        return MoodEntry.fromMap(snapshot.docs.first.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting latest mood entry: $e');
      }
      return null;
    }
  }

  // Get mood statistics for a user
  Future<Map<String, dynamic>> getMoodStatistics(String userId, {int daysBack = 30}) async {
    try {
      final DateTime endDate = DateTime.now();
      final DateTime startDate = endDate.subtract(Duration(days: daysBack));
      
      final QuerySnapshot snapshot = await _moodCollection
          .where('userId', isEqualTo: userId)
          .where('timestamp', isGreaterThanOrEqualTo: startDate)
          .where('timestamp', isLessThanOrEqualTo: endDate)
          .get();
      
      final List<MoodEntry> moods = snapshot.docs
          .map((doc) => MoodEntry.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      
      if (moods.isEmpty) {
        return {
          'averageMood': MoodLevel.neutral.value,
          'moodCounts': {},
          'topTags': [],
          'entries': 0,
        };
      }
      
      // Calculate average mood
      double averageMood = moods.fold(0, (prev, mood) => prev + mood.mood.value) / moods.length;
      
      // Count moods by type
      Map<String, int> moodCounts = {};
      for (var mood in moods) {
        final String moodLabel = mood.mood.label;
        moodCounts[moodLabel] = (moodCounts[moodLabel] ?? 0) + 1;
      }
      
      // Get top tags
      Map<String, int> tagCounts = {};
      for (var mood in moods) {
        for (var tag in mood.tags) {
          tagCounts[tag] = (tagCounts[tag] ?? 0) + 1;
        }
      }
      
      List<MapEntry<String, int>> sortedTags = tagCounts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      
      List<String> topTags = sortedTags.take(5).map((e) => e.key).toList();
      
      return {
        'averageMood': averageMood,
        'moodCounts': moodCounts,
        'topTags': topTags,
        'entries': moods.length,
      };
    } catch (e) {
      if (kDebugMode) {
        print('Error getting mood statistics: $e');
      }
      return {
        'averageMood': MoodLevel.neutral.value,
        'moodCounts': {},
        'topTags': [],
        'entries': 0,
      };
    }
  }
} 