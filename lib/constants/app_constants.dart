class AppConstants {
  // App Info
  static const String appName = 'Serenify';
  static const String appDescription = 'Your mental wellness companion';
  static const String appVersion = '1.0.0';
  
  // API Keys and Endpoints
  static const String dialogflowProjectId = 'YOUR_DIALOGFLOW_PROJECT_ID';
  
  // Shared Preferences Keys
  static const String userPrefKey = 'user_data';
  static const String themePrefKey = 'app_theme';
  static const String themePreferenceKey = 'app_theme_mode';
  static const String onboardingCompletedKey = 'onboarding_completed';
  
  // Routes
  static const String splashRoute = '/';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String homeRoute = '/home';
  static const String profileRoute = '/profile';
  static const String assessmentRoute = '/assessment';
  static const String chatbotRoute = '/chatbot';
  static const String resourcesRoute = '/resources';
  static const String moodTrackerRoute = '/mood_tracker';
  static const String moodStatsRoute = '/mood_stats';
  static const String exercisesRoute = '/exercises';
  static const String emergencyRoute = '/emergency';
  
  // Crisis Helplines
  static const Map<String, String> emergencyContacts = {
    'National Suicide Prevention Lifeline': '1-800-273-8255',
    'Crisis Text Line': 'Text HOME to 741741',
    'National Domestic Violence Hotline': '1-800-799-7233',
    'SAMHSA\'s National Helpline': '1-800-662-4357',
  };
  
  // Assessment Types
  static const String anxietyAssessment = 'anxiety';
  static const String depressionAssessment = 'depression';
  static const String stressAssessment = 'stress';
  static const String attentionAssessment = 'attention';
  
  // Resource Categories
  static const List<String> resourceCategories = [
    'Anxiety',
    'Depression',
    'Stress Management',
    'Relationships',
    'Self-Esteem',
    'Academic Success',
    'Mindfulness',
  ];
  
  // Timeout Durations
  static const int apiTimeoutSeconds = 30;
  static const int chatbotResponseTimeoutSeconds = 15;
  
  // Assets Paths
  static const String logoPath = 'assets/images/logo.png';
  static const String splashAnimationPath = 'assets/animations/splash_animation.json';
  static const String meditationAudioPath = 'assets/audio/meditation.mp3';
} 