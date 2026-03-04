import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/features/transactions/domain/entities/transaction_entity.dart';
import 'package:digital_wallett_system/features/transactions/domain/usecases/delete_transaction_usecase.dart';
import 'package:digital_wallett_system/features/transactions/domain/usecases/get_my_transactions_usecase.dart';
import 'package:digital_wallett_system/features/transactions/domain/usecases/update_transaction_usecase.dart';
import 'package:digital_wallett_system/features/transactions/presentation/state/transaction_list_state.dart';
import 'package:digital_wallett_system/features/transactions/presentation/view_model/transaction_list_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

class MockGetMyTransactionsUsecase extends Mock implements GetMyTransactionsUsecase {}
class MockUpdateTransactionUsecase extends Mock implements UpdateTransactionUsecase {}
class MockDeleteTransactionUsecase extends Mock implements DeleteTransactionUsecase {}

void main() {
  late MockGetMyTransactionsUsecase mockGetTransactions;
  late MockUpdateTransactionUsecase mockUpdateTransaction;
  late MockDeleteTransactionUsecase mockDeleteTransaction;
  late ProviderContainer container;

  setUp(() {
    mockGetTransactions = MockGetMyTransactionsUsecase();
    mockUpdateTransaction = MockUpdateTransactionUsecase();
    mockDeleteTransaction = MockDeleteTransactionUsecase();
    container = ProviderContainer(
      overrides: [
        getMyTransactionsUsecaseProvider.overrideWithValue(mockGetTransactions),
        updateTransactionUsecaseProvider.overrideWithValue(mockUpdateTransaction),
        deleteTransactionUsecaseProvider.overrideWithValue(mockDeleteTransaction),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('TransactionListViewModel', () {
    test('build returns initial TransactionListState', () {
      final state = container.read(transactionListViewModelProvider);
      expect(state.status, TransactionListStatus.initial);
      expect(state.transactions, isEmpty);
    });

    test('loadTransactions success sets status loaded and transactions', () async {
      final list = [
        const TransactionEntity(type: 'send', amount: 50),
      ];
      when(() => mockGetTransactions()).thenAnswer((_) async => Right(list));
      await container.read(transactionListViewModelProvider.notifier).loadTransactions();
      final state = container.read(transactionListViewModelProvider);
      expect(state.status, TransactionListStatus.loaded);
      expect(state.transactions.length, 1);
      expect(state.transactions.first.amount, 50);
    });

    test('loadTransactions failure sets status error and errorMessage', () async {
      when(() => mockGetTransactions())
          .thenAnswer((_) async => const Left(ApiFailure(message: 'Load failed')));
      await container.read(transactionListViewModelProvider.notifier).loadTransactions();
      final state = container.read(transactionListViewModelProvider);
      expect(state.status, TransactionListStatus.error);
      expect(state.errorMessage, 'Load failed');
    });
  });
}
