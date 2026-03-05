import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/core/usecases/app_usecase.dart';
import 'package:digital_wallett_system/features/reportsupportmessage/data/repositories/support_message_repository.dart';
import 'package:digital_wallett_system/features/reportsupportmessage/domain/entities/support_message_entity.dart';
import 'package:digital_wallett_system/features/reportsupportmessage/domain/repositories/support_message_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateSupportMessageParams extends Equatable {
  final String message;

  const CreateSupportMessageParams({required this.message});

  @override
  List<Object?> get props => [message];
}

final createSupportMessageUsecaseProvider =
    Provider<CreateSupportMessageUsecase>((ref) {
      final repository = ref.read(supportMessageRepositoryProvider);
      return CreateSupportMessageUsecase(repository: repository);
    });

class CreateSupportMessageUsecase
    implements
        UsecaseWithParams<SupportMessageEntity, CreateSupportMessageParams> {
  final ISupportMessageRepository _repository;

  CreateSupportMessageUsecase({required ISupportMessageRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, SupportMessageEntity>> call(
    CreateSupportMessageParams params,
  ) {
    return _repository.createMessage(params.message);
  }
}
