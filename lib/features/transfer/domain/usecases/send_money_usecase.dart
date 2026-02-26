import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/core/usecases/app_usecase.dart';
import 'package:digital_wallett_system/features/transfer/data/repositories/transfer_repository.dart';
import 'package:digital_wallett_system/features/transfer/domain/entities/transfer_entity.dart';
import 'package:digital_wallett_system/features/transfer/domain/repositories/transfer_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SendMoneyParams extends Equatable {
  final String recipientMobile;
  final double amount;
  final String remarks;

  const SendMoneyParams({
    required this.recipientMobile,
    required this.amount,
    required this.remarks,
  });

  @override
  List<Object?> get props => [recipientMobile, amount, remarks];
}

final sendMoneyUsecaseProvider = Provider<SendMoneyUsecase>((ref) {
  final repository = ref.read(transferRepositoryProvider);
  return SendMoneyUsecase(repository: repository);
});

class SendMoneyUsecase implements UsecaseWithParams<TransferEntity, SendMoneyParams> {
  final ITransferRepository _repository;

  SendMoneyUsecase({required ITransferRepository repository}) : _repository = repository;

  @override
  Future<Either<Failure, TransferEntity>> call(SendMoneyParams params) {
    return _repository.sendMoney(
      recipientMobile: params.recipientMobile,
      amount: params.amount,
      remarks: params.remarks,
    );
  }
}
