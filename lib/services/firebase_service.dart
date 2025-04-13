import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:mind_mate/constants/firebase_constants.dart';

// Class to standardize service results
class ServiceResult<T> {
  final T? data;
  final String? errorMessage;
  final bool success;
  final int? errorCode;
  final Exception? exception;

  ServiceResult({
    this.data,
    this.errorMessage,
    required this.success,
    this.errorCode,
    this.exception,
  });

  // Factory constructor for successful results
  factory ServiceResult.success([T? data]) {
    return ServiceResult(success: true, data: data);
  }

  // Factory constructor for failed results
  factory ServiceResult.failure(String errorMessage, {int? errorCode, Exception? exception}) {
    return ServiceResult(
      success: false,
      errorMessage: errorMessage,
      errorCode: errorCode,
      exception: exception,
    );
  }

  // Helper method to map Firebase exceptions to user-friendly error messages
  static ServiceResult<T> handleException<T>(dynamic error) {
    String message = 'An unexpected error occurred';
    int? code;
    
    if (error is FirebaseAuthException) {
      code = error.hashCode;
      switch (error.code) {
        case 'invalid-email':
          message = 'The email address is not valid';
          break;
        case 'user-disabled':
          message = 'This user account has been disabled';
          break;
        case 'user-not-found':
          message = 'No user found with this email';
          break;
        case 'wrong-password':
          message = 'Incorrect password';
          break;
        case 'email-already-in-use':
          message = 'This email is already in use';
          break;
        case 'weak-password':
          message = 'Password is too weak';
          break;
        default:
          message = error.message ?? 'Authentication failed';
      }
    } else if (error is FirebaseException) {
      code = error.hashCode;
      message = error.message ?? 'Firebase operation failed';
    }
    
    return ServiceResult.failure(
      message, 
      errorCode: code, 
      exception: error is Exception ? error : null
    );
  }
}

class FirebaseService {
  static FirebaseAuth? _auth;
  static FirebaseFirestore? _firestore;
  static FirebaseStorage? _storage;
  static bool _initialized = false;

  // Get instances with null safety
  static FirebaseAuth get auth => _auth ?? FirebaseAuth.instance;
  static FirebaseFirestore get firestore => _firestore ?? FirebaseFirestore.instance;
  static FirebaseStorage get storage => _storage ?? FirebaseStorage.instance;
  
  // Check if Firebase is initialized
  static bool get isInitialized => _initialized;

  // Initialize Firebase
  static Future<ServiceResult<bool>> initializeFirebase() async {
    try {
      // If demo mode is forced, don't try to initialize Firebase
      if (FirebaseConstants.forceDemoMode) {
        if (kDebugMode) {
          print('Demo mode is enabled. Skipping Firebase initialization.');
        }
        _initialized = false;
        return ServiceResult.failure(
          'Firebase initialization skipped - running in demo mode.',
          exception: null
        );
      }
      
      // Use the configuration values from FirebaseConstants
      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: FirebaseConstants.apiKey,
          appId: FirebaseConstants.appId,
          messagingSenderId: FirebaseConstants.messagingSenderId,
          projectId: FirebaseConstants.projectId,
          storageBucket: FirebaseConstants.storageBucket,
          authDomain: FirebaseConstants.authDomain,
        ),
      );
      
      _auth = FirebaseAuth.instance;
      _firestore = FirebaseFirestore.instance;
      _storage = FirebaseStorage.instance;
      _initialized = true;
      
      if (kDebugMode) {
        print('Firebase initialized successfully');
        
        // Set persistence for Firestore if available
        try {
          await _firestore?.settings.persistenceEnabled;
          
          // Enable Auth persistence
          await _auth?.setPersistence(Persistence.LOCAL);
        } catch (e) {
          print('Warning: Could not set persistence settings: $e');
        }
      }
      
