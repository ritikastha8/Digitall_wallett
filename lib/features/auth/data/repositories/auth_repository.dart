import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:digital_wallett_system/core/api/api_client.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/core/services/connectivity/network_info.dart';
import 'package:digital_wallett_system/features/auth/data/datasources/auth_datasource.dart';
import 'package:digital_wallett_system/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:digital_wallett_system/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:digital_wallett_system/features/auth/data/models/auth_api_model.dart';
import 'package:digital_wallett_system/features/auth/data/models/auth_hive_model.dart';
import 'package:digital_wallett_system/features/auth/domain/entities/auth_entity.dart';
import 'package:digital_wallett_system/features/auth/domain/repositories/auth_repository.dart';

// ================= PROVIDER =================
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final authLocalDatasource = ref.read(authLocalDatasourceProvider);
  final authRemoteDatasource = ref.read(authRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  final apiClient = ref.read(apiClientProvider);

  return AuthRepository(
    authLocalDatasource: authLocalDatasource,
    authRemoteDatasource: authRemoteDatasource,
    networkInfo: networkInfo,
    apiClient: apiClient,
  );
});

// ================= REPOSITORY =================
class AuthRepository implements IAuthRepository {
  final IAuthLocalDatasource _authLocalDatasource;
  final IAuthRemoteDataSource _authRemoteDatasource;
  final NetworkInfo _networkInfo;
  final ApiClient _apiClient;

  AuthRepository({
    required IAuthLocalDatasource authLocalDatasource,
    required IAuthRemoteDataSource authRemoteDatasource,
    required NetworkInfo networkInfo,
    required ApiClient apiClient,
  }) : _authLocalDatasource = authLocalDatasource,
       _authRemoteDatasource = authRemoteDatasource,
       _networkInfo = networkInfo,
       _apiClient = apiClient;

  Future<Either<Failure, AuthEntity>> _tryLocalLogin(
    String mobileNumber,
    String password, {
    String? failureMessage,
  }) async {
    final model = await _authLocalDatasource.login(mobileNumber, password);
    if (model != null) {
      return Right(model.toEntity());
    }
    return Left(
      LocalDatabaseFailure(
        message: failureMessage ?? "Invalid mobile number or password",
      ),
    );
  }

  @override
  Future<Either<Failure, bool>> register(AuthEntity user) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = AuthApiModel.fromEntity(user);
        await _authRemoteDatasource.register(apiModel);
        return const Right(true);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'Registration failed',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final existingUser = await _authLocalDatasource.getUserByMobileNumber(
          user.mobileNumber,
        );
        if (existingUser != null) {
          return const Left(
            LocalDatabaseFailure(message: "Mobile number already exists"),
          );
        }

        final authModel = AuthHiveModel(
          authId: user.authId,
          fullName: user.fullName,
          mobileNumber: user.mobileNumber,
          email: user.email,
          password: user.password,
          confirmPassword: user.confirmPassword,
          profilePicture: user.profilePicture,
        );
        await _authLocalDatasource.register(authModel);
        return const Right(true);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> login(
    String mobileNumber,
    String password,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = await _authRemoteDatasource.login(
          mobileNumber,
          password,
        );
        if (apiModel != null) {
          // Keep password in local cache for offline login.
          final authHiveModel = AuthHiveModel(
            authId: apiModel.id,
            fullName: apiModel.fullName,
            mobileNumber: apiModel.mobileNumber,
            email: apiModel.email,
            password: password,
            confirmPassword: password,
            profilePicture: apiModel.profilePicture,
          );
          await _authLocalDatasource.register(authHiveModel);
          return Right(apiModel.toEntity());
        }
        return _tryLocalLogin(
          mobileNumber,
          password,
          failureMessage: "Invalid credentials",
        );
      } on DioException catch (e) {
        if (e.type == DioExceptionType.connectionError ||
            e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          return _tryLocalLogin(
            mobileNumber,
            password,
            failureMessage: "No internet connection for login",
          );
        }
        return Left(
          ApiFailure(
            message: e.response?.data is Map
                ? (e.response?.data['message'] ?? 'Login failed')
                : (e.message ?? 'Login failed'),
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        return _tryLocalLogin(mobileNumber, password);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() async {
    try {
      final model = await _authLocalDatasource.getCurrentUser();
      if (model != null) {
        return Right(model.toEntity());
      }
      return const Left(LocalDatabaseFailure(message: "No user logged in"));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      await _apiClient.clearToken();
      await _authLocalDatasource.logout();
      return const Right(true);
    } catch (e) {
      return Left(
        LocalDatabaseFailure(message: "Logout failed:${e.toString()}"),
      );
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> getUserByMobileNumber(
    String mobileNumber,
  ) async {
    try {
      final model = await _authLocalDatasource.getUserByMobileNumber(
        mobileNumber,
      );
      if (model != null) {
        return Right(model.toEntity());
      }
      return const Left(LocalDatabaseFailure(message: "Locally No user found"));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setPin(String pin, String confirmPin) async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        ApiFailure(message: 'No internet connection'),
      );
    }
    try {
      await _authRemoteDatasource.setPin(pin, confirmPin);
      return const Right(null);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Failed to set PIN',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
