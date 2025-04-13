import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum ExerciseType {
  breathing,
  meditation,
  muscleRelaxation,
  mindfulness,
  journaling,
  movement,
  sleep,
}

enum ExerciseDifficulty {
  beginner,
  intermediate,
  advanced,
}

class Exercise extends Equatable {
  final String id;
  final String title;
  final String description;
  final ExerciseType type;
  final ExerciseDifficulty difficulty;
  final int durationMinutes;
  final String instructions;
  final String? audioUrl;
  final String? imageUrl;
  final String? videoUrl;
  final List<String> categories;
  final List<String> tags;
  final bool featured;
  final int completionCount;

  const Exercise({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.difficulty,
    required this.durationMinutes,
    required this.instructions,
    this.audioUrl,
    this.imageUrl,
    this.videoUrl,
    this.categories = const [],
    this.tags = const [],
    this.featured = false,
    this.completionCount = 0,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        type,
        difficulty,
        durationMinutes,
        instructions,
        audioUrl,
        imageUrl,
        videoUrl,
        categories,
        tags,
        featured,
        completionCount,
      ];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.index,
      'difficulty': difficulty.index,
      'durationMinutes': durationMinutes,
      'instructions': instructions,
      'audioUrl': audioUrl,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'categories': categories,
      'tags': tags,
      'featured': featured,
      'completionCount': completionCount,
    };
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      type: ExerciseType.values[map['type'] ?? 0],
      difficulty: ExerciseDifficulty.values[map['difficulty'] ?? 0],
      durationMinutes: map['durationMinutes'] ?? 5,
      instructions: map['instructions'] ?? '',
      audioUrl: map['audioUrl'],
      imageUrl: map['imageUrl'],
      videoUrl: map['videoUrl'],
      categories: List<String>.from(map['categories'] ?? []),
      tags: List<String>.from(map['tags'] ?? []),
      featured: map['featured'] ?? false,
      completionCount: map['completionCount'] ?? 0,
    );
  }

  Exercise copyWith({
    String? id,
    String? title,
    String? description,
    ExerciseType? type,
    ExerciseDifficulty? difficulty,
    int? durationMinutes,
    String? instructions,
    String? audioUrl,
    String? imageUrl,
    String? videoUrl,
    List<String>? categories,
    List<String>? tags,
    bool? featured,
    int? completionCount,
  }) {
    return Exercise(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      difficulty: difficulty ?? this.difficulty,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      instructions: instructions ?? this.instructions,
      audioUrl: audioUrl ?? this.audioUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      categories: categories ?? this.categories,
      tags: tags ?? this.tags,
      featured: featured ?? this.featured,
      completionCount: completionCount ?? this.completionCount,
    );
  }
}

class ExerciseCompletion extends Equatable {
  final String id;
  final String exerciseId;
  final String userId;
  final DateTime completedAt;
  final int durationMinutes;
  final String? feedback;
  final int? rating;

  const ExerciseCompletion({
    required this.id,
    required this.exerciseId,
    required this.userId,
    required this.completedAt,
    required this.durationMinutes,
    this.feedback,
    this.rating,
  });

  @override
  List<Object?> get props => [
        id,
        exerciseId,
        userId,
        completedAt,
        durationMinutes,
        feedback,
        rating,
      ];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'exerciseId': exerciseId,
      'userId': userId,
      'completedAt': completedAt,
      'durationMinutes': durationMinutes,
      'feedback': feedback,
      'rating': rating,
    };
  }

  factory ExerciseCompletion.fromMap(Map<String, dynamic> map) {
    return ExerciseCompletion(
      id: map['id'] ?? '',
      exerciseId: map['exerciseId'] ?? '',
      userId: map['userId'] ?? '',
      completedAt: (map['completedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      durationMinutes: map['durationMinutes'] ?? 0,
      feedback: map['feedback'],
      rating: map['rating'],
    );
  }
}

// Extension for exercise type and difficulty labels
extension ExerciseTypeExtension on ExerciseType {
  String get label {
    switch (this) {
      case ExerciseType.breathing:
        return 'Breathing';
      case ExerciseType.meditation:
        return 'Meditation';
      case ExerciseType.muscleRelaxation:
        return 'Muscle Relaxation';
      case ExerciseType.mindfulness:
        return 'Mindfulness';
      case ExerciseType.journaling:
        return 'Journaling';
      case ExerciseType.movement:
        return 'Movement';
      case ExerciseType.sleep:
        return 'Sleep';
      default:
        return 'Breathing';
    }
  }
  
  String get icon {
    switch (this) {
      case ExerciseType.breathing:
        return 'air';
      case ExerciseType.meditation:
        return 'self_improvement';
      case ExerciseType.muscleRelaxation:
        return 'spa';
      case ExerciseType.mindfulness:
        return 'psychology';
      case ExerciseType.journaling:
        return 'edit_note';
      case ExerciseType.movement:
        return 'directions_run';
      case ExerciseType.sleep:
        return 'bedtime';
      default:
        return 'favorite';
    }
  }
}

extension ExerciseDifficultyExtension on ExerciseDifficulty {
  String get label {
    switch (this) {
      case ExerciseDifficulty.beginner:
        return 'Beginner';
      case ExerciseDifficulty.intermediate:
        return 'Intermediate';
      case ExerciseDifficulty.advanced:
        return 'Advanced';
      default:
        return 'Beginner';
    }
  }
} 