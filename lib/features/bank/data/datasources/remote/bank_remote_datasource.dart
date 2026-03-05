import 'package:digital_wallett_system/core/api/api_client.dart';
import 'package:digital_wallett_system/core/api/api_endpoints.dart';
import 'package:digital_wallett_system/features/bank/data/datasources/bank_datasource.dart';
import 'package:digital_wallett_system/features/bank/data/models/bank_api_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bankRemoteDatasourceProvider = Provider<IBankRemoteDatasource>((ref) {
  return BankRemoteDatasource(apiClient: ref.read(apiClientProvider));
});

class BankRemoteDatasource implements IBankRemoteDatasource {
  final ApiClient _apiClient;

  BankRemoteDatasource({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<void> seedBank() async {
    await _apiClient.post(ApiEndpoints.bankSeed);
  }

  @override
  Future<BankApiModel> linkBank({
    required String accountNumber,
    required String password,
  }) async {
    final response = await _apiClient.post(ApiEndpoints.bankLink, data: {
      'accountNumber': accountNumber,
      'password': password,
    });
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Invalid link bank response',
      );
    }
    final bank = data['data'] ?? data['bank'] ?? data;
    if (bank is! Map<String, dynamic>) return const BankApiModel(linked: true);
    return BankApiModel.fromJson(bank);
  }

  @override
  Future<void> loadFromBank({required String accountNumber, required double amount}) async {
    await _apiClient.post(ApiEndpoints.bankLoad, data: {
      'accountNumber': accountNumber,
      'amount': amount,
    });
  }
}
