import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/core/usecases/app_usecase.dart';
import 'package:digital_wallett_system/features/bank/data/repositories/bank_repository.dart';
import 'package:digital_wallett_system/features/bank/domain/repositories/bank_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadFromBankParams extends Equatable {
  final String accountNumber;
  final double amount;

  const LoadFromBankParams({required this.accountNumber, required this.amount});

  @override
  List<Object?> get props => [accountNumber, amount];
}

final loadFromBankUsecaseProvider = Provider<LoadFromBankUsecase>((ref) {
  final repository = ref.read(bankRepositoryProvider);
  return LoadFromBankUsecase(repository: repository);
});

class LoadFromBankUsecase implements UsecaseWithParams<void, LoadFromBankParams> {
  final IBankRepository _repository;

  LoadFromBankUsecase({required IBankRepository repository}) : _repository = repository;

  @override
  Future<Either<Failure, void>> call(LoadFromBankParams params) {
    return _repository.loadFromBank(
      accountNumber: params.accountNumber,
      amount: params.amount,
    );
  }
}
