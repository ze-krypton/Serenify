import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../constants/app_constants.dart';

class Question extends Equatable {
  final String id;
  final String text;
  final List<String> options;
  final List<int> scores;

  const Question({
    required this.id,
    required this.text,
    required this.options,
    required this.scores,
  });

  @override
  List<Object?> get props => [id, text, options, scores];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'options': options,
      'scores': scores,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      scores: List<int>.from(map['scores'] ?? []),
    );
  }
}

class Assessment extends Equatable {
  final String id;
  final String title;
  final String type;
  final String description;
  final List<Question> questions;
  final Map<String, dynamic> interpretations;

  const Assessment({
    required this.id,
    required this.title,
    required this.type,
    required this.description,
    required this.questions,
    required this.interpretations,
  });

  @override
  List<Object?> get props => [id, title, type, description, questions, interpretations];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'description': description,
      'questions': questions.map((q) => q.toMap()).toList(),
      'interpretations': interpretations,
    };
  }

  factory Assessment.fromMap(Map<String, dynamic> map) {
    return Assessment(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      type: map['type'] ?? '',
      description: map['description'] ?? '',
      questions: List<Question>.from(
        (map['questions'] ?? []).map((q) => Question.fromMap(q)),
      ),
      interpretations: Map<String, dynamic>.from(map['interpretations'] ?? {}),
    );
  }
}

class AssessmentResult extends Equatable {
  final String id;
  final String userId;
  final String assessmentId;
  final String assessmentType;
  final int score;
  final String interpretation;
  final Map<String, dynamic> answers;
  final DateTime takenAt;

  const AssessmentResult({
    required this.id,
    required this.userId,
    required this.assessmentId,
    required this.assessmentType,
    required this.score,
    required this.interpretation,
    required this.answers,
    required this.takenAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        assessmentId,
        assessmentType,
        score,
        interpretation,
        answers,
        takenAt,
      ];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'assessmentId': assessmentId,
      'assessmentType': assessmentType,
      'score': score,
      'interpretation': interpretation,
      'answers': answers,
      'takenAt': takenAt,
    };
  }

  factory AssessmentResult.fromMap(Map<String, dynamic> map) {
    return AssessmentResult(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      assessmentId: map['assessmentId'] ?? '',
      assessmentType: map['assessmentType'] ?? '',
      score: map['score'] ?? 0,
      interpretation: map['interpretation'] ?? '',
      answers: Map<String, dynamic>.from(map['answers'] ?? {}),
      takenAt: (map['takenAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  AssessmentResult copyWith({
    String? id,
    String? userId,
    String? assessmentId,
    String? assessmentType,
    int? score,
    String? interpretation,
    Map<String, dynamic>? answers,
    DateTime? takenAt,
  }) {
    return AssessmentResult(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      assessmentId: assessmentId ?? this.assessmentId,
      assessmentType: assessmentType ?? this.assessmentType,
      score: score ?? this.score,
      interpretation: interpretation ?? this.interpretation,
      answers: answers ?? this.answers,
      takenAt: takenAt ?? this.takenAt,
    );
  }
} 