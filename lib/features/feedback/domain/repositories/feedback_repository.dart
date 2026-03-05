// import 'package:dartz/dartz.dart';
// import 'package:digital_wallett_system/core/errors/failures.dart';
// import 'package:digital_wallett_system/features/feedback/domain/entities/feedback_entity.dart';

// abstract interface class IFeedbackRepository {
//   Future<Either<Failure, FeedbackEntity>> createFeedback({
//     required String feedback,
//     required String futureImprovements,
//   });
// }

import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/features/feedback/domain/entities/feedback_entity.dart';

abstract interface class IFeedbackRepository {
  /// Fetch all feedback entries for the user
  Future<Either<Failure, List<FeedbackEntity>>> getFeedbacks();

  /// Create a new feedback entry with two content fields
  Future<Either<Failure, FeedbackEntity>> createFeedback({
    required String feedback,
    required String futureImprovements,
  });

  /// Update an existing feedback entry
  Future<Either<Failure, FeedbackEntity>> updateFeedback({
    required String id,
    required String feedback,
    required String futureImprovements,
  });

  /// Delete a feedback entry by its unique ID
  Future<Either<Failure, void>> deleteFeedback(String id);
}
