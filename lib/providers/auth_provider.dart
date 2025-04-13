import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mind_mate/models/user_model.dart';
import 'package:mind_mate/services/firebase_service.dart';
import 'package:mind_mate/constants/firebase_constants.dart';

enum AuthStatus { initial, authenticated, unauthenticated, loading, error }

class AuthProvider extends ChangeNotifier {
  AuthStatus _status = AuthStatus.initial;
  UserModel? _user;
  String? _error;
  bool _demoMode = false;

  // Getters
  AuthStatus get status => _status;
  UserModel? get user => _user;
  String? get error => _error;
  bool get demoMode => _demoMode;

  // Constructor
  AuthProvider() {
    init();
  }

  Future<void> init() async {
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      if (!FirebaseService.isInitialized) {
        // If Firebase is not initialized, use demo mode
        _demoMode = true;
        print("Demo mode is enabled due to Firebase initialization failure");
        await Future.delayed(const Duration(milliseconds: 500)); // Add small delay for stability
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        return;
      }

      // Listen to auth state changes
      FirebaseService.auth.authStateChanges().listen((User? firebaseUser) async {
        print("Auth state changed: ${firebaseUser != null ? 'user logged in' : 'no user'}");
        if (firebaseUser == null) {
          _user = null;
          _status = AuthStatus.unauthenticated;
          notifyListeners();
        } else {
          // Fetch user data from Firestore
          try {
            final userDoc = await FirebaseService.getDocument(
              FirebaseConstants.usersCollection,
              firebaseUser.uid,
            ).get();

            if (userDoc.exists) {
              final userData = userDoc.data() as Map<String, dynamic>;
              _user = UserModel.fromMap(userData);
            } else {
              // Create basic user if document doesn't exist
              _user = UserModel(
                id: firebaseUser.uid,
                name: firebaseUser.displayName ?? 'User',
                email: firebaseUser.email ?? '',
                profilePicture: firebaseUser.photoURL,
                createdAt: DateTime.now(),
              );
              
              // Save to Firestore
              await FirebaseService.getDocument(
                FirebaseConstants.usersCollection,
                firebaseUser.uid,
              ).set(_user!.toMap());
            }
            
            _status = AuthStatus.authenticated;
          } catch (e) {
            _error = 'Failed to load user data: $e';
            _status = AuthStatus.error;
          }
        }
        notifyListeners();
      });
    } catch (e) {
      _error = e.toString();
      _status = AuthStatus.error;
      notifyListeners();
    }
  }

  // Sign in with email and password
  Future<bool> signIn(String email, String password) async {
    try {
      _status = AuthStatus.loading;
      _error = null;
      notifyListeners();

      // Enable demo mode explicitly
      _demoMode = true;

      if (_demoMode) {
        // Simulate login in demo mode
        await Future.delayed(Duration(seconds: 1));
        if (email.toLowerCase() == 'demo@serenify.com' && password == 'Demo@123') {
          _user = UserModel(
            id: 'demo-user-123',
            name: 'Demo User',
            email: 'demo@serenify.com',
            profilePicture: null,
            preferences: {
              'theme': 'system',
              'notifications': true,
            },
            createdAt: DateTime.now(),
          );
          _status = AuthStatus.authenticated;
          print("Demo login successful");
          notifyListeners();
          return true;
        } else {
          _error = 'Invalid credentials. Use demo@serenify.com / Demo@123';
          _status = AuthStatus.unauthenticated;
          print("Demo login failed: $_error");
          notifyListeners();
          return false;
        }
      }

      await FirebaseService.auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _getFirebaseAuthErrorMessage(e.code);
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    } catch (e) {
      _error = e.toString();
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  // Register with email and password
  Future<bool> register(String email, String password, String name) async {
    try {
      _status = AuthStatus.loading;
      _error = null;
      notifyListeners();

      if (_demoMode) {
        // Simulate registration in demo mode
        await Future.delayed(Duration(seconds: 1));
        _user = UserModel(
          id: 'demo-user-123',
          name: name,
          email: email,
          profilePicture: null,
          preferences: {
            'theme': 'system',
            'notifications': true,
          },
          createdAt: DateTime.now(),
        );
        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      }

      // Create user with email and password
      final UserCredential userCredential = await FirebaseService.auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update display name
      await userCredential.user?.updateDisplayName(name);
      
      // Create user document in Firestore
      final user = UserModel(
        id: userCredential.user!.uid,
        name: name,
        email: email,
        profilePicture: null,
        createdAt: DateTime.now(),
      );
      
      await FirebaseService.getDocument(
        FirebaseConstants.usersCollection,
        userCredential.user!.uid,
      ).set(user.toMap());
      
      _user = user;
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _getFirebaseAuthErrorMessage(e.code);
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    } catch (e) {
      _error = e.toString();
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      if (_demoMode) {
        // Simulate sign out in demo mode
        await Future.delayed(Duration(milliseconds: 500));
        _user = null;
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        return;
      }

      await FirebaseService.auth.signOut();
      _user = null;
      _status = AuthStatus.unauthenticated;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _status = AuthStatus.error;
      notifyListeners();
    }
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    try {
      _status = AuthStatus.loading;
      _error = null;
      notifyListeners();

      if (_demoMode) {
        // Simulate password reset in demo mode
        await Future.delayed(Duration(seconds: 1));
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        return true;
      }

      await FirebaseService.auth.sendPasswordResetEmail(email: email);
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _getFirebaseAuthErrorMessage(e.code);
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return false;
    } catch (e) {
      _error = e.toString();
      _status = AuthStatus.error;
      notifyListeners();
      return false;
    }
  }

  // Update profile
  Future<bool> updateProfile({String? name, String? profilePicture}) async {
    try {
      if (_user == null) return false;
      
      if (_demoMode) {
        // Simulate profile update in demo mode
        await Future.delayed(Duration(seconds: 1));
        _user = _user!.copyWith(
          name: name ?? _user!.name,
          profilePicture: profilePicture ?? _user!.profilePicture,
        );
        notifyListeners();
        return true;
      }

      // Update display name if provided
      if (name != null && name.isNotEmpty) {
        await FirebaseService.auth.currentUser?.updateDisplayName(name);
      }
      
      // Update user document in Firestore
      final updatedUser = _user!.copyWith(
        name: name ?? _user!.name,
        profilePicture: profilePicture ?? _user!.profilePicture,
      );
      
      await FirebaseService.getDocument(
        FirebaseConstants.usersCollection,
        _user!.id,
      ).update(updatedUser.toMap());
      
      _user = updatedUser;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Update user preferences
  Future<bool> updatePreferences(Map<String, dynamic> preferences) async {
    try {
      if (_user == null) return false;
      
      if (_demoMode) {
        // Simulate preferences update in demo mode
        await Future.delayed(Duration(seconds: 1));
        final Map<String, dynamic> updatedPrefs = {..._user!.preferences ?? {}, ...preferences};
        _user = _user!.copyWith(preferences: updatedPrefs);
        notifyListeners();
        return true;
      }

      // Update user preferences in Firestore
      final Map<String, dynamic> updatedPreferences = {..._user!.preferences ?? {}, ...preferences};
      
      await FirebaseService.getDocument(
        FirebaseConstants.usersCollection,
        _user!.id,
      ).update({'preferences': updatedPreferences});
      
      _user = _user!.copyWith(preferences: updatedPreferences);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Helper method to get user-friendly error messages
  String _getFirebaseAuthErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'Email is already in use.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'invalid-email':
        return 'Email address is invalid.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
} 