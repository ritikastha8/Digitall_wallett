import 'dart:convert';

import 'package:digital_wallett_system/core/services/storage/user_session_service.dart';
import 'package:digital_wallett_system/features/wallet/domain/entities/receive_qr_entity.dart';
import 'package:digital_wallett_system/features/wallet/domain/entities/wallet_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final walletLocalDatasourceProvider = Provider<WalletLocalDatasource>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  return WalletLocalDatasource(prefs);
});

class WalletLocalDatasource {
  static const _walletInfoKey = 'wallet_cached_info';
  static const _receiveQrKey = 'wallet_cached_receive_qr';
  static const _cacheTimeKey = 'wallet_cached_at';

  final SharedPreferences _prefs;

  WalletLocalDatasource(this._prefs);

  Future<void> cacheBalance(WalletEntity wallet) async {
    final payload = <String, dynamic>{
      'balance': wallet.balance,
      'currency': wallet.currency,
    };
    await _prefs.setString(_walletInfoKey, jsonEncode(payload));
    await _prefs.setString(_cacheTimeKey, DateTime.now().toIso8601String());
  }

  WalletEntity? getCachedBalance() {
    final raw = _prefs.getString(_walletInfoKey);
    if (raw == null || raw.isEmpty) return null;
    final json = jsonDecode(raw);
    if (json is! Map<String, dynamic>) return null;
    return WalletEntity(
      balance: (json['balance'] is num)
          ? (json['balance'] as num).toDouble()
          : 0,
      currency: json['currency']?.toString(),
    );
  }

  Future<void> cacheReceiveQr(ReceiveQrEntity qr) async {
    final payload = <String, dynamic>{
      'payload': qr.payload,
      'mobileNumber': qr.mobileNumber,
      'name': qr.name,
      'amount': qr.amount,
      'qrImageBase64': qr.qrImageBase64,
    };
    await _prefs.setString(_receiveQrKey, jsonEncode(payload));
    await _prefs.setString(_cacheTimeKey, DateTime.now().toIso8601String());
  }

  ReceiveQrEntity? getCachedReceiveQr() {
    final raw = _prefs.getString(_receiveQrKey);
    if (raw == null || raw.isEmpty) return null;
    final json = jsonDecode(raw);
    if (json is! Map<String, dynamic>) return null;
    return ReceiveQrEntity(
      payload: json['payload']?.toString() ?? '',
      mobileNumber: json['mobileNumber']?.toString(),
      name: json['name']?.toString(),
      amount: (json['amount'] is num)
          ? (json['amount'] as num).toDouble()
          : null,
      qrImageBase64: json['qrImageBase64']?.toString(),
    );
  }

  DateTime? getLastCachedAt() {
    final raw = _prefs.getString(_cacheTimeKey);
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }
}
