import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/core/usecases/app_usecase.dart';
import 'package:digital_wallett_system/features/wallet/data/repositories/wallet_repository.dart';
import 'package:digital_wallett_system/features/wallet/domain/entities/wallet_entity.dart';
import 'package:digital_wallett_system/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getBalanceUsecaseProvider = Provider<GetBalanceUsecase>((ref) {
  final repository = ref.read(walletRepositoryProvider);
  return GetBalanceUsecase(repository: repository);
});

class GetBalanceUsecase implements UsecaseWithoutParams<WalletEntity> {
  final IWalletRepository _repository;

  GetBalanceUsecase({required IWalletRepository repository}) : _repository = repository;

  @override
  Future<Either<Failure, WalletEntity>> call() {
    return _repository.getBalance();
  }
}
