import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/core/usecases/app_usecase.dart';
import 'package:digital_wallett_system/features/transactions/data/repositories/transaction_repository.dart';
import 'package:digital_wallett_system/features/transactions/domain/entities/transaction_entity.dart';
import 'package:digital_wallett_system/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final logTransactionUsecaseProvider = Provider<LogTransactionUsecase>((ref) {
  final repository = ref.read(transactionRepositoryProvider);
  return LogTransactionUsecase(repository: repository);
});

class LogTransactionUsecase implements UsecaseWithParams<TransactionEntity, Map<String, dynamic>> {
  final ITransactionRepository _repository;

  LogTransactionUsecase({required ITransactionRepository repository}) : _repository = repository;

  @override
  Future<Either<Failure, TransactionEntity>> call(Map<String, dynamic> params) {
    return _repository.logTransaction(params);
  }
}
