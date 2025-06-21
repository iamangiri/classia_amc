import 'package:shared_preferences/shared_preferences.dart';

class UserConstants {
  // Keys for SharedPreferences
  static const String AUTH_TOKEN_KEY = 'authToken';
  static const String USER_ID_KEY = 'userId';
  static const String EMAIL_KEY = 'email';
  static const String PHONE_KEY = 'phone';
  static const String NAME_KEY = 'name';
  static const String PROFILE_IMAGE_KEY = 'profileImage';
  static const String ROLE_KEY = 'role';
  static const String MAIN_BALANCE_KEY = 'mainBalance';
  static const String LAST_LOGIN_KEY = 'lastLogin';
  static const String PAN_NUMBER_KEY = 'panNumber';
  static const String ADDRESS_KEY = 'address';
  static const String CITY_KEY = 'city';
  static const String STATE_KEY = 'state';
  static const String PIN_CODE_KEY = 'pinCode';
  static const String CONTACT_PERSON_NAME_KEY = 'contactPersonName';
  static const String CONTACT_PERSON_DESIGNATION_KEY = 'contactPerDesignation';
  static const String IS_MOBILE_VERIFIED_KEY = 'isMobileVerified';
  static const String IS_EMAIL_VERIFIED_KEY = 'isEmailVerified';
  static const String IS_BLOCKED_KEY = 'isBlocked';

  // Default values
  static const String DEFAULT_NAME = '';
  static const String DEFAULT_EMAIL = 'user@classiacapital.com';
  static const String DEFAULT_PHONE = '';
  static const String DEFAULT_PROFILE_IMAGE = '';
  static const String DEFAULT_ROLE = '';
  static const double DEFAULT_MAIN_BALANCE = 0.0;
  static const String DEFAULT_LAST_LOGIN = '';
  static const String DEFAULT_PAN_NUMBER = '';
  static const String DEFAULT_ADDRESS = '';
  static const String DEFAULT_CITY = '';
  static const String DEFAULT_STATE = '';
  static const String DEFAULT_PIN_CODE = '';
  static const String DEFAULT_CONTACT_PERSON_NAME = '';
  static const String DEFAULT_CONTACT_PERSON_DESIGNATION = '';
  static const bool DEFAULT_IS_MOBILE_VERIFIED = false;
  static const bool DEFAULT_IS_EMAIL_VERIFIED = false;
  static const bool DEFAULT_IS_BLOCKED = false;

  // Static variables
  static String? TOKEN;
  static String? USER_ID;
  static String EMAIL = DEFAULT_EMAIL;
  static String PHONE = DEFAULT_PHONE;
  static String NAME = DEFAULT_NAME;
  static String PROFILE_IMAGE = DEFAULT_PROFILE_IMAGE;
  static String ROLE = DEFAULT_ROLE;
  static double MAIN_BALANCE = DEFAULT_MAIN_BALANCE;
  static String LAST_LOGIN = DEFAULT_LAST_LOGIN;
  static String PAN_NUMBER = DEFAULT_PAN_NUMBER;
  static String ADDRESS = DEFAULT_ADDRESS;
  static String CITY = DEFAULT_CITY;
  static String STATE = DEFAULT_STATE;
  static String PIN_CODE = DEFAULT_PIN_CODE;
  static String CONTACT_PERSON_NAME = DEFAULT_CONTACT_PERSON_NAME;
  static String CONTACT_PERSON_DESIGNATION = DEFAULT_CONTACT_PERSON_DESIGNATION;
  static bool IS_MOBILE_VERIFIED = DEFAULT_IS_MOBILE_VERIFIED;
  static bool IS_EMAIL_VERIFIED = DEFAULT_IS_EMAIL_VERIFIED;
  static bool IS_BLOCKED = DEFAULT_IS_BLOCKED;

