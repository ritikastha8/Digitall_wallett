import 'package:digital_wallett_system/features/auth/data/models/auth_api_model.dart';
import 'package:digital_wallett_system/features/auth/data/models/auth_hive_model.dart';

abstract interface class IAuthLocalDatasource {
  Future<AuthHiveModel> register(AuthHiveModel user);
  Future<AuthHiveModel?> login(String mobileNumber, String password);
  Future<AuthHiveModel?> getCurrentUser();
  Future<bool> logout();

  Future<AuthHiveModel?> getUserById(String authId);
  Future<AuthHiveModel?> getUserByMobileNumber(String mobileNumber);
  Future<bool> updateUser(AuthHiveModel user);
  Future<bool> deleteUser(String authId);

  // // Check if username exists
  // Future<bool> isUsernameExists(String username);

  // // Check if mobile number exists
  // Future<bool> isMobileNumberExists(String mobileNumber);
}

abstract interface class IAuthRemoteDataSource {
  Future<AuthApiModel> register(AuthApiModel user);
  Future<AuthApiModel?> login(String mobileNumber, String password);
  Future<AuthApiModel?> getUserById(String authId);
  Future<void> requestPasswordReset(String email);
  Future<void> resetPassword(String token, String newPassword);
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
    String confirmPassword,
  );
  Future<void> setPin(String pin, String confirmPin);
}
