import 'package:digital_wallett_system/core/api/api_client.dart';
import 'package:digital_wallett_system/core/api/api_endpoints.dart';
import 'package:digital_wallett_system/features/notifications/data/datasources/notification_datasource.dart';
import 'package:digital_wallett_system/features/notifications/data/models/notification_api_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationRemoteDatasourceProvider =
    Provider<INotificationRemoteDatasource>((ref) {
      return NotificationRemoteDatasource(
        apiClient: ref.read(apiClientProvider),
      );
    });

class NotificationRemoteDatasource implements INotificationRemoteDatasource {
  final ApiClient _apiClient;

  NotificationRemoteDatasource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<List<NotificationApiModel>> getNotifications() async {
    final primaryResponse = await _apiClient.get(
      ApiEndpoints.notificationsList,
    );
    final primaryData = primaryResponse.data;
    if (primaryData is! Map<String, dynamic> && primaryData is! List) {
      throw DioException(
        requestOptions: primaryResponse.requestOptions,
        response: primaryResponse,
        message: 'Invalid notifications response',
      );
    }

    var list = _extractList(primaryData);
    if (list.isEmpty) {
      try {
        final adminResponse = await _apiClient.get(
          ApiEndpoints.adminNotifications,
        );
        final adminData = adminResponse.data;
        if (adminData is Map<String, dynamic> || adminData is List) {
          list = _extractList(adminData);
        }
      } catch (_) {
        // Keep primary list if admin endpoint is unavailable.
      }
    }

    if (list.isEmpty) return [];

    final List<NotificationApiModel> result = [];
    for (final item in list) {
      if (item is! Map<String, dynamic>) continue;
      final parsed = _parse(item);
      if ((parsed.title == null || parsed.title!.trim().isEmpty) &&
          (parsed.body == null || parsed.body!.trim().isEmpty)) {
        continue;
      }
      result.add(parsed);
    }
    return result;
  }

  NotificationApiModel _parse(Map<String, dynamic> json) {
    final title = _firstNonEmpty(json, const [
      'title',
      'subject',
      'heading',
      'notificationTitle',
      'name',
    ]);
    final body = _firstNonEmpty(json, const [
      'body',
      'message',
      'messageNotification',
      'content',
      'description',
      'notificationBody',
      'text',
    ]);

    return NotificationApiModel(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      title: title,
      body: body,
      read: json['read'] == true,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }

  List<dynamic> _extractList(dynamic data) {
    if (data is List) return data;
    if (data is! Map<String, dynamic>) return const [];

    final candidates = [
      data['data'],
      data['notifications'],
      data['notification'],
      data['items'],
      data['results'],
    ];
    for (final candidate in candidates) {
      if (candidate is List) return candidate;
      if (candidate is Map<String, dynamic>) {
        final nested = _extractList(candidate);
        if (nested.isNotEmpty) return nested;
      }
    }
    if (_looksLikeNotificationObject(data)) {
      return [data];
    }
    return const [];
  }

  String? _firstNonEmpty(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final raw = json[key];
      if (raw == null || raw is List) continue;
      if (raw is Map<String, dynamic>) {
        final nested = _firstNonEmpty(raw, keys);
        if (nested != null && nested.isNotEmpty) return nested;
        continue;
      }
      final value = raw.toString().trim();
      if (value.isNotEmpty) return value;
    }
    return null;
  }

  bool _looksLikeNotificationObject(Map<String, dynamic> json) {
    return json.containsKey('title') ||
        json.containsKey('body') ||
        json.containsKey('message') ||
        json.containsKey('messageNotification') ||
        json.containsKey('notificationTitle');
  }
}
