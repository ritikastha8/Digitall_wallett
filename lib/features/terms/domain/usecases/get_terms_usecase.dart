import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/core/usecases/app_usecase.dart';
import 'package:digital_wallett_system/features/terms/data/repositories/term_repository.dart';
import 'package:digital_wallett_system/features/terms/domain/entities/term_entity.dart';
import 'package:digital_wallett_system/features/terms/domain/repositories/term_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getTermsUsecaseProvider = Provider<GetTermsUsecase>((ref) {
  final repository = ref.read(termRepositoryProvider);
  return GetTermsUsecase(repository: repository);
});

class GetTermsUsecase implements UsecaseWithoutParams<List<TermEntity>> {
  final ITermRepository _repository;

  GetTermsUsecase({required ITermRepository repository}) : _repository = repository;

  @override
  Future<Either<Failure, List<TermEntity>>> call() {
    return _repository.getTerms();
  }
}
