import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mind_mate/services/analytics_service.dart';

class SecurityService {
  static final _secureStorage = const FlutterSecureStorage();
  static final _localAuth = LocalAuthentication();

  static Future<bool> authenticateWithBiometrics() async {
    try {
      final canAuthenticate = await _localAuth.canCheckBiometrics;
      if (!canAuthenticate) return false;

      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to access your data',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (didAuthenticate) {
        await AnalyticsService.logEvent(
          name: 'biometric_authentication_success',
        );
      } else {
        await AnalyticsService.logEvent(
          name: 'biometric_authentication_failed',
        );
      }

      return didAuthenticate;
    } catch (e) {
      await AnalyticsService.logError(
        error: e,
        reason: 'Biometric authentication failed',
      );
      return false;
    }
  }

  static Future<void> storeSecureData(String key, String value) async {
    try {
      await _secureStorage.write(key: key, value: value);
    } catch (e) {
      await AnalyticsService.logError(
        error: e,
        reason: 'Failed to store secure data',
      );
      rethrow;
    }
  }

  static Future<String?> getSecureData(String key) async {
    try {
      return await _secureStorage.read(key: key);
    } catch (e) {
      await AnalyticsService.logError(
        error: e,
        reason: 'Failed to retrieve secure data',
      );
      return null;
    }
  }

  static Future<void> deleteSecureData(String key) async {
    try {
      await _secureStorage.delete(key: key);
    } catch (e) {
      await AnalyticsService.logError(
        error: e,
        reason: 'Failed to delete secure data',
      );
      rethrow;
    }
  }

  static Future<void> clearAllSecureData() async {
    try {
      await _secureStorage.deleteAll();
    } catch (e) {
      await AnalyticsService.logError(
        error: e,
        reason: 'Failed to clear secure data',
      );
      rethrow;
    }
  }

  static Future<bool> isBiometricAvailable() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (e) {
      await AnalyticsService.logError(
        error: e,
        reason: 'Failed to check biometric availability',
      );
      return false;
    }
  }

  static Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      await AnalyticsService.logError(
        error: e,
        reason: 'Failed to get available biometrics',
      );
      return [];
    }
  }
} 