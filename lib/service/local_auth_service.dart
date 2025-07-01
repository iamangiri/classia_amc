import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class LocalAuthService {
  final LocalAuthentication _auth = LocalAuthentication();
  int _failedAttempts = 0;
  static const int maxAttempts = 3;
  bool _isLocked = false;
  DateTime? _lockEndTime;

  // Check if biometric authentication is available
  Future<bool> isBiometricAvailable() async {
    try {
      bool canCheckBiometrics = await _auth.canCheckBiometrics;
      bool isDeviceSupported = await _auth.isDeviceSupported();
      List<BiometricType> availableBiometrics = await _auth.getAvailableBiometrics();

      // Debug logs
      print("Biometric Available: $canCheckBiometrics");
      print("Device Supported: $isDeviceSupported");
      print("Available Biometrics: $availableBiometrics");

      return canCheckBiometrics && isDeviceSupported && availableBiometrics.isNotEmpty;
    } catch (e) {
      print("Error checking biometrics: $e");
      return false;
    }
  }

  // Get available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (e) {
      print("Error getting available biometrics: $e");
      return [];
    }
  }

  // Authenticate user using fingerprint or PIN
  Future<bool> authenticate() async {
    try {
      // Check if lockout period has expired
      if (isLockedOut()) {
        print("Locked out. Try again in ${getRemainingLockTime()} seconds.");
        return false;
      }

      // Check if biometric authentication is available
      bool isBiometricAvailable = await this.isBiometricAvailable();

      // If no biometric authentication is available, return true to skip authentication
      if (!isBiometricAvailable) {
        print("Biometric authentication not available. Skipping authentication.");
        return true;
      }

      // Double check with available biometrics
      List<BiometricType> availableBiometrics = await getAvailableBiometrics();
      if (availableBiometrics.isEmpty) {
        print("No biometric methods available. Skipping authentication.");
        return true;
      }

      bool authenticated = await _auth.authenticate(
        localizedReason: 'Authenticate to access your account',
        options: const AuthenticationOptions(
          biometricOnly: false, // Allow PIN, password, or pattern as a fallback
          useErrorDialogs: true, // Show default system error dialogs
          stickyAuth: true,
        ),
      );

      if (authenticated) {
        _failedAttempts = 0;
        return true;
      } else {
        _failedAttempts++;
        if (_failedAttempts >= maxAttempts) {
          _setLock();
        }
        return false;
      }
    } on PlatformException catch (e) {
      print("PlatformException during authentication: ${e.code} - ${e.message}");

      // Handle specific error codes
      switch (e.code) {
        case "LockedOut":
        case "PermanentlyLockedOut":
          _setLock();
          return false;

        case "BiometricOnlyNotSupported":
        case "NotAvailable":
        case "NotEnrolled":
        case "PasscodeNotSet":
          print("Biometric authentication not available or not enrolled. Skipping authentication.");
          return true;

        case "UserCancel":
        case "SystemCancel":
          print("Authentication cancelled by user or system.");
          return false;

        case "InvalidContext":
        case "BiometricBindingNotSet":
          print("Authentication context error. Skipping authentication.");
          return true;

        default:
          print("Unknown authentication error: ${e.code}. Skipping authentication.");
          return true; // Allow access for unknown errors to prevent blank screen
      }
    } catch (e) {
      print("Unexpected error during authentication: $e");
      // For any unexpected errors, allow access to prevent blank screen
      return true;
    }
  }

  // Lockout handling
  void _setLock() {
    _isLocked = true;
    _lockEndTime = DateTime.now().add(const Duration(seconds: 30));
    print("Too many failed attempts. Locked out for 30 seconds.");
  }

  bool isLockedOut() {
    if (_isLocked && _lockEndTime != null) {
      if (DateTime.now().isAfter(_lockEndTime!)) {
        _isLocked = false;
        _failedAttempts = 0;
        return false;
      }
      return true;
    }
    return false;
  }

  int getRemainingLockTime() {
    if (_lockEndTime == null) return 0;
    return _lockEndTime!.difference(DateTime.now()).inSeconds.clamp(0, 30);
  }

  // Reset authentication state
  void resetAuthState() {
    _isLocked = false;
    _failedAttempts = 0;
    _lockEndTime = null;
  }

  // Check if device has any form of security (PIN, Pattern, Password, Biometric)
  Future<bool> hasDeviceSecurity() async {
    try {
      bool canCheckBiometrics = await _auth.canCheckBiometrics;
      bool isDeviceSupported = await _auth.isDeviceSupported();
      return canCheckBiometrics || isDeviceSupported;
    } catch (e) {
      print("Error checking device security: $e");
      return false;
    }
  }
}