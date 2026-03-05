import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/features/wallet/domain/entities/receive_qr_entity.dart';
import 'package:digital_wallett_system/features/wallet/domain/entities/wallet_entity.dart';

abstract interface class IWalletRepository {
  Future<Either<Failure, WalletEntity>> getBalance();
  Future<Either<Failure, ReceiveQrEntity>> getReceiveQr({double? amount});
  Future<Either<Failure, double>> loadMoney({required String mobileNumber, required double amount, String? remarks});
  Future<Either<Failure, double>> topup({
    required double amount,
    required String mobileNumber,
  });
  Future<Either<Failure, void>> linkBank({required String accountNumber, required String password});
  Future<Either<Failure, void>> loginBank({required String mobileNumber, required String password});
}
