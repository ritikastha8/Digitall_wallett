import 'package:digital_wallett_system/features/transactions/domain/entities/transaction_entity.dart';
import 'package:equatable/equatable.dart';

enum TransactionListStatus {
  initial,
  loading,
  loaded,
  error,
}

class TransactionListState extends Equatable {
  final TransactionListStatus status;
  final List<TransactionEntity> transactions;
  final String? errorMessage;

  const TransactionListState({
    this.status = TransactionListStatus.initial,
    this.transactions = const [],
    this.errorMessage,
  });

  TransactionListState copyWith({
    TransactionListStatus? status,
    List<TransactionEntity>? transactions,
    String? errorMessage,
  }) {
    return TransactionListState(
      status: status ?? this.status,
      transactions: transactions ?? this.transactions,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, transactions, errorMessage];
}
