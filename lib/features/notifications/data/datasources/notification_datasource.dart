import 'package:digital_wallett_system/features/notifications/data/models/notification_api_model.dart';

abstract interface class INotificationLocalDatasource {
  Future<void> cacheNotifications(List<NotificationApiModel> list);
  List<NotificationApiModel> getCachedNotifications();
}

abstract interface class INotificationRemoteDatasource {
  Future<List<NotificationApiModel>> getNotifications();
}
