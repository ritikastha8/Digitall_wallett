import 'package:digital_wallett_system/features/supportmessage/domain/entities/support_message_entity.dart';
import 'package:equatable/equatable.dart';

enum SupportMessageStatus {
  initial,
  loading,
  loaded,
  submitting,
  error,
}

class SupportMessageState extends Equatable {
  final SupportMessageStatus status;
  final List<SupportMessageEntity> messages;
  final String? errorMessage;

  const SupportMessageState({
    this.status = SupportMessageStatus.initial,
    this.messages = const [],
    this.errorMessage,
  });

  SupportMessageState copyWith({
    SupportMessageStatus? status,
    List<SupportMessageEntity>? messages,
    String? errorMessage,
  }) {
    return SupportMessageState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, messages, errorMessage];
}

