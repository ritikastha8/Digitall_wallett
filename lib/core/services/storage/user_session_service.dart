// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:shared_preferences/shared_preferences.dart';

// // final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
// //   throw UnimplementedError();
// // });

// // final userSessionServiceProvider = Provider<UserSessionService>((ref) {
// //   return UserSessionService(ref.read(sharedPreferencesProvider));
// // });

// // class UserSessionService {
// //   final SharedPreferences _prefs;

// //   static const _keyUserId = 'user_id';
// //   static const _keyMobileNumber = 'mobile_number';
// //   static const _keyFullName = 'full_name';

// //   UserSessionService(this._prefs);

// //   Future<void> saveUserSession({
// //     required String userId,
// //     required String mobileNumber,
// //     required String fullName,
// //   }) async {
// //     await _prefs.setString(_keyUserId, userId);
// //     await _prefs.setString(_keyMobileNumber, mobileNumber);
// //     await _prefs.setString(_keyFullName, fullName);
// //   }

// //   String? get userId => _prefs.getString(_keyUserId);
// //   String? get mobileNumber => _prefs.getString(_keyMobileNumber);
// //   String? get fullName => _prefs.getString(_keyFullName);

// //   Future<void> clearSession() async {
// //     await _prefs.clear();
// //   }
// // }

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// // SharedPreferences instance provider
// final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
//   throw UnimplementedError('SharedPreferences must be overridden in main.dart');
// });

// // UserSessionService provider
// final userSessionServiceProvider = Provider<UserSessionService>((ref) {
//   final prefs = ref.read(sharedPreferencesProvider);
//   return UserSessionService(prefs: prefs);
// });

// class UserSessionService {
//   final SharedPreferences _prefs;

//   // Keys for storing user data
//   static const String _keyIsLoggedIn = 'is_logged_in';
//   static const String _keyUserId = 'user_id';
//   static const String _keyUserFullName = 'user_full_name';
//   static const String _keyUserMobileNumber = 'user_mobile_number';
//   static const String _keyUserProfilePicture = 'user_profile_picture';
//   // static const String _keyWalletBalance = 'wallet_balance';

//   UserSessionService({required SharedPreferences prefs}) : _prefs = prefs;

//   // Save user session after login/signup
//   Future<void> saveUserSession({
//     required String userId,
//     required String fullName,
//     required String mobileNumber,
//     String? profilePicture,
//     // double? walletBalance,
//   }) async {
//     await _prefs.setBool(_keyIsLoggedIn, true);
//     await _prefs.setString(_keyUserId, userId);
//     await _prefs.setString(_keyUserFullName, fullName);
//     await _prefs.setString(_keyUserMobileNumber, mobileNumber);
//     if (profilePicture != null) {
//       await _prefs.setString(_keyUserProfilePicture, profilePicture);
//     }
//     // if (walletBalance != null) {
//     //   await _prefs.setDouble(_keyWalletBalance, walletBalance);
//     // }
//   }

//   // Check if user is logged in
//   bool isLoggedIn() => _prefs.getBool(_keyIsLoggedIn) ?? false;

//   // Get current user info
//   String? getCurrentUserId() => _prefs.getString(_keyUserId);
//   String? getCurrentUserFullName() => _prefs.getString(_keyUserFullName);
//   String? getCurrentUserMobileNumber() =>
//       _prefs.getString(_keyUserMobileNumber);
//   String? getCurrentUserProfilePicture() {
//     return _prefs.getString(_keyUserProfilePicture);
//   }
//   // double getWalletBalance() => _prefs.getDouble(_keyWalletBalance) ?? 0.0;

//   // Clear session (logout)
//   Future<void> clearSession() async {
//     await _prefs.remove(_keyIsLoggedIn);
//     await _prefs.remove(_keyUserId);
//     await _prefs.remove(_keyUserFullName);
//     await _prefs.remove(_keyUserMobileNumber);
//     await _prefs.remove(_keyUserProfilePicture);
//     // await _prefs.remove(_keyWalletBalance);
//   }
// }
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
  static const String _keyWalletBalance = 'wallet_balance';
  static const String _keyUserProfilePicture = 'user_profile_picture';

  UserSessionService({required SharedPreferences prefs}) : _prefs = prefs;

  // Save user session after login/signup
  Future<void> saveUserSession({
    required String userId,
    required String fullName,
    required String mobileNumber,
    double? walletBalance,
    String? profilePicture,
  }) async {
    await _prefs.setBool(_keyIsLoggedIn, true);
    await _prefs.setString(_keyUserId, userId);
    await _prefs.setString(_keyUserFullName, fullName);
    await _prefs.setString(_keyUserMobileNumber, mobileNumber);
    if (walletBalance != null) {
      await _prefs.setDouble(_keyWalletBalance, walletBalance);
    }
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

  double getCurrentWalletBalance() {
    return _prefs.getDouble(_keyWalletBalance) ?? 0.0;
  }

  String? getCurrentUserProfilePicture() {
    return _prefs.getString(_keyUserProfilePicture);
  }

  // Clear user session (logout)
  Future<void> clearSession() async {
    await _prefs.remove(_keyIsLoggedIn);
    await _prefs.remove(_keyUserId);
    await _prefs.remove(_keyUserFullName);
    await _prefs.remove(_keyUserMobileNumber);
    await _prefs.remove(_keyWalletBalance);
    await _prefs.remove(_keyUserProfilePicture);
  }
}
