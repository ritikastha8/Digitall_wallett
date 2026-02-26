import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/features/supportmessage/domain/entities/support_message_entity.dart';

abstract interface class ISupportMessageRepository {
  Future<Either<Failure, List<SupportMessageEntity>>> getMessages();
  Future<Either<Failure, SupportMessageEntity>> createMessage(String message);
  Future<Either<Failure, SupportMessageEntity>> updateMessage(
    String id,
    String message,
  );
  Future<Either<Failure, void>> deleteMessage(String id);
}

