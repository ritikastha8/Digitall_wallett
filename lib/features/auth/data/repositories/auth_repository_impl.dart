import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/features/auth/data/datasources/auth_datasource.dart';
import 'package:digital_wallett_system/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:digital_wallett_system/features/auth/data/models/auth_hive_model.dart';
import 'package:digital_wallett_system/features/auth/domain/entities/auth_entity.dart';
import 'package:digital_wallett_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ====================== PROVIDER ======================

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepository(authDatasource: ref.read(authLocalDatasourceProvider));
});

// ====================== REPOSITORY ======================

class AuthRepository implements IAuthRepository {
  final IAuthDatasource _authDatasource;

  AuthRepository({required IAuthDatasource authDatasource})
    : _authDatasource = authDatasource;

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser(String authId) async {
    try {
      final user = await _authDatasource.getCurrentUser(authId);
      if (user != null) {
        return Right(user.toEntity());
      }
      return Left(LocalDatabaseFailure(message: "No user logged in"));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> login(
    String mobileNumber,
    String password,
  ) async {
    try {
      final user = await _authDatasource.login(mobileNumber, password);
      if (user != null) {
        return Right(user.toEntity());
      }
      return Left(
        LocalDatabaseFailure(message: "Invalid mobile number or password"),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> register(AuthEntity entity) async {
    try {
      // Check if mobile number already exists
      if (entity.mobileNumber != null) {
        final mobileExists = await _authDatasource.isMobileNumberExists(
          entity.mobileNumber!,
        );
        if (mobileExists) {
          return Left(
            LocalDatabaseFailure(message: "Mobile number already exists"),
          );
        }
      }

      final model = AuthHiveModel.fromEntity(entity);
      final result = await _authDatasource.register(model);
      if (result) {
        return Right(true);
      }
      return Left(LocalDatabaseFailure(message: "Failed to register user"));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      final result = await _authDatasource.logout();
      if (result) {
        return Right(true);
      }
      return Left(LocalDatabaseFailure(message: "Failed to logout user"));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
