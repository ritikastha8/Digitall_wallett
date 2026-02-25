import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/core/services/connectivity/network_info.dart';
import 'package:digital_wallett_system/features/notifications/data/datasources/notification_datasource.dart';
import 'package:digital_wallett_system/features/notifications/data/datasources/local/notification_local_datasource.dart';
import 'package:digital_wallett_system/features/notifications/data/datasources/remote/notification_remote_datasource.dart';
import 'package:digital_wallett_system/features/notifications/domain/entities/notification_entity.dart';
import 'package:digital_wallett_system/features/notifications/domain/repositories/notification_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationRepositoryProvider = Provider<INotificationRepository>((ref) {
  final remoteDatasource = ref.read(notificationRemoteDatasourceProvider);
  final localDatasource = ref.read(notificationLocalDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return NotificationRepository(
    notificationLocalDatasource: localDatasource,
    notificationRemoteDatasource: remoteDatasource,
    networkInfo: networkInfo,
  );
});

class NotificationRepository implements INotificationRepository {
  final NotificationLocalDatasource _notificationLocalDatasource;
  final INotificationRemoteDatasource _notificationRemoteDatasource;
  final NetworkInfo _networkInfo;

  NotificationRepository({
    required NotificationLocalDatasource notificationLocalDatasource,
    required INotificationRemoteDatasource notificationRemoteDatasource,
    required NetworkInfo networkInfo,
  }) : _notificationLocalDatasource = notificationLocalDatasource,
       _notificationRemoteDatasource = notificationRemoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications() async {
    if (!await _networkInfo.isConnected) {
      final cached = _notificationLocalDatasource.getCachedNotifications();
      if (cached.isNotEmpty) {
        return Right(cached.map((item) => item.toEntity()).toList());
      }
      return const Left(
        ApiFailure(
          message: 'No internet connection and no cached notifications',
        ),
      );
    }
    try {
      final list = await _notificationRemoteDatasource.getNotifications();
      await _notificationLocalDatasource.cacheNotifications(list);
      return Right(list.map((item) => item.toEntity()).toList());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message: e.response?.data is Map
              ? (e.response!.data['message'] ??
                    e.message ??
                    'Failed to load notifications')
              : (e.message ?? 'Failed to load notifications'),
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

}
