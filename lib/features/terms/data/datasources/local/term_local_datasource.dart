import 'dart:convert';

import 'package:digital_wallett_system/core/services/storage/user_session_service.dart';
import 'package:digital_wallett_system/features/terms/domain/entities/term_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final termLocalDatasourceProvider = Provider<TermLocalDatasource>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  return TermLocalDatasource(prefs);
});

class TermLocalDatasource {
  static const _termsKey = 'terms_cached_list';
  static const _cacheTimeKey = 'terms_cached_at';

  final SharedPreferences _prefs;

  TermLocalDatasource(this._prefs);

  Future<void> cacheTerms(List<TermEntity> list) async {
    final payload = list
        .map(
          (t) => <String, dynamic>{
            'id': t.id,
            'title': t.title,
            'content': t.content,
            'updatedAt': t.updatedAt?.toIso8601String(),
          },
        )
        .toList();

    await _prefs.setString(_termsKey, jsonEncode(payload));
    await _prefs.setString(_cacheTimeKey, DateTime.now().toIso8601String());
  }

  List<TermEntity> getCachedTerms() {
    final raw = _prefs.getString(_termsKey);
    if (raw == null || raw.isEmpty) return const [];
    final decoded = jsonDecode(raw);
    if (decoded is! List) return const [];

    return decoded.whereType<Map<String, dynamic>>().map((item) {
      return TermEntity(
        id: item['id']?.toString(),
        title: item['title']?.toString(),
        content: item['content']?.toString(),
        updatedAt: item['updatedAt'] != null
            ? DateTime.tryParse(item['updatedAt'].toString())
            : null,
      );
    }).toList();
  }

  DateTime? getLastCachedAt() {
    final raw = _prefs.getString(_cacheTimeKey);
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }
}
