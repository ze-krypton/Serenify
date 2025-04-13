import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mind_mate/models/exercise_model.dart';
import 'package:mind_mate/services/firebase_service.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';

class ExerciseService {
  final FirebaseFirestore _firestore = FirebaseService.firestore;
  final CollectionReference _exercisesCollection = FirebaseService.getCollection('exercises');
  final CollectionReference _completionsCollection = FirebaseService.getCollection('exercise_completions');

  // Get all exercises
  Future<List<Exercise>> getExercises() async {
    try {
      final QuerySnapshot snapshot = await _exercisesCollection.get();
      
      return snapshot.docs.map((doc) {
        return Exercise.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting exercises: $e');
      }
      return [];
    }
  }

  // Get exercise by ID
  Future<Exercise?> getExerciseById(String exerciseId) async {
    try {
      final DocumentSnapshot doc = await _exercisesCollection.doc(exerciseId).get();
      
      if (doc.exists) {
        return Exercise.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting exercise by ID: $e');
      }
      return null;
    }
  }

  // Get exercises by type
  Future<List<Exercise>> getExercisesByType(ExerciseType type) async {
    try {
      final QuerySnapshot snapshot = await _exercisesCollection
          .where('type', isEqualTo: type.index)
          .get();
      
      return snapshot.docs.map((doc) {
        return Exercise.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting exercises by type: $e');
      }
      return [];
    }
  }

  // Get exercises by category
  Future<List<Exercise>> getExercisesByCategory(String category) async {
    try {
      final QuerySnapshot snapshot = await _exercisesCollection
          .where('categories', arrayContains: category)
          .get();
      
      return snapshot.docs.map((doc) {
        return Exercise.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting exercises by category: $e');
      }
      return [];
    }
  }

  // Get featured exercises
  Future<List<Exercise>> getFeaturedExercises() async {
    try {
      final QuerySnapshot snapshot = await _exercisesCollection
          .where('featured', isEqualTo: true)
          .get();
      
      return snapshot.docs.map((doc) {
        return Exercise.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting featured exercises: $e');
      }
      return [];
    }
  }

  // Get exercises by difficulty
  Future<List<Exercise>> getExercisesByDifficulty(ExerciseDifficulty difficulty) async {
    try {
      final QuerySnapshot snapshot = await _exercisesCollection
          .where('difficulty', isEqualTo: difficulty.index)
          .get();
      
      return snapshot.docs.map((doc) {
        return Exercise.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting exercises by difficulty: $e');
      }
      return [];
    }
  }

  // Get exercises by duration
  Future<List<Exercise>> getExercisesByDuration(int maxDurationMinutes) async {
    try {
      final QuerySnapshot snapshot = await _exercisesCollection
          .where('durationMinutes', isLessThanOrEqualTo: maxDurationMinutes)
          .get();
      
      return snapshot.docs.map((doc) {
        return Exercise.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting exercises by duration: $e');
      }
      return [];
    }
  }

  // Log exercise completion
  Future<ExerciseCompletion?> logExerciseCompletion({
    required String exerciseId,
    required String userId,
    required int durationMinutes,
    String? feedback,
    int? rating,
  }) async {
    try {
      final String id = const Uuid().v4();
      final DateTime completedAt = DateTime.now();
      
      final ExerciseCompletion completion = ExerciseCompletion(
        id: id,
        exerciseId: exerciseId,
        userId: userId,
        completedAt: completedAt,
        durationMinutes: durationMinutes,
        feedback: feedback,
        rating: rating,
      );
      
      await _completionsCollection.doc(id).set(completion.toMap());
      
      // Increment the completion count for the exercise
      await _exercisesCollection.doc(exerciseId).update({
        'completionCount': FieldValue.increment(1),
      });
      
      return completion;
    } catch (e) {
      if (kDebugMode) {
        print('Error logging exercise completion: $e');
      }
      return null;
    }
  }

  // Get exercise completions for a user
  Future<List<ExerciseCompletion>> getUserExerciseCompletions(String userId) async {
    try {
      final QuerySnapshot snapshot = await _completionsCollection
          .where('userId', isEqualTo: userId)
          .orderBy('completedAt', descending: true)
          .get();
      
      return snapshot.docs.map((doc) {
        return ExerciseCompletion.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user exercise completions: $e');
      }
      return [];
    }
  }

  // Get recommended exercises based on mood
  Future<List<Exercise>> getRecommendedExercises(String moodLevel) async {
    try {
      // This is a simplified implementation
      // In a real app, you would have a more sophisticated recommendation system
      
      // Choose appropriate exercise type based on mood
      ExerciseType exerciseType;
      
      switch (moodLevel) {
        case 'veryBad':
          exerciseType = ExerciseType.mindfulness;
          break;
        case 'bad':
          exerciseType = ExerciseType.breathing;
          break;
        case 'neutral':
          exerciseType = ExerciseType.meditation;
          break;
        case 'good':
          exerciseType = ExerciseType.journaling;
          break;
        case 'veryGood':
          exerciseType = ExerciseType.movement;
          break;
        default:
          exerciseType = ExerciseType.breathing;
      }
      
      // Get exercises of this type
      final exercises = await getExercisesByType(exerciseType);
      
      // If no exercises of this type, get some featured ones
      if (exercises.isEmpty) {
        return getFeaturedExercises();
      }
      
      return exercises;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting recommended exercises: $e');
      }
      return [];
    }
  }

  // Get exercise statistics for a user
  Future<Map<String, dynamic>> getUserExerciseStatistics(String userId) async {
    try {
      final List<ExerciseCompletion> completions = await getUserExerciseCompletions(userId);
      
      if (completions.isEmpty) {
        return {
          'totalExercises': 0,
          'totalMinutes': 0,
          'favoriteType': null,
          'exercisesLastWeek': 0,
          'minutesLastWeek': 0,
        };
      }
      
      // Calculate total exercises and minutes
      final int totalExercises = completions.length;
      final int totalMinutes = completions.fold(0, (sum, comp) => sum + comp.durationMinutes);
      
      // Find favorite exercise type
      Map<String, int> exerciseTypeCounts = {};
      
      for (var completion in completions) {
        final Exercise? exercise = await getExerciseById(completion.exerciseId);
        if (exercise != null) {
          final String typeLabel = exercise.type.label;
          exerciseTypeCounts[typeLabel] = (exerciseTypeCounts[typeLabel] ?? 0) + 1;
        }
      }
      
      String? favoriteType;
      int maxCount = 0;
      
      exerciseTypeCounts.forEach((type, count) {
        if (count > maxCount) {
          maxCount = count;
          favoriteType = type;
        }
      });
      
      // Calculate exercises and minutes in the last week
      final DateTime oneWeekAgo = DateTime.now().subtract(const Duration(days: 7));
      
      final List<ExerciseCompletion> lastWeekCompletions = completions
          .where((comp) => comp.completedAt.isAfter(oneWeekAgo))
          .toList();
      
      final int exercisesLastWeek = lastWeekCompletions.length;
      final int minutesLastWeek = lastWeekCompletions.fold(0, (sum, comp) => sum + comp.durationMinutes);
      
      return {
        'totalExercises': totalExercises,
        'totalMinutes': totalMinutes,
        'favoriteType': favoriteType,
        'exercisesLastWeek': exercisesLastWeek,
        'minutesLastWeek': minutesLastWeek,
      };
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user exercise statistics: $e');
      }
      return {
        'totalExercises': 0,
        'totalMinutes': 0,
        'favoriteType': null,
        'exercisesLastWeek': 0,
        'minutesLastWeek': 0,
      };
    }
  }
} 