  // Helper method to safely convert dynamic to double
  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  // Helper method to safely convert dynamic to bool
  static bool _toBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    if (value is int) return value == 1;
    return false;
  }

  // Load user data from SharedPreferences into static variables
  static Future<void> loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      TOKEN = prefs.getString(AUTH_TOKEN_KEY);
      USER_ID = prefs.getString(USER_ID_KEY);
      EMAIL = prefs.getString(EMAIL_KEY) ?? DEFAULT_EMAIL;
      PHONE = prefs.getString(PHONE_KEY) ?? DEFAULT_PHONE;
      NAME = prefs.getString(NAME_KEY) ?? DEFAULT_NAME;
      PROFILE_IMAGE = prefs.getString(PROFILE_IMAGE_KEY) ?? DEFAULT_PROFILE_IMAGE;
      ROLE = prefs.getString(ROLE_KEY) ?? DEFAULT_ROLE;
      MAIN_BALANCE = prefs.getDouble(MAIN_BALANCE_KEY) ?? DEFAULT_MAIN_BALANCE;
      LAST_LOGIN = prefs.getString(LAST_LOGIN_KEY) ?? DEFAULT_LAST_LOGIN;
      PAN_NUMBER = prefs.getString(PAN_NUMBER_KEY) ?? DEFAULT_PAN_NUMBER;
      ADDRESS = prefs.getString(ADDRESS_KEY) ?? DEFAULT_ADDRESS;
      CITY = prefs.getString(CITY_KEY) ?? DEFAULT_CITY;
      STATE = prefs.getString(STATE_KEY) ?? DEFAULT_STATE;
      PIN_CODE = prefs.getString(PIN_CODE_KEY) ?? DEFAULT_PIN_CODE;
      CONTACT_PERSON_NAME = prefs.getString(CONTACT_PERSON_NAME_KEY) ?? DEFAULT_CONTACT_PERSON_NAME;
      CONTACT_PERSON_DESIGNATION = prefs.getString(CONTACT_PERSON_DESIGNATION_KEY) ?? DEFAULT_CONTACT_PERSON_DESIGNATION;
      IS_MOBILE_VERIFIED = prefs.getBool(IS_MOBILE_VERIFIED_KEY) ?? DEFAULT_IS_MOBILE_VERIFIED;
      IS_EMAIL_VERIFIED = prefs.getBool(IS_EMAIL_VERIFIED_KEY) ?? DEFAULT_IS_EMAIL_VERIFIED;
      IS_BLOCKED = prefs.getBool(IS_BLOCKED_KEY) ?? DEFAULT_IS_BLOCKED;

      print('User data loaded successfully');
      print('TOKEN: $TOKEN');
      print('USER_ID: $USER_ID');
      print('NAME: $NAME');
      print('EMAIL: $EMAIL');
      print('ROLE: $ROLE');
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  // Store user data from API response to SharedPreferences
  static Future<void> storeUserData(Map<String, dynamic> userData, String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Store data in SharedPreferences with proper null checking and type conversion
      await prefs.setString(AUTH_TOKEN_KEY, token);
      await prefs.setString(USER_ID_KEY, (userData['ID'] ?? '').toString());
      await prefs.setString(EMAIL_KEY, userData['Email']?.toString() ?? DEFAULT_EMAIL);
      await prefs.setString(PHONE_KEY, userData['Mobile']?.toString() ?? DEFAULT_PHONE);
      await prefs.setString(NAME_KEY, userData['Name']?.toString() ?? DEFAULT_NAME);
      await prefs.setString(PROFILE_IMAGE_KEY, userData['ProfileImage']?.toString() ?? DEFAULT_PROFILE_IMAGE);
      await prefs.setString(ROLE_KEY, userData['Role']?.toString() ?? DEFAULT_ROLE);
      await prefs.setDouble(MAIN_BALANCE_KEY, _toDouble(userData['MainBalance']));
      await prefs.setString(LAST_LOGIN_KEY, userData['LastLogin']?.toString() ?? DEFAULT_LAST_LOGIN);
      await prefs.setString(PAN_NUMBER_KEY, userData['PanNumber']?.toString() ?? DEFAULT_PAN_NUMBER);
      await prefs.setString(ADDRESS_KEY, userData['Address']?.toString() ?? DEFAULT_ADDRESS);
      await prefs.setString(CITY_KEY, userData['City']?.toString() ?? DEFAULT_CITY);
      await prefs.setString(STATE_KEY, userData['State']?.toString() ?? DEFAULT_STATE);
      await prefs.setString(PIN_CODE_KEY, userData['PinCode']?.toString() ?? DEFAULT_PIN_CODE);
      await prefs.setString(CONTACT_PERSON_NAME_KEY, userData['ContactPersonName']?.toString() ?? DEFAULT_CONTACT_PERSON_NAME);
      await prefs.setString(CONTACT_PERSON_DESIGNATION_KEY, userData['ContactPerDesignation']?.toString() ?? DEFAULT_CONTACT_PERSON_DESIGNATION);
      await prefs.setBool(IS_MOBILE_VERIFIED_KEY, _toBool(userData['IsMobileVerified']));
      await prefs.setBool(IS_EMAIL_VERIFIED_KEY, _toBool(userData['IsEmailVerified']));
      await prefs.setBool(IS_BLOCKED_KEY, _toBool(userData['IsBlocked']));

      print('User data stored successfully in SharedPreferences');

      // Load data into static variables
      await loadUserData();
    } catch (e) {
      print('Error storing user data: $e');
      throw e; // Rethrow to handle in calling code
    }
  }

  // Clear all user data from SharedPreferences
  static Future<void> clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Reset static variables to defaults
      TOKEN = null;
      USER_ID = null;
      EMAIL = DEFAULT_EMAIL;
      PHONE = DEFAULT_PHONE;
      NAME = DEFAULT_NAME;
      PROFILE_IMAGE = DEFAULT_PROFILE_IMAGE;
      ROLE = DEFAULT_ROLE;
      MAIN_BALANCE = DEFAULT_MAIN_BALANCE;
      LAST_LOGIN = DEFAULT_LAST_LOGIN;
      PAN_NUMBER = DEFAULT_PAN_NUMBER;
      ADDRESS = DEFAULT_ADDRESS;
      CITY = DEFAULT_CITY;
      STATE = DEFAULT_STATE;
      PIN_CODE = DEFAULT_PIN_CODE;
      CONTACT_PERSON_NAME = DEFAULT_CONTACT_PERSON_NAME;
      CONTACT_PERSON_DESIGNATION = DEFAULT_CONTACT_PERSON_DESIGNATION;
      IS_MOBILE_VERIFIED = DEFAULT_IS_MOBILE_VERIFIED;
      IS_EMAIL_VERIFIED = DEFAULT_IS_EMAIL_VERIFIED;
      IS_BLOCKED = DEFAULT_IS_BLOCKED;

      print('User data cleared successfully');
    } catch (e) {
      print('Error clearing user data: $e');
    }
  }

  // Check if user is logged in
  static bool isLoggedIn() {
    return TOKEN != null && TOKEN!.isNotEmpty;
  }

  // Get user display name
  static String getDisplayName() {
    return NAME.isNotEmpty ? NAME : EMAIL;
  }
}