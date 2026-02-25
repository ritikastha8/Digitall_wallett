import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/features/notifications/domain/entities/notification_entity.dart';
import 'package:digital_wallett_system/features/notifications/domain/repositories/notification_repository.dart';
import 'package:digital_wallett_system/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNotificationRepository extends Mock implements INotificationRepository {}

void main() {
  late MockNotificationRepository mockRepository;
  late GetNotificationsUsecase usecase;

  setUp(() {
    mockRepository = MockNotificationRepository();
    usecase = GetNotificationsUsecase(repository: mockRepository);
  });

  group('GetNotificationsUsecase', () {
    test('returns notifications when repository call succeeds', () async {
      final notifications = [
        const NotificationEntity(
          id: '1',
          title: 'Payment received',
          body: 'You received \$25',
          read: false,
        ),
      ];

      when(() => mockRepository.getNotifications())
          .thenAnswer((_) async => Right(notifications));

      final result = await usecase();

      expect(result, Right(notifications));
      verify(() => mockRepository.getNotifications()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('returns failure when repository call fails', () async {
      const failure = ApiFailure(message: 'Failed to load notifications');
      when(() => mockRepository.getNotifications())
          .thenAnswer((_) async => const Left(failure));

      final result = await usecase();

      expect(result, const Left(failure));
      verify(() => mockRepository.getNotifications()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
