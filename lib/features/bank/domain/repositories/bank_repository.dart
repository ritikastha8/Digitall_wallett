import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/features/bank/domain/entities/bank_entity.dart';

abstract interface class IBankRepository {
  Future<Either<Failure, void>> seedBank();
  Future<Either<Failure, BankEntity>> linkBank({required String accountNumber, required String password});
  Future<Either<Failure, void>> loadFromBank({required String accountNumber, required double amount});
}
