import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/core/usecases/app_usecase.dart';
import 'package:digital_wallett_system/features/supportmessage/data/repositories/support_message_repository.dart';
import 'package:digital_wallett_system/features/supportmessage/domain/repositories/support_message_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteSupportMessageParams extends Equatable {
  final String id;

  const DeleteSupportMessageParams({required this.id});

  @override
  List<Object?> get props => [id];
}

final deleteSupportMessageUsecaseProvider =
    Provider<DeleteSupportMessageUsecase>((ref) {
      final repository = ref.read(supportMessageRepositoryProvider);
      return DeleteSupportMessageUsecase(repository: repository);
    });

class DeleteSupportMessageUsecase
    implements UsecaseWithParams<void, DeleteSupportMessageParams> {
  final ISupportMessageRepository _repository;

  DeleteSupportMessageUsecase({required ISupportMessageRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, void>> call(DeleteSupportMessageParams params) {
    return _repository.deleteMessage(params.id);
  }
}

