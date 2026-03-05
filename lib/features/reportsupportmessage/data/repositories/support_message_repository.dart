import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/core/services/connectivity/network_info.dart';
import 'package:digital_wallett_system/features/reportsupportmessage/data/datasources/local/support_message_local_datasource.dart';
import 'package:digital_wallett_system/features/reportsupportmessage/data/datasources/remote/support_message_remote_datasource.dart';
import 'package:digital_wallett_system/features/reportsupportmessage/domain/entities/support_message_entity.dart';
import 'package:digital_wallett_system/features/reportsupportmessage/domain/repositories/support_message_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final supportMessageRepositoryProvider = Provider<ISupportMessageRepository>((
  ref,
) {
  final remoteDatasource = ref.read(supportMessageRemoteDatasourceProvider);
  final localDatasource = ref.read(supportMessageLocalDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return SupportMessageRepository(
    remoteDatasource: remoteDatasource,
    localDatasource: localDatasource,
    networkInfo: networkInfo,
  );
});

class SupportMessageRepository implements ISupportMessageRepository {
  final SupportMessageRemoteDatasource _remoteDatasource;
  final SupportMessageLocalDatasource _localDatasource;
  final NetworkInfo _networkInfo;

  SupportMessageRepository({
    required SupportMessageRemoteDatasource remoteDatasource,
    required SupportMessageLocalDatasource localDatasource,
    required NetworkInfo networkInfo,
  }) : _remoteDatasource = remoteDatasource,
       _localDatasource = localDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<SupportMessageEntity>>> getMessages() async {
    if (!await _networkInfo.isConnected) {
      final cached = _localDatasource.getCachedMessages();
      if (cached.isNotEmpty) {
        return Right(cached);
      }
      return const Left(
        ApiFailure(
          message: 'No internet connection and no cached support messages',
        ),
      );
    }
    try {
      final list = await _remoteDatasource.getMessages();
      final entities = list.map((e) => e.toEntity()).toList();
      await _localDatasource.cacheMessages(entities);
      return Right(entities);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data is Map
              ? (e.response!.data['message'] ??
                    e.message ??
                    'Failed to load support messages')
              : (e.message ?? 'Failed to load support messages'),
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SupportMessageEntity>> createMessage(
    String message,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
    try {
      final created = await _remoteDatasource.createMessage(message);
      final entity = created.toEntity();
      final current = _localDatasource.getCachedMessages();
      final next = [entity, ...current.where((e) => e.id != entity.id)];
      await _localDatasource.cacheMessages(next);
      return Right(entity);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data is Map
              ? (e.response!.data['message'] ?? e.message ?? 'Create failed')
              : (e.message ?? 'Create failed'),
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SupportMessageEntity>> updateMessage(
    String id,
    String message,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
    try {
      final updated = await _remoteDatasource.updateMessage(id, message);
      final entity = updated.toEntity();
      final next = _localDatasource
          .getCachedMessages()
          .map((item) => item.id == id ? entity : item)
          .toList();
      await _localDatasource.cacheMessages(next);
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
  Future<Either<Failure, void>> deleteMessage(String id) async {
    if (!await _networkInfo.isConnected) {
      return const Left(ApiFailure(message: 'No internet connection'));
    }
    try {
      await _remoteDatasource.deleteMessage(id);
      final next = _localDatasource
          .getCachedMessages()
          .where((item) => item.id != id)
          .toList();
      await _localDatasource.cacheMessages(next);
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
