import 'package:digital_wallett_system/features/transactions/domain/usecases/get_my_transactions_usecase.dart';
import 'package:digital_wallett_system/features/transactions/domain/usecases/update_transaction_usecase.dart';
import 'package:digital_wallett_system/features/transactions/domain/usecases/delete_transaction_usecase.dart';
import 'package:digital_wallett_system/features/transactions/presentation/state/transaction_list_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionListViewModelProvider =
    NotifierProvider<TransactionListViewModel, TransactionListState>(
      TransactionListViewModel.new,
    );

class TransactionListViewModel extends Notifier<TransactionListState> {
  late final GetMyTransactionsUsecase _getMyTransactionsUsecase;
  late final UpdateTransactionUsecase _updateTransactionUsecase;
  late final DeleteTransactionUsecase _deleteTransactionUsecase;

  @override
  TransactionListState build() {
    _getMyTransactionsUsecase = ref.read(getMyTransactionsUsecaseProvider);
    _updateTransactionUsecase = ref.read(updateTransactionUsecaseProvider);
    _deleteTransactionUsecase = ref.read(deleteTransactionUsecaseProvider);
    return const TransactionListState();
  }

  Future<void> loadTransactions() async {
    state = state.copyWith(
      status: TransactionListStatus.loading,
      errorMessage: null,
    );
    final result = await _getMyTransactionsUsecase();
    result.fold(
      (failure) {
        state = state.copyWith(
          status: TransactionListStatus.error,
          errorMessage: failure.message,
        );
      },
      (list) {
        state = state.copyWith(
          status: TransactionListStatus.loaded,
          transactions: list,
        );
      },
    );
  }

  Future<String?> updateTransactionRemarks({
    required String id,
    required String remarks,
  }) async {
    final result = await _updateTransactionUsecase(
      UpdateTransactionParams(id: id, body: {'remarks': remarks}),
    );

    return result.fold((failure) => failure.message, (updatedTransaction) {
      final updatedList = state.transactions
          .map((tx) => tx.id == id ? updatedTransaction : tx)
          .toList();
      state = state.copyWith(
        status: TransactionListStatus.loaded,
        transactions: updatedList,
      );
      return null;
    });
  }

  Future<String?> deleteTransactionById(String id) async {
    final result = await _deleteTransactionUsecase(
      DeleteTransactionParams(id: id),
    );

    return result.fold((failure) => failure.message, (_) {
      final updatedList = state.transactions
          .where((tx) => tx.id != id)
          .toList();
      state = state.copyWith(
        status: TransactionListStatus.loaded,
        transactions: updatedList,
      );
      return null;
    });
  }
}
