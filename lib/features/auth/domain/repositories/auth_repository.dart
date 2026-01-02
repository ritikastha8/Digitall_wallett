import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/features/auth/domain/entities/auth_entity.dart';

abstract interface class IAuthRepository {
  Future<Either<Failure, bool>> register(AuthEntity entity);

  Future<Either<Failure, AuthEntity>> login(
    String mobileNumber,
    String password,
  );

  Future<Either<Failure, AuthEntity>> getCurrentUser(String authId);

  Future<Either<Failure, bool>> logout();
}
