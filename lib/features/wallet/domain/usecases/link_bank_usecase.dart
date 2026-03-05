import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/core/usecases/app_usecase.dart';
import 'package:digital_wallett_system/features/wallet/data/repositories/wallet_repository.dart';
import 'package:digital_wallett_system/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LinkBankParams extends Equatable {
  final String accountNumber;
  final String password;

  const LinkBankParams({required this.accountNumber, required this.password});

  @override
  List<Object?> get props => [accountNumber, password];
}

final linkBankUsecaseProvider = Provider<LinkBankUsecase>((ref) {
  final repository = ref.read(walletRepositoryProvider);
  return LinkBankUsecase(repository: repository);
});

class LinkBankUsecase implements UsecaseWithParams<void, LinkBankParams> {
  final IWalletRepository _repository;

  LinkBankUsecase({required IWalletRepository repository}) : _repository = repository;

  @override
  Future<Either<Failure, void>> call(LinkBankParams params) {
    return _repository.linkBank(
      accountNumber: params.accountNumber,
      password: params.password,
    );
  }
}
