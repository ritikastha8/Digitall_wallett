import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  return AuthRepository(
    authLocalDatasource: authLocalDatasource,
    authRemoteDatasource: authRemoteDatasource,
    networkInfo: networkInfo,
  );
});

// ================= REPOSITORY =================
class AuthRepository implements IAuthRepository {
  final IAuthLocalDatasource _authLocalDatasource;
  final IAuthRemoteDataSource _authRemoteDatasource;
  final NetworkInfo _networkInfo;

  AuthRepository({
    required IAuthLocalDatasource authLocalDatasource,
    required IAuthRemoteDataSource authRemoteDatasource,
    required NetworkInfo networkInfo,
  }) : _authLocalDatasource = authLocalDatasource,
       _authRemoteDatasource = authRemoteDatasource,
       _networkInfo = networkInfo;

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
          fullName: user.fullName,
          mobileNumber: user.mobileNumber,
          password: user.password,
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
          return Right(apiModel.toEntity());
        }
        return const Left(ApiFailure(message: "Invalid credentials"));
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'Login failed',
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final model = await _authLocalDatasource.login(mobileNumber, password);
        if (model != null) {
          return Right(model.toEntity());
        }
        return const Left(
          LocalDatabaseFailure(message: "Invalid mobile number or password"),
        );
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
      final result = await _authLocalDatasource.logout();
      if (result) {
        return const Right(true);
      }
      return const Left(LocalDatabaseFailure(message: "Failed to logout"));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
