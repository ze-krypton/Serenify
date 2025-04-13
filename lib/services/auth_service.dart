import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mind_mate/models/user_model.dart';
import 'package:mind_mate/services/firebase_service.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseService.firestore;
  final CollectionReference _usersCollection = FirebaseService.getCollection('users');

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Demo login
  Future<UserCredential?> demoLogin() async {
    try {
      final email = dotenv.env['DEMO_USER_EMAIL'] ?? 'demo@serenify.com';
      final password = dotenv.env['DEMO_USER_PASSWORD'] ?? 'Demo@123';
      
      // Try to sign in
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Demo login error: $e');
      // If the user doesn't exist, create it
      if (e is FirebaseAuthException && e.code == 'user-not-found') {
        try {
          return await _auth.createUserWithEmailAndPassword(
            email: dotenv.env['DEMO_USER_EMAIL'] ?? 'demo@serenify.com',
            password: dotenv.env['DEMO_USER_PASSWORD'] ?? 'Demo@123',
          );
        } catch (createError) {
          print('Error creating demo user: $createError');
          rethrow;
        }
      }
      rethrow;
    }
  }

  // Sign in with email and password
  Future<UserCredential> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Sign in error: $e');
      rethrow;
    }
  }

  // Register with email and password
  Future<UserCredential> registerWithEmailAndPassword(String email, String password, String name) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Create user in Firestore
      if (userCredential.user != null) {
        await _createUserInFirestore(userCredential.user!.uid, email, name);
      }
      
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('Failed to register user: ${e.message}');
      }
      rethrow;
    }
  }

  // Create user in Firestore
  Future<void> _createUserInFirestore(String uid, String email, String name) async {
    try {
      final UserModel user = UserModel(
        id: uid,
        email: email,
        name: name,
        createdAt: DateTime.now(),
        completedAssessments: [],
        preferences: {
          'notifications': true,
          'darkMode': false,
          'reminders': true,
        },
      );
      
      await _usersCollection.doc(uid).set(user.toMap());
    } catch (e) {
      if (kDebugMode) {
        print('Error creating user in Firestore: $e');
      }
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Sign out error: $e');
      rethrow;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      if (kDebugMode) {
        print('Error resetting password: $e');
      }
      rethrow;
    }
  }

  // Get user data from Firestore
  Future<UserModel?> getUserData(String uid) async {
    try {
      final DocumentSnapshot doc = await _usersCollection.doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user data: $e');
      }
      rethrow;
    }
  }

  // Update user data
  Future<void> updateUserData(UserModel user) async {
    try {
      await _usersCollection.doc(user.id).update(user.toMap());
    } catch (e) {
      if (kDebugMode) {
        print('Error updating user data: $e');
      }
      rethrow;
    }
  }

  // Update user profile picture
  Future<String?> updateProfilePicture(String uid, String imagePath) async {
    try {
      final String fileName = '${uid}_${const Uuid().v4()}';
      final ref = FirebaseService.getStorageReference('profile_pictures/$fileName');
      
      // Upload image
      await ref.putFile(File(imagePath));
      
      // Get download URL
      final String downloadUrl = await ref.getDownloadURL();
      
      // Update user document
      await _usersCollection.doc(uid).update({
        'profilePicture': downloadUrl,
      });
      
      return downloadUrl;
    } catch (e) {
      if (kDebugMode) {
        print('Error updating profile picture: $e');
      }
      return null;
    }
  }

  // Update user preferences
  Future<void> updateUserPreferences(String uid, Map<String, dynamic> preferences) async {
    try {
      await _usersCollection.doc(uid).update({
        'preferences': preferences,
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error updating user preferences: $e');
      }
      rethrow;
    }
  }

  // Add completed assessment
  Future<void> addCompletedAssessment(String uid, String assessmentId) async {
    try {
      await _usersCollection.doc(uid).update({
        'completedAssessments': FieldValue.arrayUnion([assessmentId]),
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error adding completed assessment: $e');
      }
      rethrow;
    }
  }
} 