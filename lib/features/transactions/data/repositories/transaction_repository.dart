import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/core/services/connectivity/network_info.dart';
import 'package:digital_wallett_system/features/transactions/data/datasources/local/transaction_local_datasource.dart';
import 'package:digital_wallett_system/features/transactions/data/datasources/remote/transaction_remote_datasource.dart';
import 'package:digital_wallett_system/features/transactions/domain/entities/transaction_entity.dart';
import 'package:digital_wallett_system/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionRepositoryProvider = Provider<ITransactionRepository>((ref) {
  final remoteDatasource = ref.read(transactionRemoteDatasourceProvider);
  final localDatasource = ref.read(transactionLocalDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return TransactionRepository(
    transactionLocalDatasource: localDatasource,
    transactionRemoteDatasource: remoteDatasource,
    networkInfo: networkInfo,
  );
});

class TransactionRepository implements ITransactionRepository {
  final TransactionLocalDatasource _transactionLocalDatasource;
  final ITransactionRemoteDatasource _transactionRemoteDatasource;
  final NetworkInfo _networkInfo;

  TransactionRepository({
    required TransactionLocalDatasource transactionLocalDatasource,
    required ITransactionRemoteDatasource transactionRemoteDatasource,
    required NetworkInfo networkInfo,
  }) : _transactionLocalDatasource = transactionLocalDatasource,
       _transactionRemoteDatasource = transactionRemoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<TransactionEntity>>> getMyTransactions() async {
    if (!await _networkInfo.isConnected) {
      final cached = _transactionLocalDatasource.getCachedTransactions();
      if (cached.isNotEmpty) {
        return Right(cached);
      }
      return const Left(
        ApiFailure(
          message: 'No internet connection and no cached transactions',
        ),
      );
    }
    try {
      final list = await _transactionRemoteDatasource.getMyTransactions();
      await _transactionLocalDatasource.cacheTransactions(list);
      return Right(list);
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response!.data['message'] ??
                e.message ??
                'Failed to load transactions')
          : (e.message ?? 'Failed to load transactions');
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

  @override
  Future<Either<Failure, TransactionEntity>> logTransaction(
    Map<String, dynamic> body,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
    try {
      final entity = await _transactionRemoteDatasource.logTransaction(body);
      return Right(entity);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data is Map
              ? (e.response!.data['message'] ?? e.message ?? 'Log failed')
              : (e.message ?? 'Log failed'),
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TransactionEntity>> getTransactionById(
    String id,
  ) async {
    if (!await _networkInfo.isConnected) {
      final cached = _transactionLocalDatasource.getCachedTransactions();
      try {
        final match = cached.firstWhere((t) => t.id == id);
        return Right(match);
      } catch (_) {
        return const Left(
          ApiFailure(
            message: 'No internet connection and transaction not in cache',
          ),
        );
      }
    }
    try {
      final entity = await _transactionRemoteDatasource.getTransactionById(id);
      return Right(entity);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data is Map
              ? (e.response!.data['message'] ?? e.message ?? 'Failed to load')
              : (e.message ?? 'Failed to load'),
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TransactionEntity>> updateTransaction(
    String id,
    Map<String, dynamic> body,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
    try {
      final entity = await _transactionRemoteDatasource.updateTransaction(
        id,
        body,
      );
      return Right(entity);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data is Map
              ? (e.response!.data['message'] ?? e.message ?? 'Update failed')
              : (e.message ?? 'Update failed'),
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTransaction(String id) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
    try {
      await _transactionRemoteDatasource.deleteTransaction(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data is Map
              ? (e.response!.data['message'] ?? e.message ?? 'Delete failed')
              : (e.message ?? 'Delete failed'),
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
