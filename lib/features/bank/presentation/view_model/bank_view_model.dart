import 'package:digital_wallett_system/features/bank/domain/usecases/load_from_bank_usecase.dart';
import 'package:digital_wallett_system/features/bank/presentation/state/bank_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bankViewModelProvider = NotifierProvider<BankViewModel, BankState>(
  BankViewModel.new,
);

class BankViewModel extends Notifier<BankState> {
  late final LoadFromBankUsecase _loadFromBankUsecase;

  @override
  BankState build() {
    _loadFromBankUsecase = ref.read(loadFromBankUsecaseProvider);
    return const BankState();
  }

  Future<String?> loadFromBank({
    required String accountNumber,
    required double amount,
  }) async {
    state = state.copyWith(status: BankStatus.loading, errorMessage: null);
    final result = await _loadFromBankUsecase(
      LoadFromBankParams(accountNumber: accountNumber, amount: amount),
    );

    return result.fold((failure) {
      state = state.copyWith(
        status: BankStatus.error,
        errorMessage: failure.message,
      );
      return failure.message;
    }, (_) {
      state = state.copyWith(
        status: BankStatus.success,
        errorMessage: null,
      );
      return null;
    });
  }
}
