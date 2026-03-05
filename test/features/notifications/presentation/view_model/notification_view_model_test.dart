import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/features/notifications/domain/entities/notification_entity.dart';
import 'package:digital_wallett_system/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:digital_wallett_system/features/notifications/presentation/state/notification_state.dart';
import 'package:digital_wallett_system/features/notifications/presentation/view_model/notification_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetNotificationsUsecase extends Mock
    implements GetNotificationsUsecase {}

void main() {
  late MockGetNotificationsUsecase mockGetNotificationsUsecase;
  late ProviderContainer container;

  setUp(() {
    mockGetNotificationsUsecase = MockGetNotificationsUsecase();
    container = ProviderContainer(
      overrides: [
        getNotificationsUsecaseProvider.overrideWithValue(
          mockGetNotificationsUsecase,
        ),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('NotificationViewModel', () {
    test('build returns initial state', () {
      final state = container.read(notificationViewModelProvider);
      expect(state.status, NotificationStatus.initial);
      expect(state.notifications, isEmpty);
      expect(state.errorMessage, isNull);
    });

    test('loadNotifications success sets loaded state', () async {
      const notifications = [
        NotificationEntity(
          title: 'Notification title',
          body: 'Notification bodyy',
          read: false,
        ),
      ];
      when(
        () => mockGetNotificationsUsecase(),
      ).thenAnswer((_) async => const Right(notifications));

      await container
          .read(notificationViewModelProvider.notifier)
          .loadNotifications();
      final state = container.read(notificationViewModelProvider);

      expect(state.status, NotificationStatus.loaded);
      expect(state.notifications, notifications);
      expect(state.errorMessage, isNull);
    });

    test('loadNotifications failure sets error state', () async {
      when(() => mockGetNotificationsUsecase()).thenAnswer(
        (_) async => const Left(ApiFailure(message: 'Notification failed')),
      );

      await container
          .read(notificationViewModelProvider.notifier)
          .loadNotifications();
      final state = container.read(notificationViewModelProvider);

      expect(state.status, NotificationStatus.error);
      expect(state.errorMessage, 'Notification failed');
    });
  });
}