      return ServiceResult.success(true);
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing Firebase: $e');
        print('App will run in demo mode without Firebase connection');
      }
      _initialized = false;
      return ServiceResult.failure(
        'Failed to initialize Firebase. The app will run in demo mode.',
        exception: e is Exception ? e : null
      );
    }
  }

  // Get the current authenticated user
  static User? getCurrentUser() {
    return _auth?.currentUser;
  }

  // Check if user is signed in
  static bool isUserSignedIn() {
    return _auth?.currentUser != null;
  }

  // Get a Firestore collection reference
  static CollectionReference getCollection(String collectionPath) {
    return _firestore?.collection(collectionPath) ?? 
      FirebaseFirestore.instance.collection(collectionPath);
  }

  // Get a Firestore document reference
  static DocumentReference getDocument(String collectionPath, String documentId) {
    return _firestore?.collection(collectionPath).doc(documentId) ?? 
      FirebaseFirestore.instance.collection(collectionPath).doc(documentId);
  }

  // Get a Storage reference
  static Reference getStorageReference(String path) {
    return _storage?.ref().child(path) ?? 
      FirebaseStorage.instance.ref().child(path);
  }
  
  // Create a user account with email and password
  static Future<ServiceResult<UserCredential>> createUserWithEmailAndPassword(
    String email, 
    String password
  ) async {
    try {
      if (!_initialized) {
        return ServiceResult.failure('Firebase is not initialized');
      }
      
      final credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      return ServiceResult.success(credential);
    } catch (e) {
      return ServiceResult.handleException(e);
    }
  }
  
  // Sign in with email and password
  static Future<ServiceResult<UserCredential>> signInWithEmailAndPassword(
    String email, 
    String password
  ) async {
    try {
      if (!_initialized) {
        return ServiceResult.failure('Firebase is not initialized');
      }
      
      final credential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      return ServiceResult.success(credential);
    } catch (e) {
      return ServiceResult.handleException(e);
    }
  }
  
  // Send password reset email
  static Future<ServiceResult<void>> sendPasswordResetEmail(String email) async {
    try {
      if (!_initialized) {
        return ServiceResult.failure('Firebase is not initialized');
      }
      
      await auth.sendPasswordResetEmail(email: email);
      return ServiceResult.success();
    } catch (e) {
      return ServiceResult.handleException(e);
    }
  }
  
  // Sign out the current user
  static Future<ServiceResult<void>> signOut() async {
    try {
      if (!_initialized) {
        return ServiceResult.failure('Firebase is not initialized');
      }
      
      await auth.signOut();
      return ServiceResult.success();
    } catch (e) {
      return ServiceResult.handleException(e);
    }
  }
  
  // Add a document to a collection
  static Future<ServiceResult<DocumentReference>> addDocument(
    String collection,
    Map<String, dynamic> data
  ) async {
    try {
      if (!_initialized) {
        return ServiceResult.failure('Firebase is not initialized');
      }
      
      final docRef = await getCollection(collection).add(data);
      return ServiceResult.success(docRef);
    } catch (e) {
      return ServiceResult.handleException(e);
    }
  }
  
  // Set a document with a specific ID
  static Future<ServiceResult<void>> setDocument(
    String collection,
    String documentId,
    Map<String, dynamic> data,
    {bool merge = true}
  ) async {
    try {
      if (!_initialized) {
        return ServiceResult.failure('Firebase is not initialized');
      }
      
      await getDocument(collection, documentId).set(data, SetOptions(merge: merge));
      return ServiceResult.success();
    } catch (e) {
      return ServiceResult.handleException(e);
    }
  }
  
  // Update a document
  static Future<ServiceResult<void>> updateDocument(
    String collection,
    String documentId,
    Map<String, dynamic> data
  ) async {
    try {
      if (!_initialized) {
        return ServiceResult.failure('Firebase is not initialized');
      }
      
      await getDocument(collection, documentId).update(data);
      return ServiceResult.success();
    } catch (e) {
      return ServiceResult.handleException(e);
    }
  }
  
  // Delete a document
  static Future<ServiceResult<void>> deleteDocument(
    String collection,
    String documentId
  ) async {
    try {
      if (!_initialized) {
        return ServiceResult.failure('Firebase is not initialized');
      }
      
      await getDocument(collection, documentId).delete();
      return ServiceResult.success();
    } catch (e) {
      return ServiceResult.handleException(e);
    }
  }
  
  // Get a document
  static Future<ServiceResult<DocumentSnapshot>> getDocumentById(
    String collection,
    String documentId
  ) async {
    try {
      if (!_initialized) {
        return ServiceResult.failure('Firebase is not initialized');
      }
      
      final docSnapshot = await getDocument(collection, documentId).get();
      return ServiceResult.success(docSnapshot);
    } catch (e) {
      return ServiceResult.handleException(e);
    }
  }
} 