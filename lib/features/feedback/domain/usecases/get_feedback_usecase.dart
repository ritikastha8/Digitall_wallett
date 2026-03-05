import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/core/usecases/app_usecase.dart';
import 'package:digital_wallett_system/features/feedback/data/repositories/feedback_repository.dart';
import 'package:digital_wallett_system/features/feedback/domain/entities/feedback_entity.dart';
import 'package:digital_wallett_system/features/feedback/domain/repositories/feedback_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getFeedbacksUsecaseProvider = Provider<GetFeedbacksUsecase>((ref) {
  final repository = ref.read(feedbackRepositoryProvider);
  return GetFeedbacksUsecase(repository: repository);
});

class GetFeedbacksUsecase
    implements UsecaseWithoutParams<List<FeedbackEntity>> {
  final IFeedbackRepository _repository;

  GetFeedbacksUsecase({required IFeedbackRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, List<FeedbackEntity>>> call() {
    return _repository.getFeedbacks();
  }
}
