import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/features/transactions/domain/entities/transaction_entity.dart';

abstract interface class ITransactionRepository {
  Future<Either<Failure, List<TransactionEntity>>> getMyTransactions();
  Future<Either<Failure, TransactionEntity>> logTransaction(Map<String, dynamic> body);
  Future<Either<Failure, TransactionEntity>> getTransactionById(String id);
  Future<Either<Failure, TransactionEntity>> updateTransaction(String id, Map<String, dynamic> body);
  Future<Either<Failure, void>> deleteTransaction(String id);
}
