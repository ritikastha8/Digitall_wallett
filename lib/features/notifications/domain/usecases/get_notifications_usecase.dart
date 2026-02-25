import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/core/usecases/app_usecase.dart';
import 'package:digital_wallett_system/features/notifications/data/repositories/notification_repository.dart';
import 'package:digital_wallett_system/features/notifications/domain/entities/notification_entity.dart';
import 'package:digital_wallett_system/features/notifications/domain/repositories/notification_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getNotificationsUsecaseProvider = Provider<GetNotificationsUsecase>((ref) {
  final repository = ref.read(notificationRepositoryProvider);
  return GetNotificationsUsecase(repository: repository);
});

class GetNotificationsUsecase implements UsecaseWithoutParams<List<NotificationEntity>> {
  final INotificationRepository _repository;

  GetNotificationsUsecase({required INotificationRepository repository}) : _repository = repository;

  @override
  Future<Either<Failure, List<NotificationEntity>>> call() {
    return _repository.getNotifications();
  }
}
