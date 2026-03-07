import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// SharedPreferences instance provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in main.dart');
});

// UserSessionService provider
final userSessionServiceProvider = Provider<UserSessionService>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  return UserSessionService(prefs: prefs);
});

class UserSessionService {
  final SharedPreferences _prefs;

  // Keys for storing user data
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserId = 'user_id';
  static const String _keyUserFullName = 'user_full_name';
  static const String _keyUserMobileNumber = 'user_mobile_number';
  static const String _keyUserEmail = 'user_email';
  static const String _keyWalletBalance = 'wallet_balance';
  static const String _keyUserProfilePicture = 'user_profile_picture';
  static const String _keyAuthToken = 'auth_token';
  static const String _keyHasSeenOnboarding = 'has_seen_onboarding';
  UserSessionService({required SharedPreferences prefs}) : _prefs = prefs;

  bool getHasSeenOnboarding() => _prefs.getBool(_keyHasSeenOnboarding) ?? false;
  Future<void> setHasSeenOnboarding(bool value) async {
    await _prefs.setBool(_keyHasSeenOnboarding, value);
  }

  // Save user session after login/signup
  Future<void> saveUserSession({
    required String userId,
    required String fullName,
    required String mobileNumber,
    required String email,
    required String token,
    double? walletBalance,
    String? profilePicture,
  }) async {
    await _prefs.setBool(_keyIsLoggedIn, true);
    await _prefs.setString(_keyUserId, userId);
    await _prefs.setString(_keyUserFullName, fullName);
    await _prefs.setString(_keyUserMobileNumber, mobileNumber);
    await _prefs.setString(_keyUserEmail, email);
    await _prefs.setString(_keyAuthToken, token);
    if (walletBalance != null) {
      await _prefs.setDouble(_keyWalletBalance, walletBalance);
    }
    if (profilePicture != null) {
      await _prefs.setString(_keyUserProfilePicture, profilePicture);
    }
  }

  Future<void> updateeProfile({
    required String fullName,
    required String mobileNumber,
    String? profilePicture,
  }) async {
    await _prefs.setString(_keyUserFullName, fullName);
    await _prefs.setString(_keyUserMobileNumber, mobileNumber);
    if (profilePicture != null) {
      await _prefs.setString(_keyUserProfilePicture, profilePicture);
    }
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return _prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Getters for user data
  String? getCurrentUserId() {
    return _prefs.getString(_keyUserId);
  }

  String? getCurrentUserFullName() {
    return _prefs.getString(_keyUserFullName);
  }

  String? getCurrentUserMobileNumber() {
    return _prefs.getString(_keyUserMobileNumber);
  }

  String? getCurrentUserEmail() {
    return _prefs.getString(_keyUserEmail);
  }

  double getCurrentWalletBalance() {
    return _prefs.getDouble(_keyWalletBalance) ?? 0.0;
  }

  String? getCurrentUserProfilePicture() {
    return _prefs.getString(_keyUserProfilePicture);
  }

  String? getToken() {
    return _prefs.getString(_keyAuthToken);
  }

  // Clear user session (logout)
  Future<void> clearSession() async {
    await _prefs.remove(_keyIsLoggedIn);
    await _prefs.remove(_keyUserId);
    await _prefs.remove(_keyUserFullName);
    await _prefs.remove(_keyUserMobileNumber);
    await _prefs.remove(_keyUserEmail);
    await _prefs.remove(_keyWalletBalance);
    await _prefs.remove(_keyUserProfilePicture);
    await _prefs.remove(_keyAuthToken);
  }
}
