import 'dart:convert';

import 'package:digital_wallett_system/core/services/storage/user_session_service.dart';
import 'package:digital_wallett_system/features/transactions/domain/entities/transaction_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final transactionLocalDatasourceProvider = Provider<TransactionLocalDatasource>(
  (ref) {
    final prefs = ref.read(sharedPreferencesProvider);
    return TransactionLocalDatasource(prefs);
  },
);

class TransactionLocalDatasource {
  static const _transactionsKey = 'transactions_cached_list';
  static const _cacheTimeKey = 'transactions_cached_at';

  final SharedPreferences _prefs;

  TransactionLocalDatasource(this._prefs);

  Future<void> cacheTransactions(List<TransactionEntity> transactions) async {
    final list = transactions
        .map(
          (tx) => <String, dynamic>{
            'id': tx.id,
            'type': tx.type,
            'mobileNumber': tx.mobileNumber,
            'toMobileNumber': tx.toMobileNumber,
            'amount': tx.amount,
            'remarks': tx.remarks,
            'createdAt': tx.createdAt?.toIso8601String(),
            'status': tx.status,
          },
        )
        .toList();
    await _prefs.setString(_transactionsKey, jsonEncode(list));
    await _prefs.setString(_cacheTimeKey, DateTime.now().toIso8601String());
  }

  List<TransactionEntity> getCachedTransactions() {
    final raw = _prefs.getString(_transactionsKey);
    if (raw == null || raw.isEmpty) return const [];
    final decoded = jsonDecode(raw);
    if (decoded is! List) return const [];

    return decoded.whereType<Map<String, dynamic>>().map((item) {
      return TransactionEntity(
        id: item['id']?.toString(),
        type: item['type']?.toString() ?? 'Unknown',
        mobileNumber: item['mobileNumber']?.toString(),
        toMobileNumber: item['toMobileNumber']?.toString(),
        amount: (item['amount'] is num)
            ? (item['amount'] as num).toDouble()
            : 0,
        remarks: item['remarks']?.toString(),
        createdAt: item['createdAt'] != null
            ? DateTime.tryParse(item['createdAt'].toString())
            : null,
        status: item['status']?.toString(),
      );
    }).toList();
  }

  DateTime? getLastCachedAt() {
    final raw = _prefs.getString(_cacheTimeKey);
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }
}
