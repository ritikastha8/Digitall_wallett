import 'package:digital_wallett_system/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:digital_wallett_system/features/notifications/presentation/state/notification_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationViewModelProvider =
    NotifierProvider<NotificationViewModel, NotificationState>(
      NotificationViewModel.new,
    );

class NotificationViewModel extends Notifier<NotificationState> {
  late final GetNotificationsUsecase _getNotificationsUsecase;

  @override
  NotificationState build() {
    _getNotificationsUsecase = ref.read(getNotificationsUsecaseProvider);
    return const NotificationState();
  }

  Future<void> loadNotifications() async {
    state = state.copyWith(
      status: NotificationStatus.loading,
      errorMessage: null,
    );
    final result = await _getNotificationsUsecase();
    result.fold(
      (failure) {
        state = state.copyWith(
          status: NotificationStatus.error,
          errorMessage: failure.message,
        );
      },
      (list) {
        state = state.copyWith(
          status: NotificationStatus.loaded,
          notifications: list,
          errorMessage: null,
        );
      },
    );
  }
}
