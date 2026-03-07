import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:digital_wallett_system/core/services/hive/hive_service.dart';
import 'package:digital_wallett_system/core/services/storage/user_session_service.dart';
import 'package:digital_wallett_system/features/auth/data/datasources/auth_datasource.dart';
import 'package:digital_wallett_system/features/auth/data/models/auth_hive_model.dart';

// Provider for AuthLocalDatasource
final authLocalDatasourceProvider = Provider<AuthLocalDatasource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  final userSessionService = ref.read(userSessionServiceProvider);
  return AuthLocalDatasource(
    hiveService: hiveService,
    userSessionService: userSessionService,
  );
});

class AuthLocalDatasource implements IAuthLocalDatasource {
  final HiveService _hiveService;
  final UserSessionService _userSessionService;

  AuthLocalDatasource({
    required HiveService hiveService,
    required UserSessionService userSessionService,
  }) : _hiveService = hiveService,
       _userSessionService = userSessionService;

  // ===================== Register =====================
  @override
  Future<AuthHiveModel> register(AuthHiveModel user) async {
    return await _hiveService.registerUser(user);
  }

  // ===================== Login =====================
  @override
  Future<AuthHiveModel?> login(String mobileNumber, String password) async {
    try {
      final user = _hiveService.loginUser(mobileNumber, password);
      if (user != null && user.authId != null) {
        // Save session
        await _userSessionService.saveUserSession(
          userId: user.authId!,
          fullName: user.fullName,
          mobileNumber: user.mobileNumber,
          email: user.email,
          token: 'offlinetoken',
          profilePicture: user.profilePicture,
          // Add more fields if needed
        );
      }
      return user;
    } catch (e) {
      return null;
    }
  }

  // ===================== Current User =====================
  @override
  Future<AuthHiveModel?> getCurrentUser() async {
    try {
      if (!_userSessionService.isLoggedIn()) return null;

      final userId = _userSessionService.getCurrentUserId();
      if (userId == null) return null;

      return _hiveService.getUserById(userId);
    } catch (e) {
      return null;
    }
  }

  // ===================== Logout =====================
  @override
  Future<bool> logout() async {
    try {
      await _userSessionService.clearSession();
      return true;
    } catch (e) {
      return false;
    }
  }

  // ===================== Get User =====================
  @override
  Future<AuthHiveModel?> getUserById(String authId) async {
    try {
      return _hiveService.getUserById(authId);
    } catch (e) {
      return null;
    }
  }

  // ===================== Update/Delete =====================
  @override
  Future<bool> updateUser(AuthHiveModel user) async {
    try {
      return await _hiveService.updateUser(user);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteUser(String authId) async {
    try {
      await _hiveService.deleteUser(authId);
      return true;
    } catch (e) {
      return false;
    }
  }

  // ===================== Check uniqueness =====================

  @override
  Future<AuthHiveModel?> getUserByMobileNumber(String mobileNumber) async {
    try {
      return _hiveService.getUserByMobile(mobileNumber);
    } catch (e) {
      return null;
    }
  }
}
