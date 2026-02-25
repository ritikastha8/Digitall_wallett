import 'package:digital_wallett_system/core/api/api_client.dart';
import 'package:digital_wallett_system/core/api/api_endpoints.dart';
import 'package:digital_wallett_system/features/terms/domain/entities/term_entity.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final termRemoteDatasourceProvider = Provider<TermRemoteDatasource>((ref) {
  return TermRemoteDatasource(apiClient: ref.read(apiClientProvider));
});

abstract interface class ITermRemoteDatasource {
  Future<List<TermEntity>> getTerms();
}

class TermRemoteDatasource implements ITermRemoteDatasource {
  final ApiClient _apiClient;

  TermRemoteDatasource({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<List<TermEntity>> getTerms() async {
    final primaryResponse = await _apiClient.get(ApiEndpoints.termsList);
    final primaryData = primaryResponse.data;
    if (primaryData is! Map<String, dynamic> && primaryData is! List) {
      throw DioException(
        requestOptions: primaryResponse.requestOptions,
        response: primaryResponse,
        message: 'Invalid terms response',
      );
    }

    var list = _extractList(primaryData);

    // Some backends store terms via admin endpoint and expose empty user list.
    if (list.isEmpty) {
      try {
        final adminResponse = await _apiClient.get(ApiEndpoints.adminTerms);
        final adminData = adminResponse.data;
        if (adminData is Map<String, dynamic> || adminData is List) {
          list = _extractList(adminData);
        }
      } catch (_) {
        // Keep primary result if admin endpoint is unavailable/unauthorized.
      }
    }

    if (list.isEmpty) {
      return [];
    }

    final List<TermEntity> result = [];
    for (final item in list) {
      if (item is! Map<String, dynamic>) continue;
      final parsed = _parse(item);
      if ((parsed.title == null || parsed.title!.trim().isEmpty) &&
          (parsed.content == null || parsed.content!.trim().isEmpty)) {
        continue;
      }
      result.add(parsed);
    }
    return result;
  }

  TermEntity _parse(Map<String, dynamic> json) {
    final title = _firstNonEmpty(json, const [
      'title',
      'name',
      'heading',
      'subject',
      'termsTitle',
      'termsConditionTitle',
      'termTitle',
    ]);
    final content = _firstNonEmpty(json, const [
      'content',
      'body',
      'description',
      'text',
      'terms',
      'termsCondition',
      'termsConditions',
      'termsDescription',
      'termsConditionDescription',
      'termDescription',
    ]);

    return TermEntity(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      title: title,
      content: content,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  List<dynamic> _extractList(dynamic data) {
    if (data is List) return data;
    if (data is! Map<String, dynamic>) return const [];

    final candidates = [
      data['data'],
      data['terms'],
      data['termsList'],
      data['termsConditions'],
      data['termsCondition'],
      data['items'],
      data['results'],
    ];
    for (final candidate in candidates) {
      if (candidate is List) return candidate;
      if (candidate is Map<String, dynamic>) {
        final nestedList = _extractList(candidate);
        if (nestedList.isNotEmpty) return nestedList;
      }
    }
    // Handle case where the whole response itself is one term object.
    if (_looksLikeTermObject(data)) {
      return [data];
    }
    return const [];
  }

  String? _firstNonEmpty(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final raw = json[key];
      if (raw == null) continue;

      // Avoid rendering entire objects like "{_id:..., title:..., ...}".
      if (raw is Map<String, dynamic>) {
        final nested = _firstNonEmpty(raw, const [
          'title',
          'content',
          'body',
          'description',
          'termsConditionTitle',
          'termsConditionDescription',
        ]);
        if (nested != null && nested.isNotEmpty) return nested;
        continue;
      }
      if (raw is List) continue;

      final value = raw.toString().trim();
      if (value.isNotEmpty) return value;
    }
    return null;
  }

  bool _looksLikeTermObject(Map<String, dynamic> json) {
    return json.containsKey('title') ||
        json.containsKey('content') ||
        json.containsKey('terms') ||
        json.containsKey('description');
  }
}
