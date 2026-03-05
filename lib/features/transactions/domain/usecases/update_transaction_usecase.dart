import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/core/usecases/app_usecase.dart';
import 'package:digital_wallett_system/features/transactions/data/repositories/transaction_repository.dart';
import 'package:digital_wallett_system/features/transactions/domain/entities/transaction_entity.dart';
import 'package:digital_wallett_system/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateTransactionParams extends Equatable {
  final String id;
  final Map<String, dynamic> body;

  const UpdateTransactionParams({required this.id, required this.body});

  @override
  List<Object?> get props => [id, body];
}

final updateTransactionUsecaseProvider = Provider<UpdateTransactionUsecase>((ref) {
  final repository = ref.read(transactionRepositoryProvider);
  return UpdateTransactionUsecase(repository: repository);
});

class UpdateTransactionUsecase implements UsecaseWithParams<TransactionEntity, UpdateTransactionParams> {
  final ITransactionRepository _repository;

  UpdateTransactionUsecase({required ITransactionRepository repository}) : _repository = repository;

  @override
  Future<Either<Failure, TransactionEntity>> call(UpdateTransactionParams params) {
    return _repository.updateTransaction(params.id, params.body);
  }
}
