#!/bin/bash

# Set environment variables for demo
export FLAVOR=demo
export APP_NAME="Serenify Demo"
export APP_SUFFIX=.demo

# Clean and get dependencies
flutter clean
flutter pub get

# Determine platform
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS - iOS
    flutter run --flavor demo -t lib/main_demo.dart
else
    # Linux/Windows - Android
    flutter run --flavor demo -t lib/main_demo.dart
fi 