// Firebase configuration constants
class FirebaseConstants {
  // Firebase Auth and Firestore collections
  static const String usersCollection = 'users';
  static const String assessmentsCollection = 'assessments';
  static const String resourcesCollection = 'resources';
  static const String moodEntriesCollection = 'mood_entries';
  static const String chatSessionsCollection = 'chat_sessions';
  static const String chatMessagesCollection = 'chat_messages';
  static const String exercisesCollection = 'exercises';
  
  // IMPORTANT: Replace these with your actual Firebase project values
  // You can find these in your Firebase Console -> Project Settings -> Web App
  static const String apiKey = 'AIzaSyDemoKeyForTestingPurposesOnly'; // ← Replace with actual API key
  static const String appId = '1:123456789012:web:demo123456789';     // ← Replace with actual App ID
  static const String messagingSenderId = '123456789012';            // ← Replace with actual Sender ID
  static const String projectId = 'serenify-demo';                  // ← Replace with actual Project ID
  static const String storageBucket = 'serenify-demo.appspot.com';  // ← Replace with actual Storage Bucket
  static const String authDomain = 'serenify-demo.firebaseapp.com'; // ← Replace with actual Auth Domain
  
  // Demo mode flag - set to true if you want to force demo mode without Firebase
  static const bool forceDemoMode = true; // Change to true if you want to use demo mode instead
  
  // Storage paths (will be used later when Storage is set up)
  static const String userProfileImages = "profile_images";
  static const String resourceFiles = "resource_files";
  static const String exerciseMedia = "exercise_media";
} 