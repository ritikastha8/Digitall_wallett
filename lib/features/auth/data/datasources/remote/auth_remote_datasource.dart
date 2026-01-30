import 'package:digital_wallett_system/core/services/storage/token_service.dart';
import 'package:digital_wallett_system/features/auth/data/models/auth_api_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:digital_wallett_system/core/api/api_client.dart';
import 'package:digital_wallett_system/core/api/api_endpoints.dart';
import 'package:digital_wallett_system/core/services/storage/user_session_service.dart';
import 'package:digital_wallett_system/features/auth/data/datasources/auth_datasource.dart';

// Provider for remote auth datasource
final authRemoteDatasourceProvider = Provider<IAuthRemoteDataSource>((ref) {
  return AuthRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    userSessionService: ref.read(userSessionServiceProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

// Remote datasource implementing the interface
class AuthRemoteDatasource implements IAuthRemoteDataSource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;
  final TokenService _tokenService;

  AuthRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _userSessionService = userSessionService,
       _tokenService = tokenService;

  @override
  Future<AuthApiModel> register(AuthApiModel user) async {
    final response = await _apiClient.post(
      ApiEndpoints.register,
      data: user.toJson(),
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final registeredUser = AuthApiModel.fromJson(data);
      return registeredUser;
    }

    // Fallback
    return user;
  }

  @override
  Future<AuthApiModel?> login(String mobileNumber, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      data: {'mobileNumber': mobileNumber, 'password': password},
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final user = AuthApiModel.fromJson(data);

      // Save session after login
      await _userSessionService.saveUserSession(
        userId: user.id!,
        mobileNumber: user.mobileNumber,
        fullName: user.fullName,
      );

      // save token
      final token = response.data['token'] as String?;
      await _tokenService.saveToken(token!);

      return user;
    }

    return null;
  }

  @override
  Future<AuthApiModel?> getUserById(String authId) {
    // Implement later if needed
    throw UnimplementedError();
  }
}
