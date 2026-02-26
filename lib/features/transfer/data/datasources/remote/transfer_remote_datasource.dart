import 'package:digital_wallett_system/core/api/api_client.dart';
import 'package:digital_wallett_system/core/api/api_endpoints.dart';
import 'package:digital_wallett_system/features/transfer/domain/entities/transfer_entity.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transferRemoteDatasourceProvider = Provider<TransferRemoteDatasource>((ref) {
  return TransferRemoteDatasource(apiClient: ref.read(apiClientProvider));
});

abstract interface class ITransferRemoteDatasource {
  Future<TransferEntity> sendMoney({
    required String recipientMobile,
    required double amount,
    required String remarks,
  });
}

class TransferRemoteDatasource implements ITransferRemoteDatasource {
  final ApiClient _apiClient;

  TransferRemoteDatasource({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<TransferEntity> sendMoney({
    required String recipientMobile,
    required double amount,
    required String remarks,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.transfer,
      data: {
        'toMobileNumber': recipientMobile,
        'amount': amount,
        'remarks': remarks,
      },
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Invalid transfer response',
      );
    }
    final inner = data['data'] is Map<String, dynamic>
        ? data['data'] as Map<String, dynamic>
        : data as Map<String, dynamic>;
    final to = inner['to']?.toString() ?? recipientMobile;
    final amountResponse = inner['amount'] is num
        ? (inner['amount'] as num).toDouble()
        : amount;
    return TransferEntity(
      id: null,
      recipientMobile: to,
      amount: amountResponse,
      remarks: remarks,
      createdAt: null,
      status: null,
    );
  }
}
