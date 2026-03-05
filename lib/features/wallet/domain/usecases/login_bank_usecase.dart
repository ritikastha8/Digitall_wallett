import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/core/usecases/app_usecase.dart';
import 'package:digital_wallett_system/features/wallet/data/repositories/wallet_repository.dart';
import 'package:digital_wallett_system/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginBankParams extends Equatable {
  final String mobileNumber;
  final String password;

  const LoginBankParams({required this.mobileNumber, required this.password});

  @override
  List<Object?> get props => [mobileNumber, password];
}

final loginBankUsecaseProvider = Provider<LoginBankUsecase>((ref) {
  final repository = ref.read(walletRepositoryProvider);
  return LoginBankUsecase(repository: repository);
});

class LoginBankUsecase implements UsecaseWithParams<void, LoginBankParams> {
  final IWalletRepository _repository;

  LoginBankUsecase({required IWalletRepository repository}) : _repository = repository;

  @override
  Future<Either<Failure, void>> call(LoginBankParams params) {
    return _repository.loginBank(
      mobileNumber: params.mobileNumber,
      password: params.password,
    );
  }
}
