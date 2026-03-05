import 'package:equatable/equatable.dart';

enum BankStatus {
  initial,
  loading,
  success,
  error,
}

class BankState extends Equatable {
  final BankStatus status;
  final String? errorMessage;

  const BankState({
    this.status = BankStatus.initial,
    this.errorMessage,
  });

  BankState copyWith({
    BankStatus? status,
    String? errorMessage,
  }) {
    return BankState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
