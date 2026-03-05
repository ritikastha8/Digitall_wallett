import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/core/usecases/app_usecase.dart';
import 'package:digital_wallett_system/features/transactions/data/repositories/transaction_repository.dart';
import 'package:digital_wallett_system/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteTransactionParams extends Equatable {
  final String id;

  const DeleteTransactionParams({required this.id});

  @override
  List<Object?> get props => [id];
}

final deleteTransactionUsecaseProvider = Provider<DeleteTransactionUsecase>((ref) {
  final repository = ref.read(transactionRepositoryProvider);
  return DeleteTransactionUsecase(repository: repository);
});

class DeleteTransactionUsecase implements UsecaseWithParams<void, DeleteTransactionParams> {
  final ITransactionRepository _repository;

  DeleteTransactionUsecase({required ITransactionRepository repository}) : _repository = repository;

  @override
  Future<Either<Failure, void>> call(DeleteTransactionParams params) {
    return _repository.deleteTransaction(params.id);
  }
}
