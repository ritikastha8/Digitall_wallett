import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/features/terms/domain/entities/term_entity.dart';

abstract interface class ITermRepository {
  Future<Either<Failure, List<TermEntity>>> getTerms();
}
