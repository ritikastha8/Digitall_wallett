import 'package:digital_wallett_system/features/transactions/domain/entities/transaction_entity.dart';
import 'package:digital_wallett_system/features/transactions/presentation/state/transaction_list_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TransactionListState', () {
    test('initial state has empty transactions', () {
      const state = TransactionListState();
      expect(state.status, TransactionListStatus.initial);
      expect(state.transactions, isEmpty);
      expect(state.errorMessage, isNull);
    });

    test('copyWith updates transactions list', () {
      const initial = TransactionListState();
      final list = [
        const TransactionEntity(type: 'send', amount: 10),
      ];
      final updated = initial.copyWith(
        status: TransactionListStatus.loaded,
        transactions: list,
      );
      expect(updated.transactions.length, 1);
      expect(updated.transactions.first.amount, 10);
    });
  });
}
