import 'package:digital_wallett_system/features/wallet/domain/usecases/get_balance_usecase.dart';
import 'package:digital_wallett_system/features/wallet/domain/usecases/link_bank_usecase.dart';
import 'package:digital_wallett_system/features/wallet/presentation/state/wallet_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final walletViewModelProvider =
    NotifierProvider<WalletViewModel, WalletState>(WalletViewModel.new);

class WalletViewModel extends Notifier<WalletState> {
  late final GetBalanceUsecase _getBalanceUsecase;
  late final LinkBankUsecase _linkBankUsecase;

  @override
  WalletState build() {
    _getBalanceUsecase = ref.read(getBalanceUsecaseProvider);
    _linkBankUsecase = ref.read(linkBankUsecaseProvider);
    return const WalletState();
  }

  Future<void> loadBalance() async {
    state = state.copyWith(status: WalletStatus.loading, errorMessage: null);
    final result = await _getBalanceUsecase();
    result.fold(
      (failure) {
        state = state.copyWith(
          status: WalletStatus.error,
          errorMessage: failure.message,
        );
      },
      (wallet) {
        state = state.copyWith(
          status: WalletStatus.loaded,
          wallet: wallet,
        );
      },
    );
  }

  Future<String?> linkBank({
    required String accountNumber,
    required String password,
  }) async {
    final result = await _linkBankUsecase(
      LinkBankParams(accountNumber: accountNumber, password: password),
    );
    return result.fold((failure) => failure.message, (_) => null);
  }
}
