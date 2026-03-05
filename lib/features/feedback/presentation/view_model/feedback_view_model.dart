// import 'package:digital_wallett_system/features/feedback/domain/usecases/create_feedback_usecase.dart';
// import 'package:digital_wallett_system/features/feedback/presentation/state/feedback_state.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final feedbackViewModelProvider =
//     NotifierProvider<FeedbackViewModel, FeedbackState>(FeedbackViewModel.new);

// class FeedbackViewModel extends Notifier<FeedbackState> {
//   late final CreateFeedbackUsecase _createFeedbackUsecase;

//   @override
//   FeedbackState build() {
//     _createFeedbackUsecase = ref.read(createFeedbackUsecaseProvider);
//     return const FeedbackState();
//   }

//   Future<String?> submitFeedback({
//     required String feedback,
//     required String futureImprovements,
//   }) async {
//     state = state.copyWith(
//       status: FeedbackStatus.submitting,
//       errorMessage: null,
//     );

//     final result = await _createFeedbackUsecase(
//       CreateFeedbackParams(
//         feedback: feedback,
//         futureImprovements: futureImprovements,
//       ),
//     );

//     return result.fold((failure) {
//       state = state.copyWith(
//         status: FeedbackStatus.error,
//         errorMessage: failure.message,
//       );
//       return failure.message;
//     }, (_) {
//       state = state.copyWith(
//         status: FeedbackStatus.success,
//         errorMessage: null,
//       );
//       return null;
//     });
//   }
// }

import 'package:digital_wallett_system/features/feedback/domain/usecases/create_feedback_usecase.dart';
import 'package:digital_wallett_system/features/feedback/domain/usecases/delete_feedback_usecase.dart';
import 'package:digital_wallett_system/features/feedback/domain/usecases/get_feedback_usecase.dart';
import 'package:digital_wallett_system/features/feedback/domain/usecases/update_feedback_usecase.dart';
import 'package:digital_wallett_system/features/feedback/presentation/state/feedback_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final feedbackViewModelProvider =
    NotifierProvider<FeedbackViewModel, FeedbackState>(FeedbackViewModel.new);

class FeedbackViewModel extends Notifier<FeedbackState> {
  late final GetFeedbacksUsecase _getFeedbacksUsecase;
  late final CreateFeedbackUsecase _createFeedbackUsecase;
  late final UpdateFeedbackUsecase _updateFeedbackUsecase;
  late final DeleteFeedbackUsecase _deleteFeedbackUsecase;

  @override
  FeedbackState build() {
    _getFeedbacksUsecase = ref.read(getFeedbacksUsecaseProvider);
    _createFeedbackUsecase = ref.read(createFeedbackUsecaseProvider);
    _updateFeedbackUsecase = ref.read(updateFeedbackUsecaseProvider);
    _deleteFeedbackUsecase = ref.read(deleteFeedbackUsecaseProvider);
    return const FeedbackState();
  }

  /// Fetch all feedback entries
  Future<void> loadFeedbacks() async {
    state = state.copyWith(status: FeedbackStatus.loading);
    final result = await _getFeedbacksUsecase();
    result.fold(
      (failure) {
        state = state.copyWith(
          status: FeedbackStatus.error,
          errorMessage: failure.message,
        );
      },
      (feedbacks) {
        state = state.copyWith(
          status: FeedbackStatus.loaded,
          feedbacks: feedbacks,
          errorMessage: null,
        );
      },
    );
  }

  /// Create feedback with two content fields
  Future<String?> submitFeedback({
    required String feedback,
    required String futureImprovements,
  }) async {
    state = state.copyWith(status: FeedbackStatus.submitting);
    final result = await _createFeedbackUsecase(
      CreateFeedbackParams(
        feedback: feedback,
        futureImprovements: futureImprovements,
      ),
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: FeedbackStatus.error,
          errorMessage: failure.message,
        );
        return failure.message;
      },
      (createdFeedback) {
        final updatedList = [createdFeedback, ...state.feedbacks];
        state = state.copyWith(
          status: FeedbackStatus.success,
          feedbacks: updatedList,
          errorMessage: null,
        );
        return null;
      },
    );
  }

  /// Update an existing feedback entry
  Future<String?> updateFeedback({
    required String id,
    required String feedback,
    required String futureImprovements,
  }) async {
    state = state.copyWith(status: FeedbackStatus.submitting);
    final result = await _updateFeedbackUsecase(
      UpdateFeedbackParams(
        id: id,
        feedback: feedback,
        futureImprovements: futureImprovements,
      ),
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: FeedbackStatus.error,
          errorMessage: failure.message,
        );
        return failure.message;
      },
      (updated) {
        final updatedList = state.feedbacks
            .map((item) => item.id == id ? updated : item)
            .toList();
        state = state.copyWith(
          status: FeedbackStatus.success,
          feedbacks: updatedList,
          errorMessage: null,
        );
        return null;
      },
    );
  }

  /// Delete a feedback entry
  Future<String?> deleteFeedback(String id) async {
    state = state.copyWith(status: FeedbackStatus.submitting);
    final result = await _deleteFeedbackUsecase(DeleteFeedbackParams(id: id));

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: FeedbackStatus.error,
          errorMessage: failure.message,
        );
        return failure.message;
      },
      (_) {
        final updatedList = state.feedbacks
            .where((item) => item.id != id)
            .toList();
        state = state.copyWith(
          status: FeedbackStatus.success,
          feedbacks: updatedList,
          errorMessage: null,
        );
        return null;
      },
    );
  }
}
