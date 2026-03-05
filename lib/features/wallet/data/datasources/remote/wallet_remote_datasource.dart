import 'package:digital_wallett_system/core/api/api_client.dart';
import 'package:digital_wallett_system/core/api/api_endpoints.dart';
import 'package:digital_wallett_system/features/wallet/domain/entities/receive_qr_entity.dart';
import 'package:digital_wallett_system/features/wallet/domain/entities/wallet_entity.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final walletRemoteDatasourceProvider = Provider<WalletRemoteDatasource>((ref) {
  return WalletRemoteDatasource(apiClient: ref.read(apiClientProvider));
});

abstract interface class IWalletRemoteDatasource {
  Future<WalletEntity> getBalance();
  Future<ReceiveQrEntity> getReceiveQr({double? amount});
  Future<double> loadMoney({required String mobileNumber, required double amount, String? remarks});
  Future<double> topup({required double amount, required String mobileNumber});
  Future<void> linkBank({required String accountNumber, required String password});
  Future<void> loginBank({required String mobileNumber, required String password});
}

class WalletRemoteDatasource implements IWalletRemoteDatasource {
  final ApiClient _apiClient;

  WalletRemoteDatasource({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<WalletEntity> getBalance() async {
    final response = await _apiClient.get(ApiEndpoints.walletBalance);
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Invalid balance response',
      );
    }
    // Support both { "balance": x } and { "data": { "balance": x } }
    double balance = 0.0;
    if (data['data'] is Map<String, dynamic>) {
      final inner = data['data'] as Map<String, dynamic>;
      balance = (inner['balance'] is num) ? (inner['balance'] as num).toDouble() : 0.0;
    } else if (data['balance'] is num) {
      balance = (data['balance'] as num).toDouble();
    }
    return WalletEntity(balance: balance, currency: 'NPR');
  }

  @override
  Future<ReceiveQrEntity> getReceiveQr({double? amount}) async {
    final response = await _apiClient.get(
      ApiEndpoints.receiveQr,
      queryParameters: amount != null ? {'amount': amount} : null,
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) throw DioException(requestOptions: response.requestOptions, response: response, message: 'Invalid receive-qr response');
    final inner = data['data'] is Map<String, dynamic>
        ? data['data'] as Map<String, dynamic>
        : data;
    return ReceiveQrEntity(
      payload: inner['payload']?.toString() ?? '',
      mobileNumber: inner['mobileNumber']?.toString(),
      name: inner['name']?.toString(),
      amount: inner['amount'] is num ? (inner['amount'] as num).toDouble() : null,
      qrImageBase64: inner['qrImageBase64']?.toString(),
    );
  }

  @override
  Future<double> loadMoney({required String mobileNumber, required double amount, String? remarks}) async {
    final response = await _apiClient.post(ApiEndpoints.walletLoad, data: {
      'mobileNumber': mobileNumber,
      'amount': amount,
      if (remarks != null && remarks.isNotEmpty) 'remarks': remarks,
    });
    final data = response.data;
    if (data is! Map<String, dynamic>) throw DioException(requestOptions: response.requestOptions, response: response, message: 'Invalid load response');
    final inner = data['data'] is Map<String, dynamic> ? data['data'] as Map<String, dynamic> : data;
    return inner['balance'] is num ? (inner['balance'] as num).toDouble() : 0.0;
  }

  @override
  Future<double> topup({
    required double amount,
    required String mobileNumber,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.walletTopup,
      data: {'amount': amount, 'mobileNumber': mobileNumber},
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) throw DioException(requestOptions: response.requestOptions, response: response, message: 'Invalid topup response');
    final inner = data['data'] is Map<String, dynamic> ? data['data'] as Map<String, dynamic> : data;
    return inner['balance'] is num ? (inner['balance'] as num).toDouble() : 0.0;
  }

  @override
  Future<void> linkBank({required String accountNumber, required String password}) async {
    await _apiClient.post(ApiEndpoints.walletLinkBank, data: {
      'accountNumber': accountNumber,
      'password': password,
    });
  }

  @override
  Future<void> loginBank({required String mobileNumber, required String password}) async {
    await _apiClient.post(ApiEndpoints.walletLoginBank, data: {
      'mobileNumber': mobileNumber,
      'password': password,
    });
  }
}
