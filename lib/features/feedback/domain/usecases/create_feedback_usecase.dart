import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/core/usecases/app_usecase.dart';
import 'package:digital_wallett_system/features/feedback/data/repositories/feedback_repository.dart';
import 'package:digital_wallett_system/features/feedback/domain/entities/feedback_entity.dart';
import 'package:digital_wallett_system/features/feedback/domain/repositories/feedback_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateFeedbackParams extends Equatable {
  final String feedback;
  final String futureImprovements;

  const CreateFeedbackParams({
    required this.feedback,
    required this.futureImprovements,
  });

  @override
  List<Object?> get props => [feedback, futureImprovements];
}

final createFeedbackUsecaseProvider = Provider<CreateFeedbackUsecase>((ref) {
  final repository = ref.read(feedbackRepositoryProvider);
  return CreateFeedbackUsecase(repository: repository);
});

class CreateFeedbackUsecase
    implements UsecaseWithParams<FeedbackEntity, CreateFeedbackParams> {
  final IFeedbackRepository _repository;

  CreateFeedbackUsecase({required IFeedbackRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, FeedbackEntity>> call(CreateFeedbackParams params) {
    return _repository.createFeedback(
      feedback: params.feedback,
      futureImprovements: params.futureImprovements,
    );
  }
}
