import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Enum representing different mood states
enum Mood {
  happy('😊', 'Happy'),
  excited('🤩', 'Excited'),
  calm('😌', 'Calm'),
  neutral('😐', 'Neutral'),
  sad('😔', 'Sad'),
  anxious('😰', 'Anxious'),
  angry('😠', 'Angry'),
  stressed('😫', 'Stressed');

  final String emoji;
  final String name;
  const Mood(this.emoji, this.name);
}

/// Enum representing factors that may contribute to mood
enum MoodFactor {
  work('Work'),
  family('Family'),
  health('Health'),
  sleep('Sleep'),
  exercise('Exercise'),
  diet('Diet'),
  weather('Weather'),
  socializing('Socializing'),
  meditation('Meditation'),
  stress('Stress'),
  achievement('Achievement'),
  failure('Failure');

  final String name;
  const MoodFactor(this.name);
}

/// Model class representing a mood entry
class MoodEntry {
  final String id;
  final Mood mood;
  final DateTime date;
  final String note;
  final List<MoodFactor> factors;

  MoodEntry({
    required this.id,
    required this.mood,
    required this.date,
    this.note = '',
    this.factors = const [],
  });

  /// Create a MoodEntry from a map (for storage)
  factory MoodEntry.fromMap(Map<String, dynamic> map) {
    return MoodEntry(
      id: map['id'] as String,
      mood: Mood.values.firstWhere(
        (m) => m.name == map['mood'],
        orElse: () => Mood.neutral,
      ),
      date: DateTime.parse(map['date'] as String),
      note: map['note'] as String? ?? '',
      factors: (map['factors'] as List<dynamic>?)
              ?.map((f) => MoodFactor.values.firstWhere(
                    (mf) => mf.name == f,
                    orElse: () => MoodFactor.work,
                  ))
              .toList() ??
          [],
    );
  }

  /// Convert a MoodEntry to a map (for storage)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mood': mood.name,
      'date': date.toIso8601String(),
      'note': note,
      'factors': factors.map((f) => f.name).toList(),
    };
  }
}

// Extension to get the emoji representation of a mood
extension MoodLevelEmoji on Mood {
  String get emoji {
    switch (this) {
      case Mood.happy:
        return '😊';
      case Mood.excited:
        return '🤩';
      case Mood.calm:
        return '😌';
      case Mood.neutral:
        return '😐';
      case Mood.sad:
        return '😔';
      case Mood.anxious:
        return '😰';
      case Mood.angry:
        return '😠';
      case Mood.stressed:
        return '😫';
    }
  }
  
  String get label {
    switch (this) {
      case Mood.happy:
        return 'Happy';
      case Mood.excited:
        return 'Excited';
      case Mood.calm:
        return 'Calm';
      case Mood.neutral:
        return 'Neutral';
      case Mood.sad:
        return 'Sad';
      case Mood.anxious:
        return 'Anxious';
      case Mood.angry:
        return 'Angry';
      case Mood.stressed:
        return 'Stressed';
    }
  }
  
  int get value {
    switch (this) {
      case Mood.happy:
        return 1;
      case Mood.excited:
        return 2;
      case Mood.calm:
        return 3;
      case Mood.neutral:
        return 4;
      case Mood.sad:
        return 5;
      case Mood.anxious:
        return 6;
      case Mood.angry:
        return 7;
      case Mood.stressed:
        return 8;
    }
  }
}

extension MoodFactorEmoji on MoodFactor {
  String get emoji {
    switch (this) {
      case MoodFactor.work:
        return '💼';
      case MoodFactor.family:
        return '👪';
      case MoodFactor.health:
        return '🏋️';
      case MoodFactor.sleep:
        return '🛌';
      case MoodFactor.exercise:
        return '🏋️';
      case MoodFactor.diet:
        return '🥗';
      case MoodFactor.weather:
        return '☀️';
      case MoodFactor.socializing:
        return '👥';
      case MoodFactor.meditation:
        return '🧘';
      case MoodFactor.stress:
        return '😰';
      case MoodFactor.achievement:
        return '🏆';
      case MoodFactor.failure:
        return '📉';
    }
  }
} 