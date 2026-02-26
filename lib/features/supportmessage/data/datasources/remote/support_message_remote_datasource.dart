import 'package:digital_wallett_system/core/api/api_client.dart';
import 'package:digital_wallett_system/core/api/api_endpoints.dart';
import 'package:digital_wallett_system/features/supportmessage/data/datasources/support_message_datasource.dart';
import 'package:digital_wallett_system/features/supportmessage/data/models/support_message_api_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final supportMessageRemoteDatasourceProvider =
    Provider<SupportMessageRemoteDatasource>((ref) {
      return SupportMessageRemoteDatasource(apiClient: ref.read(apiClientProvider));
    });

class SupportMessageRemoteDatasource implements ISupportMessageRemoteDatasource {
  final ApiClient _apiClient;

  SupportMessageRemoteDatasource({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<List<SupportMessageApiModel>> getMessages() async {
    final response = await _apiClient.get(ApiEndpoints.supportMessages);
    final data = response.data;
    if (data is! Map<String, dynamic> && data is! List) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Invalid support messages response',
      );
    }
    final list = _extractList(data);
    return list
        .whereType<Map<String, dynamic>>()
        .map(SupportMessageApiModel.fromJson)
        .where((item) => item.message.trim().isNotEmpty)
        .toList();
  }

  @override
  Future<SupportMessageApiModel> createMessage(String message) async {
    final response = await _apiClient.post(
      ApiEndpoints.supportMessages,
      data: {'message': message.trim()},
    );
    return _extractOne(response.data, response);
  }

  @override
  Future<SupportMessageApiModel> updateMessage(String id, String message) async {
    final response = await _apiClient.put(
      ApiEndpoints.supportMessageById(id),
      data: {'message': message.trim()},
    );
    return _extractOne(response.data, response);
  }

  @override
  Future<void> deleteMessage(String id) async {
    await _apiClient.delete(ApiEndpoints.supportMessageById(id));
  }

  SupportMessageApiModel _extractOne(dynamic data, Response response) {
    if (data is Map<String, dynamic>) {
      final candidate = data['data'];
      if (candidate is Map<String, dynamic>) {
        return SupportMessageApiModel.fromJson(candidate);
      }
      if (candidate is List && candidate.isNotEmpty) {
        final first = candidate.first;
        if (first is Map<String, dynamic>) {
          return SupportMessageApiModel.fromJson(first);
        }
      }
      if (_looksLikeMessageObject(data)) {
        return SupportMessageApiModel.fromJson(data);
      }
    }
    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      message: 'Invalid support message response',
    );
  }

  List<dynamic> _extractList(dynamic data) {
    if (data is List) return data;
    if (data is! Map<String, dynamic>) return const [];
    final candidates = [
      data['data'],
      data['messages'],
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
    if (_looksLikeMessageObject(data)) {
      return [data];
    }
    return const [];
  }

  bool _looksLikeMessageObject(Map<String, dynamic> json) {
    return json.containsKey('message') ||
        json.containsKey('body') ||
        json.containsKey('content');
  }
}

