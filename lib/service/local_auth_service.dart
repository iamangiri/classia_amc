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

  // Authenticate user using fingerprint or PIN
  Future<bool> authenticate() async {
    if (isLockedOut()) {
      print("Locked out. Try again in ${getRemainingLockTime()} seconds.");
      return false;
    }

    bool isBiometricAvailable = await this.isBiometricAvailable();
    if (!isBiometricAvailable) {
      print("Biometric authentication not available.");
      return false;
    }

    try {
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
      print("Error during authentication: ${e.message}");
      if (e.code == "LockedOut" || e.code == "PermanentlyLockedOut") {
        _setLock();
      }
      return false;
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
}
