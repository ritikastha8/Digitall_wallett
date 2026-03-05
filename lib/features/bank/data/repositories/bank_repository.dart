import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/core/services/connectivity/network_info.dart';
import 'package:digital_wallett_system/features/bank/data/datasources/bank_datasource.dart';
import 'package:digital_wallett_system/features/bank/data/datasources/remote/bank_remote_datasource.dart';
import 'package:digital_wallett_system/features/bank/domain/entities/bank_entity.dart';
import 'package:digital_wallett_system/features/bank/domain/repositories/bank_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bankRepositoryProvider = Provider<IBankRepository>((ref) {
  final remoteDatasource = ref.read(bankRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return BankRepository(
    bankRemoteDatasource: remoteDatasource,
    networkInfo: networkInfo,
  );
});

class BankRepository implements IBankRepository {
  final IBankRemoteDatasource _bankRemoteDatasource;
  final NetworkInfo _networkInfo;

  BankRepository({
    required IBankRemoteDatasource bankRemoteDatasource,
    required NetworkInfo networkInfo,
  })  : _bankRemoteDatasource = bankRemoteDatasource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, void>> seedBank() async {
    if (!await _networkInfo.isConnected) {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
    try {
      await _bankRemoteDatasource.seedBank();
      return const Right(null);
    } on DioException catch (e) {
      return Left(ApiFailure(
        message: e.response?.data is Map ? (e.response!.data['message'] ?? e.message ?? 'Seed failed') : (e.message ?? 'Seed failed'),
        statusCode: e.response?.statusCode,
      ));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, BankEntity>> linkBank({required String accountNumber, required String password}) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
    try {
      final model = await _bankRemoteDatasource.linkBank(
        accountNumber: accountNumber,
        password: password,
      );
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(ApiFailure(
        message: e.response?.data is Map ? (e.response!.data['message'] ?? e.message ?? 'Link failed') : (e.message ?? 'Link failed'),
        statusCode: e.response?.statusCode,
      ));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> loadFromBank({required String accountNumber, required double amount}) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
    try {
      await _bankRemoteDatasource.loadFromBank(accountNumber: accountNumber, amount: amount);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ApiFailure(
        message: e.response?.data is Map ? (e.response!.data['message'] ?? e.message ?? 'Load failed') : (e.message ?? 'Load failed'),
        statusCode: e.response?.statusCode,
      ));
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
