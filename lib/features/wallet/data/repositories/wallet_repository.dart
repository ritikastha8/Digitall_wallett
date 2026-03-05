import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/core/services/connectivity/network_info.dart';
import 'package:digital_wallett_system/features/wallet/data/datasources/local/wallet_local_datasource.dart';
import 'package:digital_wallett_system/features/wallet/data/datasources/remote/wallet_remote_datasource.dart';
import 'package:digital_wallett_system/features/wallet/domain/entities/receive_qr_entity.dart';
import 'package:digital_wallett_system/features/wallet/domain/entities/wallet_entity.dart';
import 'package:digital_wallett_system/features/wallet/domain/repositories/wallet_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final walletRepositoryProvider = Provider<IWalletRepository>((ref) {
  final remoteDatasource = ref.read(walletRemoteDatasourceProvider);
  final localDatasource = ref.read(walletLocalDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return WalletRepository(
    walletLocalDatasource: localDatasource,
    walletRemoteDatasource: remoteDatasource,
    networkInfo: networkInfo,
  );
});

class WalletRepository implements IWalletRepository {
  final WalletLocalDatasource _walletLocalDatasource;
  final IWalletRemoteDatasource _walletRemoteDatasource;
  final NetworkInfo _networkInfo;

  WalletRepository({
    required WalletLocalDatasource walletLocalDatasource,
    required IWalletRemoteDatasource walletRemoteDatasource,
    required NetworkInfo networkInfo,
  }) : _walletLocalDatasource = walletLocalDatasource,
       _walletRemoteDatasource = walletRemoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, WalletEntity>> getBalance() async {
    if (!await _networkInfo.isConnected) {
      final cached = _walletLocalDatasource.getCachedBalance();
      if (cached != null) {
        return Right(cached);
      }
      return const Left(
        ApiFailure(message: 'No internet connection and no cached wallet data'),
      );
    }
    try {
      final entity = await _walletRemoteDatasource.getBalance();
      await _walletLocalDatasource.cacheBalance(entity);
      return Right(entity);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data is Map
              ? (e.response!.data['message'] ??
                    e.message ??
                    'Failed to load balance')
              : (e.message ?? 'Failed to load balance'),
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ReceiveQrEntity>> getReceiveQr({
    double? amount,
  }) async {
    if (!await _networkInfo.isConnected) {
      final cached = _walletLocalDatasource.getCachedReceiveQr();
      if (cached != null) {
        return Right(cached);
      }
      return const Left(
        ApiFailure(message: 'No internet connection and no cached QR data'),
      );
    }
    try {
      final entity = await _walletRemoteDatasource.getReceiveQr(amount: amount);
      await _walletLocalDatasource.cacheReceiveQr(entity);
      return Right(entity);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data is Map
              ? (e.response!.data['message'] ??
                    e.message ??
                    'Failed to load QR')
              : (e.message ?? 'Failed to load QR'),
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> loadMoney({
    required String mobileNumber,
    required double amount,
    String? remarks,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        ApiFailure(message: 'Internet required for financial transaction'),
      );
    }
    try {
      final balance = await _walletRemoteDatasource.loadMoney(
        mobileNumber: mobileNumber,
        amount: amount,
        remarks: remarks,
      );
      return Right(balance);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data is Map
              ? (e.response!.data['message'] ?? e.message ?? 'Load failed')
              : (e.message ?? 'Load failed'),
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> topup({
    required double amount,
    required String mobileNumber,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        ApiFailure(message: 'Internet required for financial transaction'),
      );
    }
    try {
      final balance = await _walletRemoteDatasource.topup(
        amount: amount,
        mobileNumber: mobileNumber,
      );
      return Right(balance);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data is Map
              ? (e.response!.data['message'] ?? e.message ?? 'Topup failed')
              : (e.message ?? 'Topup failed'),
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> linkBank({
    required String accountNumber,
    required String password,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        ApiFailure(message: 'Internet required for financial transaction'),
      );
    }
    try {
      await _walletRemoteDatasource.linkBank(
        accountNumber: accountNumber,
        password: password,
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data is Map
              ? (e.response!.data['message'] ?? e.message ?? 'Link bank failed')
              : (e.message ?? 'Link bank failed'),
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> loginBank({
    required String mobileNumber,
    required String password,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        ApiFailure(message: 'Internet required for financial transaction'),
      );
    }
    try {
      await _walletRemoteDatasource.loginBank(
        mobileNumber: mobileNumber,
        password: password,
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data is Map
              ? (e.response!.data['message'] ??
                    e.message ??
                    'Bank login failed')
              : (e.message ?? 'Bank login failed'),
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
