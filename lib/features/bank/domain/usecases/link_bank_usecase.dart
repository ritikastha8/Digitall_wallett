import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/core/usecases/app_usecase.dart';
import 'package:digital_wallett_system/features/bank/data/repositories/bank_repository.dart';
import 'package:digital_wallett_system/features/bank/domain/entities/bank_entity.dart';
import 'package:digital_wallett_system/features/bank/domain/repositories/bank_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BankLinkParams extends Equatable {
  final String accountNumber;
  final String password;

  const BankLinkParams({required this.accountNumber, required this.password});

  @override
  List<Object?> get props => [accountNumber, password];
}

final bankLinkUsecaseProvider = Provider<BankLinkUsecase>((ref) {
  final repository = ref.read(bankRepositoryProvider);
  return BankLinkUsecase(repository: repository);
});

class BankLinkUsecase implements UsecaseWithParams<BankEntity, BankLinkParams> {
  final IBankRepository _repository;

  BankLinkUsecase({required IBankRepository repository}) : _repository = repository;

  @override
  Future<Either<Failure, BankEntity>> call(BankLinkParams params) {
    return _repository.linkBank(
      accountNumber: params.accountNumber,
      password: params.password,
    );
  }
}
