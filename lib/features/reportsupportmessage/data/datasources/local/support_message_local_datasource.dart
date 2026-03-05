import 'dart:convert';
import 'package:digital_wallett_system/core/services/storage/user_session_service.dart';
import 'package:digital_wallett_system/features/reportsupportmessage/data/datasources/support_message_datasource.dart';
import 'package:digital_wallett_system/features/reportsupportmessage/data/models/support_message_api_model.dart';
import 'package:digital_wallett_system/features/reportsupportmessage/domain/entities/support_message_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final supportMessageLocalDatasourceProvider =
    Provider<SupportMessageLocalDatasource>((ref) {
      final prefs = ref.read(sharedPreferencesProvider);
      return SupportMessageLocalDatasource(prefs);
    });

class SupportMessageLocalDatasource implements ISupportMessageLocalDatasource {
  static const String _cacheKey = 'support_messages_cached_list';
  final SharedPreferences _prefs;

  SupportMessageLocalDatasource(this._prefs);

  @override
  Future<void> cacheMessages(List<SupportMessageEntity> list) async {
    final payload = list
        .map((entity) => SupportMessageApiModel.fromEntity(entity).toJson())
        .toList();
    await _prefs.setString(_cacheKey, jsonEncode(payload));
  }

  @override
  List<SupportMessageEntity> getCachedMessages() {
    final raw = _prefs.getString(_cacheKey);
    if (raw == null || raw.isEmpty) return const [];
    final decoded = jsonDecode(raw);
    if (decoded is! List) return const [];
    return decoded
        .whereType<Map<String, dynamic>>()
        .map(SupportMessageApiModel.fromJson)
        .map((model) => model.toEntity())
        .toList();
  }

  @override
  Future<void> clearCache() async {
    await _prefs.remove(_cacheKey);
  }
}
