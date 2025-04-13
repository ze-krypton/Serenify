import 'dart:io';
import 'package:path/path.dart' as path;

class DocumentationGenerator {
  static Future<void> generateDocumentation() async {
    final docsDir = Directory('docs');
    if (!docsDir.existsSync()) {
      docsDir.createSync();
    }

    await _generateAPIDocumentation();
    await _generateUserGuide();
    await _generateSetupGuide();
  }

  static Future<void> _generateAPIDocumentation() async {
    final apiDocs = File('docs/api.md');
    final content = '''
# API Documentation

## Authentication
- `AuthProvider`: Handles user authentication and session management
- `SecurityService`: Manages secure storage and biometric authentication

## Analytics
- `AnalyticsService`: Tracks user behavior and app performance
- `ErrorHandler`: Manages error reporting and user feedback

## Localization
- `LocalizationService`: Handles internationalization and localization
- Supports multiple languages and RTL layouts

## Performance
- `PerformanceUtils`: Optimizes app performance and resource usage
- Implements lazy loading and caching strategies

## UI Components
- `AnimationUtils`: Provides smooth transitions and animations
- `AccessibilityUtils`: Ensures app accessibility compliance

## Data Management
- `FirebaseService`: Manages cloud data storage and synchronization
- `LocalStorageService`: Handles local data persistence

## Utilities
- `ErrorHandler`: Provides consistent error handling
- `DocumentationGenerator`: Generates documentation
''';

    await apiDocs.writeAsString(content);
  }

  static Future<void> _generateUserGuide() async {
    final userGuide = File('docs/user_guide.md');
    final content = '''
# User Guide

## Getting Started
1. Download and install the app
2. Create an account or sign in
3. Complete the initial assessment

## Features
### Mood Tracking
- Track your daily mood
- View mood statistics and trends
- Set mood tracking reminders

### Chatbot
- Get instant support
- Access mental health resources
- Receive personalized recommendations

### Exercises
- Practice mindfulness exercises
- Follow guided meditations
- Track your progress

### Resources
- Access mental health articles
- Find professional help
- Join support communities

### Emergency Support
- Quick access to emergency contacts
- Crisis resources
- Safety planning tools

## Settings
- Language preferences
- Notification settings
- Privacy controls
- Theme customization
''';

    await userGuide.writeAsString(content);
  }

  static Future<void> _generateSetupGuide() async {
    final setupGuide = File('docs/setup_guide.md');
    final content = '''
# Setup Guide

## Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / Xcode
- Firebase account

## Installation
1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Configure Firebase:
   - Add google-services.json (Android)
   - Add GoogleService-Info.plist (iOS)
4. Set up environment variables:
   - Create .env file
   - Add required API keys

## Building
### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## Testing
```bash
flutter test
flutter test integration_test
```

## Deployment
1. Update version numbers
2. Generate release builds
3. Submit to app stores

## Troubleshooting
- Check Firebase configuration
- Verify environment variables
- Clear Flutter cache if needed
''';

    await setupGuide.writeAsString(content);
  }

  static Future<void> generateCodeComments() async {
    final libDir = Directory('lib');
    await _processDirectory(libDir);
  }

  static Future<void> _processDirectory(Directory dir) async {
    await for (final entity in dir.list()) {
      if (entity is File && entity.path.endsWith('.dart')) {
        await _processFile(entity);
      } else if (entity is Directory) {
        await _processDirectory(entity);
      }
    }
  }

  static Future<void> _processFile(File file) async {
    final content = await file.readAsString();
    final lines = content.split('\n');
    final newLines = <String>[];

    for (final line in lines) {
      if (line.trim().startsWith('class ') || line.trim().startsWith('enum ')) {
        final className = line.trim().split(' ')[1].split('{')[0];
        newLines.add('/// $className documentation');
        newLines.add('///');
        newLines.add('/// This class provides functionality for...');
        newLines.add(line);
      } else if (line.trim().startsWith('Future<') || line.trim().startsWith('void ')) {
        final methodName = line.trim().split('(')[0].split(' ').last;
        newLines.add('  /// $methodName documentation');
        newLines.add('  ///');
        newLines.add('  /// This method...');
        newLines.add(line);
      } else {
        newLines.add(line);
      }
    }

    await file.writeAsString(newLines.join('\n'));
  }
} 