import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/core/usecases/app_usecase.dart';
import 'package:digital_wallett_system/features/transactions/data/repositories/transaction_repository.dart';
import 'package:digital_wallett_system/features/transactions/domain/entities/transaction_entity.dart';
import 'package:digital_wallett_system/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetTransactionByIdParams extends Equatable {
  final String id;

  const GetTransactionByIdParams({required this.id});

  @override
  List<Object?> get props => [id];
}

final getTransactionByIdUsecaseProvider = Provider<GetTransactionByIdUsecase>((ref) {
  final repository = ref.read(transactionRepositoryProvider);
  return GetTransactionByIdUsecase(repository: repository);
});

class GetTransactionByIdUsecase implements UsecaseWithParams<TransactionEntity, GetTransactionByIdParams> {
  final ITransactionRepository _repository;

  GetTransactionByIdUsecase({required ITransactionRepository repository}) : _repository = repository;

  @override
  Future<Either<Failure, TransactionEntity>> call(GetTransactionByIdParams params) {
    return _repository.getTransactionById(params.id);
  }
}
