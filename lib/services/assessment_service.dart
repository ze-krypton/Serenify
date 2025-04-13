import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mind_mate/models/assessment_model.dart';
import 'package:mind_mate/services/firebase_service.dart';
import 'package:mind_mate/services/auth_service.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';

class AssessmentService {
  final FirebaseFirestore _firestore = FirebaseService.firestore;
  final CollectionReference _assessmentsCollection = FirebaseService.getCollection('assessments');
  final CollectionReference _assessmentResultsCollection = FirebaseService.getCollection('assessment_results');
  final AuthService _authService = AuthService();

  // Get all available assessments
  Future<List<Assessment>> getAssessments() async {
    try {
      final QuerySnapshot snapshot = await _assessmentsCollection.get();
      return snapshot.docs.map((doc) {
        return Assessment.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting assessments: $e');
      }
      return [];
    }
  }

  // Get assessment by ID
  Future<Assessment?> getAssessmentById(String assessmentId) async {
    try {
      final DocumentSnapshot doc = await _assessmentsCollection.doc(assessmentId).get();
      if (doc.exists) {
        return Assessment.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting assessment by ID: $e');
      }
      return null;
    }
  }

  // Get assessments by type
  Future<List<Assessment>> getAssessmentsByType(String type) async {
    try {
      final QuerySnapshot snapshot = await _assessmentsCollection
          .where('type', isEqualTo: type)
          .get();
      
      return snapshot.docs.map((doc) {
        return Assessment.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting assessments by type: $e');
      }
      return [];
    }
  }

  // Save assessment result
  Future<AssessmentResult?> saveAssessmentResult({
    required String userId,
    required String assessmentId,
    required String assessmentType,
    required int score,
    required String interpretation,
    required Map<String, dynamic> answers,
  }) async {
    try {
      final String id = const Uuid().v4();
      final DateTime takenAt = DateTime.now();
      
      final AssessmentResult result = AssessmentResult(
        id: id,
        userId: userId,
        assessmentId: assessmentId,
        assessmentType: assessmentType,
        score: score,
        interpretation: interpretation,
        answers: answers,
        takenAt: takenAt,
      );
      
      await _assessmentResultsCollection.doc(id).set(result.toMap());
      
      // Add assessment to user's completed assessments
      await _authService.addCompletedAssessment(userId, assessmentId);
      
      return result;
    } catch (e) {
      if (kDebugMode) {
        print('Error saving assessment result: $e');
      }
      return null;
    }
  }

  // Calculate score from answers
  int calculateScore(Assessment assessment, Map<String, int> answers) {
    int totalScore = 0;
    
    answers.forEach((questionId, answerIndex) {
      // Find the question
      final questionMatch = assessment.questions.where((q) => q.id == questionId);
      
      if (questionMatch.isNotEmpty) {
        final question = questionMatch.first;
        if (answerIndex >= 0 && answerIndex < question.scores.length) {
          totalScore += question.scores[answerIndex];
        }
      }
    });
    
    return totalScore;
  }

  // Get interpretation for a score
  String getInterpretation(Assessment assessment, int score) {
    String interpretation = 'No interpretation available';
    
    assessment.interpretations.forEach((range, value) {
      final List<String> rangeParts = range.split('-');
      if (rangeParts.length == 2) {
        final int lower = int.parse(rangeParts[0]);
        final int upper = int.parse(rangeParts[1]);
        
        if (score >= lower && score <= upper) {
          interpretation = value.toString();
        }
      }
    });
    
    return interpretation;
  }

  // Get assessment results for a user
  Future<List<AssessmentResult>> getUserAssessmentResults(String userId) async {
    try {
      final QuerySnapshot snapshot = await _assessmentResultsCollection
          .where('userId', isEqualTo: userId)
          .orderBy('takenAt', descending: true)
          .get();
      
      return snapshot.docs.map((doc) {
        return AssessmentResult.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user assessment results: $e');
      }
      return [];
    }
  }

  // Get assessment results for a user by type
  Future<List<AssessmentResult>> getUserAssessmentResultsByType(
    String userId,
    String assessmentType,
  ) async {
    try {
      final QuerySnapshot snapshot = await _assessmentResultsCollection
          .where('userId', isEqualTo: userId)
          .where('assessmentType', isEqualTo: assessmentType)
          .orderBy('takenAt', descending: true)
          .get();
      
      return snapshot.docs.map((doc) {
        return AssessmentResult.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user assessment results by type: $e');
      }
      return [];
    }
  }

  // Get the most recent assessment result for a user
  Future<AssessmentResult?> getLatestAssessmentResult(String userId) async {
    try {
      final QuerySnapshot snapshot = await _assessmentResultsCollection
          .where('userId', isEqualTo: userId)
          .orderBy('takenAt', descending: true)
          .limit(1)
          .get();
      
      if (snapshot.docs.isNotEmpty) {
        return AssessmentResult.fromMap(snapshot.docs.first.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting latest assessment result: $e');
      }
      return null;
    }
  }
} 