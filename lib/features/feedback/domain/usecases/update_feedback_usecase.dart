import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/core/usecases/app_usecase.dart';
import 'package:digital_wallett_system/features/feedback/data/repositories/feedback_repository.dart';
import 'package:digital_wallett_system/features/feedback/domain/entities/feedback_entity.dart';
import 'package:digital_wallett_system/features/feedback/domain/repositories/feedback_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateFeedbackParams extends Equatable {
  final String id;
  final String feedback;
  final String futureImprovements;

  const UpdateFeedbackParams({
    required this.id,
    required this.feedback,
    required this.futureImprovements,
  });

  @override
  List<Object?> get props => [id, feedback, futureImprovements];
}

final updateFeedbackUsecaseProvider = Provider<UpdateFeedbackUsecase>((ref) {
  final repository = ref.read(feedbackRepositoryProvider);
  return UpdateFeedbackUsecase(repository: repository);
});

class UpdateFeedbackUsecase
    implements UsecaseWithParams<FeedbackEntity, UpdateFeedbackParams> {
  final IFeedbackRepository _repository;

  UpdateFeedbackUsecase({required IFeedbackRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, FeedbackEntity>> call(UpdateFeedbackParams params) {
    return _repository.updateFeedback(
      id: params.id,
      feedback: params.feedback,
      futureImprovements: params.futureImprovements,
    );
  }
}
