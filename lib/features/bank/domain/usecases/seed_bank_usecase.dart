import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/core/usecases/app_usecase.dart';
import 'package:digital_wallett_system/features/bank/data/repositories/bank_repository.dart';
import 'package:digital_wallett_system/features/bank/domain/repositories/bank_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final seedBankUsecaseProvider = Provider<SeedBankUsecase>((ref) {
  final repository = ref.read(bankRepositoryProvider);
  return SeedBankUsecase(repository: repository);
});

class SeedBankUsecase implements UsecaseWithoutParams<void> {
  final IBankRepository _repository;

  SeedBankUsecase({required IBankRepository repository}) : _repository = repository;

  @override
  Future<Either<Failure, void>> call() => _repository.seedBank();
}
