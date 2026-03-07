import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/core/usecases/app_usecase.dart';
import 'package:digital_wallett_system/features/auth/data/repositories/auth_repository.dart';
import 'package:digital_wallett_system/features/auth/domain/entities/auth_entity.dart';
import 'package:digital_wallett_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Params

class RegisterUsecaseParams extends Equatable {
  final String fullName;
  final String mobileNumber;
  // final String username;
  final String email;
  final String password;
  final String confirmPassword;
  final String? profilePicture;

  const RegisterUsecaseParams({
    required this.fullName,
    required this.mobileNumber,
    required this.email,
    // required this.username,
    required this.password,
    required this.confirmPassword,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [
    fullName,
    mobileNumber,
    email,
    password,
    confirmPassword,
    profilePicture,
  ];
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
      email: params.email,
      // username: params.username,
      password: params.password,
      confirmPassword: params.confirmPassword,
      profilePicture: params.profilePicture,
      // role: "user",
    );

    return _authRepository.register(entity);
  }
}
