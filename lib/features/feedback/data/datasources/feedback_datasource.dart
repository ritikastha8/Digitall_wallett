// import 'package:digital_wallett_system/features/feedback/data/models/feedback_api_model.dart';

// abstract interface class IFeedbackRemoteDatasource {
//   Future<FeedbackApiModel> createFeedback({
//     required String feedback,
//     required String futureImprovements,
//   });
// }

import 'package:digital_wallett_system/features/feedback/data/models/feedback_api_model.dart';
import 'package:digital_wallett_system/features/feedback/domain/entities/feedback_entity.dart';

/// Contract for local storage (Hive/SharedPrefs)
abstract interface class IFeedbackLocalDatasource {
  Future<void> cacheFeedbacks(List<FeedbackEntity> list);
  List<FeedbackEntity> getCachedFeedbacks();
  Future<void> clearCache();
}

/// Contract for remote API communication (Dio)
abstract interface class IFeedbackRemoteDatasource {
  Future<List<FeedbackApiModel>> getFeedbacks();

  Future<FeedbackApiModel> createFeedback({
    required String feedback,
    required String futureImprovements,
  });

  Future<FeedbackApiModel> updateFeedback({
    required String id,
    required String feedback,
    required String futureImprovements,
  });

  Future<void> deleteFeedback(String id);
}
