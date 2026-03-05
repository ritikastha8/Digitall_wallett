// import 'package:equatable/equatable.dart';

// enum FeedbackStatus { initial, submitting, success, error }

// class FeedbackState extends Equatable {
//   final FeedbackStatus status;
//   final String? errorMessage;

//   const FeedbackState({
//     this.status = FeedbackStatus.initial,
//     this.errorMessage,
//   });

//   FeedbackState copyWith({
//     FeedbackStatus? status,
//     String? errorMessage,
//   }) {
//     return FeedbackState(
//       status: status ?? this.status,
//       errorMessage: errorMessage,
//     );
//   }

//   @override
//   List<Object?> get props => [status, errorMessage];
// }

import 'package:digital_wallett_system/features/feedback/domain/entities/feedback_entity.dart';
import 'package:equatable/equatable.dart';

enum FeedbackStatus {
  initial,
  loading, // For fetching the list
  loaded, // List fetched successfully
  submitting, // For create/update/delete actions
  success, // Action completed
  error,
}

class FeedbackState extends Equatable {
  final FeedbackStatus status;
  final List<FeedbackEntity> feedbacks; // Added to hold the list of feedback
  final String? errorMessage;

  const FeedbackState({
    this.status = FeedbackStatus.initial,
    this.feedbacks = const [],
    this.errorMessage,
  });

  FeedbackState copyWith({
    FeedbackStatus? status,
    List<FeedbackEntity>? feedbacks,
    String? errorMessage,
  }) {
    return FeedbackState(
      status: status ?? this.status,
      feedbacks: feedbacks ?? this.feedbacks,
      errorMessage:
          errorMessage, // Usually reset to null unless an error occurs
    );
  }

  @override
  List<Object?> get props => [status, feedbacks, errorMessage];
}
