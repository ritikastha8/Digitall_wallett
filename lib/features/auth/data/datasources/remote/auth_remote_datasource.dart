import 'package:digital_wallett_system/features/auth/data/models/auth_api_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:digital_wallett_system/core/api/api_client.dart';
import 'package:digital_wallett_system/core/api/api_endpoints.dart';
import 'package:digital_wallett_system/core/services/storage/user_session_service.dart';
import 'package:digital_wallett_system/features/auth/data/datasources/auth_datasource.dart';
import 'package:dio/dio.dart';

// Provider for remote auth datasource
final authRemoteDatasourceProvider = Provider<IAuthRemoteDataSource>((ref) {
  return AuthRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    userSessionService: ref.read(userSessionServiceProvider),
  );
});

// Remote datasource implementing the interface
class AuthRemoteDatasource implements IAuthRemoteDataSource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;

  AuthRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
  }) : _apiClient = apiClient,
       _userSessionService = userSessionService;

  @override
  Future<AuthApiModel> register(AuthApiModel user) async {
    final response = await _apiClient.post(
      ApiEndpoints.register,
      data: user.toJson(),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = response.data.containsKey('data')
          ? response.data['data'] as Map<String, dynamic>
          : response.data as Map<String, dynamic>;
      return AuthApiModel.fromJson(data);
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

    if (response.statusCode == 200 && response.data['token'] != null) {
      final user = AuthApiModel.fromJson(response.data as Map<String, dynamic>);

      await _userSessionService.saveUserSession(
        userId: user.id ?? "",
        fullName: user.fullName,
        mobileNumber: user.mobileNumber,
        email: user.email,
        token: user.token ?? '',
        profilePicture: user.profilePicture,
      );

      // Save token where ApiClient's interceptor reads it (FlutterSecureStorage)
      final token = user.token ?? '';
      if (token.isNotEmpty) {
        await _apiClient.saveToken(token);
      }

      try {
        final freshUser = await getWhoami();
        if (freshUser != null) {
          await _userSessionService.updateeProfile(
            fullName: freshUser.fullName,
            mobileNumber: freshUser.mobileNumber,
            profilePicture: freshUser.profilePicture,
          );
        }
      } catch (_) {}

      return user;
    }
    return null;
  }

  @override
  Future<AuthApiModel?> getUserById(String authId) async {
    return getWhoami();
  }

  /// GET /api/user/auth/whoami, current user with Bearer token.
  Future<AuthApiModel?> getWhoami() async {
    final response = await _apiClient.get(ApiEndpoints.whoami);
    final data = response.data;
    if (data is! Map<String, dynamic>) return null;
    return AuthApiModel.fromJson(data);
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    await _apiClient.post(
      ApiEndpoints.requestPasswordReset,
      data: {'email': email},
    );
  }

  @override
  Future<void> resetPassword(String token, String newPassword) async {
    await _apiClient.post(
      ApiEndpoints.resetPassword(token),
      data: {'newPassword': newPassword},
    );
  }

  @override
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    final payload = {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    };
    final fallbackPaths = <String>[
      ApiEndpoints.changePassword,
      '/user/auth/changePassword',
      '/user/auth/update-password',
      '/user/auth/updatePassword',
    ];

    DioException? lastError;
    for (final path in fallbackPaths) {
      try {
        await _apiClient.post(path, data: payload);
        return;
      } on DioException catch (e) {
        lastError = e;
        if (e.response?.statusCode != 404) {
          rethrow;
        }
      }
    }

    throw lastError ??
        DioException(
          requestOptions: RequestOptions(path: ApiEndpoints.changePassword),
          message: 'Change password endpoint not found on server',
        );
  }

  @override
  Future<void> setPin(String pin, String confirmPin) async {
    await _apiClient.post(
      ApiEndpoints.setPin,
      data: {'pin': pin, 'confirmPin': confirmPin},
    );
  }
}
