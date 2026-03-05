import 'dart:convert';

import 'package:digital_wallett_system/core/services/storage/user_session_service.dart';
import 'package:digital_wallett_system/features/feedback/data/datasources/feedback_datasource.dart';
import 'package:digital_wallett_system/features/feedback/data/models/feedback_api_model.dart';
import 'package:digital_wallett_system/features/feedback/domain/entities/feedback_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final feedbackLocalDatasourceProvider = Provider<FeedbackLocalDatasource>((
  ref,
) {
  final prefs = ref.read(sharedPreferencesProvider);
  return FeedbackLocalDatasource(prefs);
});

class FeedbackLocalDatasource implements IFeedbackLocalDatasource {
  static const String _cacheKey = 'feedback_cached_list';
  final SharedPreferences _prefs;

  FeedbackLocalDatasource(this._prefs);

  @override
  Future<void> cacheFeedbacks(List<FeedbackEntity> list) async {
    final payload = list
        .map((entity) => FeedbackApiModel.fromEntity(entity).toJson())
        .toList();
    await _prefs.setString(_cacheKey, jsonEncode(payload));
  }

  @override
  List<FeedbackEntity> getCachedFeedbacks() {
    final raw = _prefs.getString(_cacheKey);
    if (raw == null || raw.isEmpty) return const [];

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];

      return decoded
          .whereType<Map<String, dynamic>>()
          .map(FeedbackApiModel.fromJson)
          .map((model) => model.toEntity())
          .toList();
    } catch (_) {
      return const [];
    }
  }

  @override
  Future<void> clearCache() async {
    await _prefs.remove(_cacheKey);
  }
}
