import 'package:digital_wallett_system/features/auth/data/models/auth_hive_model.dart';

abstract interface class IAuthDatasource {
  Future<bool> register(AuthHiveModel model);
  Future<AuthHiveModel?> login(String mobileNumber, String password);
  Future<AuthHiveModel?> getCurrentUser(String authId);
  Future<bool> logout();

  // Check if username exists
  Future<bool> isUsernameExists(String username);

  // Check if mobile number exists
  Future<bool> isMobileNumberExists(String mobileNumber);
}
