import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/core/usecases/app_usecase.dart';
import 'package:digital_wallett_system/features/transactions/data/repositories/transaction_repository.dart';
import 'package:digital_wallett_system/features/transactions/domain/entities/transaction_entity.dart';
import 'package:digital_wallett_system/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getMyTransactionsUsecaseProvider = Provider<GetMyTransactionsUsecase>((ref) {
  final repository = ref.read(transactionRepositoryProvider);
  return GetMyTransactionsUsecase(repository: repository);
});

class GetMyTransactionsUsecase implements UsecaseWithoutParams<List<TransactionEntity>> {
  final ITransactionRepository _repository;

  GetMyTransactionsUsecase({required ITransactionRepository repository}) : _repository = repository;

  @override
  Future<Either<Failure, List<TransactionEntity>>> call() {
    return _repository.getMyTransactions();
  }
}
