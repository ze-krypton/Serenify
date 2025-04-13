class DemoConfig {
  // Firebase Configuration
  static const String firebaseProjectId = 'serenify-demo';
  static const String firebaseApiKey = 'demo-api-key';
  static const String firebaseAppId = 'demo-app-id';
  static const String firebaseMessagingSenderId = 'demo-sender-id';
  static const String firebaseStorageBucket = 'serenify-demo.appspot.com';

  // Dialogflow Configuration
  static const String dialogflowProjectId = 'serenify-demo-agent';
  static const String dialogflowApiKey = 'demo-dialogflow-key';

  // Demo User Credentials
  static const String demoEmail = 'demo@serenify.com';
  static const String demoPassword = 'Demo@123';

  // Feature Flags
  static const bool enableAnalytics = false;
  static const bool enableCrashlytics = false;
  static const bool enablePushNotifications = false;

  // API Endpoints
  static const String baseUrl = 'https://demo-api.serenify.com';
  static const String resourcesEndpoint = '$baseUrl/resources';
  static const String exercisesEndpoint = '$baseUrl/exercises';
} 