import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/core/usecases/app_usecase.dart';
import 'package:digital_wallett_system/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:digital_wallett_system/features/auth/domain/entities/auth_entity.dart';
import 'package:digital_wallett_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Params

class RegisterUsecaseParams extends Equatable {
  final String fullName;
  final String? mobileNumber;
  final String username;
  final String password;

  const RegisterUsecaseParams({
    required this.fullName,
    this.mobileNumber,
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [fullName, mobileNumber, username, password];
}

/// --------------------
/// Provider
/// --------------------
final registerUsecaseProvider = Provider<RegisterUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return RegisterUsecase(authRepository: authRepository);
});

/// --------------------
/// Usecase
/// --------------------
class RegisterUsecase
    implements UsecaseWithParams<bool, RegisterUsecaseParams> {
  final IAuthRepository _authRepository;

  RegisterUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call(RegisterUsecaseParams params) {
    final entity = AuthEntity(
      fullName: params.fullName,
      mobileNumber: params.mobileNumber,
      username: params.username,
      password: params.password,
    );

    return _authRepository.register(entity);
  }
}
