import 'package:digital_wallett_system/features/transfer/domain/entities/transfer_entity.dart';
import 'package:equatable/equatable.dart';

enum TransferStatus {
  initial,
  loading,
  success,
  error,
}

class TransferState extends Equatable {
  final TransferStatus status;
  final TransferEntity? transfer;
  final String? errorMessage;

  const TransferState({
    this.status = TransferStatus.initial,
    this.transfer,
    this.errorMessage,
  });

  TransferState copyWith({
    TransferStatus? status,
    TransferEntity? transfer,
    String? errorMessage,
  }) {
    return TransferState(
      status: status ?? this.status,
      transfer: transfer ?? this.transfer,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, transfer, errorMessage];
}
