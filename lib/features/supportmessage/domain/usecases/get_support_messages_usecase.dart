import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/core/usecases/app_usecase.dart';
import 'package:digital_wallett_system/features/supportmessage/data/repositories/support_message_repository.dart';
import 'package:digital_wallett_system/features/supportmessage/domain/entities/support_message_entity.dart';
import 'package:digital_wallett_system/features/supportmessage/domain/repositories/support_message_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getSupportMessagesUsecaseProvider = Provider<GetSupportMessagesUsecase>((
  ref,
) {
  final repository = ref.read(supportMessageRepositoryProvider);
  return GetSupportMessagesUsecase(repository: repository);
});

class GetSupportMessagesUsecase
    implements UsecaseWithoutParams<List<SupportMessageEntity>> {
  final ISupportMessageRepository _repository;

  GetSupportMessagesUsecase({required ISupportMessageRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, List<SupportMessageEntity>>> call() {
    return _repository.getMessages();
  }
}

