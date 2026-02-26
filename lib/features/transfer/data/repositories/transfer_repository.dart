import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/core/services/connectivity/network_info.dart';
import 'package:digital_wallett_system/features/transfer/data/datasources/remote/transfer_remote_datasource.dart';
import 'package:digital_wallett_system/features/transfer/domain/entities/transfer_entity.dart';
import 'package:digital_wallett_system/features/transfer/domain/repositories/transfer_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transferRepositoryProvider = Provider<ITransferRepository>((ref) {
  final remoteDatasource = ref.read(transferRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return TransferRepository(
    transferRemoteDatasource: remoteDatasource,
    networkInfo: networkInfo,
  );
});

class TransferRepository implements ITransferRepository {
  final ITransferRemoteDatasource _transferRemoteDatasource;
  final NetworkInfo _networkInfo;

  TransferRepository({
    required ITransferRemoteDatasource transferRemoteDatasource,
    required NetworkInfo networkInfo,
  }) : _transferRemoteDatasource = transferRemoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, TransferEntity>> sendMoney({
    required String recipientMobile,
    required double amount,
    required String remarks,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        ApiFailure(message: 'Internet required for financial transaction'),
      );
    }
    try {
      final entity = await _transferRemoteDatasource.sendMoney(
        recipientMobile: recipientMobile,
        amount: amount,
        remarks: remarks,
      );
      return Right(entity);
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response!.data['message'] ?? e.message ?? 'Transfer failed')
          : (e.message ?? 'Transfer failed');
      return Left(
        ApiFailure(
          message: message.toString(),
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
