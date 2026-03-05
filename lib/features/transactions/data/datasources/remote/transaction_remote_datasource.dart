import 'package:digital_wallett_system/core/api/api_client.dart';
import 'package:digital_wallett_system/core/api/api_endpoints.dart';
import 'package:digital_wallett_system/features/transactions/domain/entities/transaction_entity.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionRemoteDatasourceProvider = Provider<TransactionRemoteDatasource>((ref) {
  return TransactionRemoteDatasource(apiClient: ref.read(apiClientProvider));
});

abstract interface class ITransactionRemoteDatasource {
  Future<List<TransactionEntity>> getMyTransactions();
  Future<TransactionEntity> logTransaction(Map<String, dynamic> body);
  Future<TransactionEntity> getTransactionById(String id);
  Future<TransactionEntity> updateTransaction(String id, Map<String, dynamic> body);
  Future<void> deleteTransaction(String id);
}

class TransactionRemoteDatasource implements ITransactionRemoteDatasource {
  final ApiClient _apiClient;

  TransactionRemoteDatasource({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<List<TransactionEntity>> getMyTransactions() async {
    final response = await _apiClient.get(ApiEndpoints.myTransactions);
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Invalid transactions response',
      );
    }
    final list = data['data'];
    if (list is! List) return [];
    final List<TransactionEntity> result = [];
    for (final item in list) {
      if (item is! Map<String, dynamic>) continue;
      result.add(_parseTransaction(item));
    }
    return result;
  }

  @override
  Future<TransactionEntity> logTransaction(Map<String, dynamic> body) async {
    final response = await _apiClient.post(ApiEndpoints.transactionLog, data: body);
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Invalid log transaction response',
      );
    }
    final inner = data['data'] is Map<String, dynamic> ? data['data'] as Map<String, dynamic> : data as Map<String, dynamic>;
    return _parseTransaction(inner);
  }

  @override
  Future<TransactionEntity> getTransactionById(String id) async {
    final response = await _apiClient.get(ApiEndpoints.transactionById(id));
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Invalid transaction response',
      );
    }
    final inner = data['data'] is Map<String, dynamic> ? data['data'] as Map<String, dynamic> : data as Map<String, dynamic>;
    return _parseTransaction(inner);
  }

  @override
  Future<TransactionEntity> updateTransaction(String id, Map<String, dynamic> body) async {
    final response = await _apiClient.put(ApiEndpoints.transactionById(id), data: body);
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Invalid update transaction response',
      );
    }
    final inner = data['data'] is Map<String, dynamic> ? data['data'] as Map<String, dynamic> : data as Map<String, dynamic>;
    return _parseTransaction(inner);
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await _apiClient.delete(ApiEndpoints.transactionById(id));
  }

  TransactionEntity _parseTransaction(Map<String, dynamic> json) {
    final amount = json['amount'] is num ? (json['amount'] as num).toDouble() : 0.0;
    final createdAt = json['createdAt'] != null
        ? DateTime.tryParse(json['createdAt'].toString())
        : null;
    return TransactionEntity(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      type: json['type']?.toString() ?? 'Unknown',
      mobileNumber: json['mobileNumber']?.toString(),
      toMobileNumber: json['toMobileNumber']?.toString(),
      amount: amount,
      remarks: json['remarks']?.toString(),
      createdAt: createdAt,
      status: json['status']?.toString(),
    );
  }
}
