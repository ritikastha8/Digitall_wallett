import 'dart:convert';

import 'package:digital_wallett_system/core/services/storage/user_session_service.dart';
import 'package:digital_wallett_system/features/notifications/data/datasources/notification_datasource.dart';
import 'package:digital_wallett_system/features/notifications/data/models/notification_api_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final notificationLocalDatasourceProvider =
    Provider<NotificationLocalDatasource>((ref) {
      final prefs = ref.read(sharedPreferencesProvider);
      return NotificationLocalDatasource(prefs);
    });

class NotificationLocalDatasource implements INotificationLocalDatasource {
  static const _notificationsKey = 'notifications_cached_list';
  static const _cacheTimeKey = 'notifications_cached_at';

  final SharedPreferences _prefs;

  NotificationLocalDatasource(this._prefs);

  @override
  Future<void> cacheNotifications(List<NotificationApiModel> list) async {
    final payload = list.map((n) => n.toJson()).toList();

    await _prefs.setString(_notificationsKey, jsonEncode(payload));
    await _prefs.setString(_cacheTimeKey, DateTime.now().toIso8601String());
  }

  @override
  List<NotificationApiModel> getCachedNotifications() {
    final raw = _prefs.getString(_notificationsKey);
    if (raw == null || raw.isEmpty) return const [];
    final decoded = jsonDecode(raw);
    if (decoded is! List) return const [];

    return decoded
        .whereType<Map<String, dynamic>>()
        .map(NotificationApiModel.fromJson)
        .toList();
  }

  DateTime? getLastCachedAt() {
    final raw = _prefs.getString(_cacheTimeKey);
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }
}
