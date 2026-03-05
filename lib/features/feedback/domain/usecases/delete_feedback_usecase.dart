import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/core/usecases/app_usecase.dart';
import 'package:digital_wallett_system/features/feedback/domain/repositories/feedback_repository.dart';
import 'package:digital_wallett_system/features/feedback/data/repositories/feedback_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteFeedbackParams extends Equatable {
  final String id;

  const DeleteFeedbackParams({required this.id});

  @override
  List<Object?> get props => [id];
}

final deleteFeedbackUsecaseProvider = Provider<DeleteFeedbackUsecase>((ref) {
  final repository = ref.read(feedbackRepositoryProvider);
  return DeleteFeedbackUsecase(repository: repository);
});

class DeleteFeedbackUsecase
    implements UsecaseWithParams<void, DeleteFeedbackParams> {
  final IFeedbackRepository _repository;

  DeleteFeedbackUsecase({required IFeedbackRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, void>> call(DeleteFeedbackParams params) {
    return _repository.deleteFeedback(params.id);
  }
}
