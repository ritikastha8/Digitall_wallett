import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/features/transfer/domain/entities/transfer_entity.dart';

abstract interface class ITransferRepository {
  Future<Either<Failure, TransferEntity>> sendMoney({
    required String recipientMobile,
    required double amount,
    required String remarks,
  });
}
