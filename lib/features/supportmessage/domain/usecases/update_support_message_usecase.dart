import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/core/usecases/app_usecase.dart';
import 'package:digital_wallett_system/features/supportmessage/data/repositories/support_message_repository.dart';
import 'package:digital_wallett_system/features/supportmessage/domain/entities/support_message_entity.dart';
import 'package:digital_wallett_system/features/supportmessage/domain/repositories/support_message_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateSupportMessageParams extends Equatable {
  final String id;
  final String message;

  const UpdateSupportMessageParams({required this.id, required this.message});

  @override
  List<Object?> get props => [id, message];
}

final updateSupportMessageUsecaseProvider =
    Provider<UpdateSupportMessageUsecase>((ref) {
      final repository = ref.read(supportMessageRepositoryProvider);
      return UpdateSupportMessageUsecase(repository: repository);
    });

class UpdateSupportMessageUsecase
    implements
        UsecaseWithParams<SupportMessageEntity, UpdateSupportMessageParams> {
  final ISupportMessageRepository _repository;

  UpdateSupportMessageUsecase({required ISupportMessageRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, SupportMessageEntity>> call(
    UpdateSupportMessageParams params,
  ) {
    return _repository.updateMessage(params.id, params.message);
  }
}

