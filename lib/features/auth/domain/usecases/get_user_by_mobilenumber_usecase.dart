import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

final getUserByMObileProvider = Provider(
  (ref) => GetUserByMobileNumberUsecase(ref.read(authRepositoryProvider)),
);

class GetUserByMobileNumberUsecase {
  final IAuthRepository repository;
  GetUserByMobileNumberUsecase(this.repository);
  Future<Either<Failure, AuthEntity>> call(String mobileNumber) {
    return repository.getUserByMobileNumber(mobileNumber);
  }
}
