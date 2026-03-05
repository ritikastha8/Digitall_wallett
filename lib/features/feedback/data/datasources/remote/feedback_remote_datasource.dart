// import 'package:dio/dio.dart';
// import 'package:digital_wallett_system/core/api/api_client.dart';
// import 'package:digital_wallett_system/core/api/api_endpoints.dart';
// import 'package:digital_wallett_system/features/feedback/data/datasources/feedback_datasource.dart';
// import 'package:digital_wallett_system/features/feedback/data/models/feedback_api_model.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final feedbackRemoteDatasourceProvider = Provider<FeedbackRemoteDatasource>((
//   ref,
// ) {
//   return FeedbackRemoteDatasource(apiClient: ref.read(apiClientProvider));
// });

// class FeedbackRemoteDatasource implements IFeedbackRemoteDatasource {
//   final ApiClient _apiClient;

//   FeedbackRemoteDatasource({required ApiClient apiClient}) : _apiClient = apiClient;

//   @override
//   Future<FeedbackApiModel> createFeedback({
//     required String feedback,
//     required String futureImprovements,
//   }) async {
//     final response = await _apiClient.post(
//       ApiEndpoints.supportMessages,
//       data: {
//         'message': _buildFeedbackMessage(
//           feedback: feedback,
//           futureImprovements: futureImprovements,
//         ),
//       },
//     );
//     return _extractOne(response.data, response);
//   }

//   FeedbackApiModel _extractOne(dynamic data, Response response) {
//     if (data is Map<String, dynamic>) {
//       final candidate = data['data'];
//       if (candidate is Map<String, dynamic>) {
//         return FeedbackApiModel.fromJson(candidate);
//       }
//       if (_looksLikeMessageObject(data)) {
//         return FeedbackApiModel.fromJson(data);
//       }
//     }
//     throw DioException(
//       requestOptions: response.requestOptions,
//       response: response,
//       message: 'Invalid feedback response',
//     );
//   }

//   bool _looksLikeMessageObject(Map<String, dynamic> json) {
//     return json.containsKey('message') ||
//         json.containsKey('body') ||
//         json.containsKey('content');
//   }

//   String _buildFeedbackMessage({
//     required String feedback,
//     required String futureImprovements,
//   }) {
//     return 'Feedback:\n${feedback.trim()}\n\nFuture improvements:\n${futureImprovements.trim()}';
//   }
// }

import 'package:digital_wallett_system/core/api/api_client.dart';
import 'package:digital_wallett_system/core/api/api_endpoints.dart';
import 'package:digital_wallett_system/features/feedback/data/datasources/feedback_datasource.dart';
import 'package:digital_wallett_system/features/feedback/data/models/feedback_api_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final feedbackRemoteDatasourceProvider = Provider<FeedbackRemoteDatasource>((
  ref,
) {
  return FeedbackRemoteDatasource(apiClient: ref.read(apiClientProvider));
});

class FeedbackRemoteDatasource implements IFeedbackRemoteDatasource {
  final ApiClient _apiClient;

  FeedbackRemoteDatasource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<List<FeedbackApiModel>> getFeedbacks() async {
    final response = await _apiClient.get(ApiEndpoints.shareFeedback);
    final data = response.data;

    if (data is! Map<String, dynamic> && data is! List) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Invalid feedback response',
      );
    }

    final list = _extractList(data);
    return list
        .whereType<Map<String, dynamic>>()
        .map(FeedbackApiModel.fromJson)
        // Ensure we only return items that have at least some feedback content
        .where((item) => item.feedback.trim().isNotEmpty)
        .toList();
  }

  @override
  Future<FeedbackApiModel> createFeedback({
    required String feedback,
    required String futureImprovements,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.shareFeedback,
      data: {
        'feedback': feedback.trim(),
        'futureImprovements': futureImprovements.trim(),
      },
    );
    return _extractOne(response.data, response);
  }

  @override
  Future<FeedbackApiModel> updateFeedback({
    required String id,
    required String feedback,
    required String futureImprovements,
  }) async {
    final response = await _apiClient.put(
      ApiEndpoints.shareFeedbackById(id),
      data: {
        'feedback': feedback.trim(),
        'futureImprovements': futureImprovements.trim(),
      },
    );
    return _extractOne(response.data, response);
  }

  @override
  Future<void> deleteFeedback(String id) async {
    await _apiClient.delete(ApiEndpoints.shareFeedbackById(id));
  }

  // Helper to extract a single Feedback object from various API response formats
  FeedbackApiModel _extractOne(dynamic data, Response response) {
    if (data is Map<String, dynamic>) {
      final candidate = data['data'];
      if (candidate is Map<String, dynamic>) {
        return FeedbackApiModel.fromJson(candidate);
      }
      if (candidate is List && candidate.isNotEmpty) {
        final first = candidate.first;
        if (first is Map<String, dynamic>) {
          return FeedbackApiModel.fromJson(first);
        }
      }
      if (_looksLikeFeedbackObject(data)) {
        return FeedbackApiModel.fromJson(data);
      }
    }
    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      message: 'Invalid feedback response structure',
    );
  }

  // Helper to extract a list of feedback from various API response formats
  List<dynamic> _extractList(dynamic data) {
    if (data is List) return data;
    if (data is! Map<String, dynamic>) return const [];

    final candidates = [
      data['data'],
      data['feedbacks'],
      data['items'],
      data['results'],
    ];

    for (final candidate in candidates) {
      if (candidate is List) return candidate;
      if (candidate is Map<String, dynamic>) {
        final nested = _extractList(candidate);
        if (nested.isNotEmpty) return nested;
      }
    }

    if (_looksLikeFeedbackObject(data)) {
      return [data];
    }
    return const [];
  }

  bool _looksLikeFeedbackObject(Map<String, dynamic> json) {
    return json.containsKey('feedback') ||
        json.containsKey('futureImprovements');
  }
}
