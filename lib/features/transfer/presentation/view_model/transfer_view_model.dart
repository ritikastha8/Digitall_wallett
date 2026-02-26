import 'package:digital_wallett_system/features/transfer/domain/usecases/send_money_usecase.dart';
import 'package:digital_wallett_system/features/transfer/presentation/state/transfer_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transferViewModelProvider =
    NotifierProvider<TransferViewModel, TransferState>(TransferViewModel.new);

class TransferViewModel extends Notifier<TransferState> {
  late final SendMoneyUsecase _sendMoneyUsecase;

  @override
  TransferState build() {
    _sendMoneyUsecase = ref.read(sendMoneyUsecaseProvider);
    return const TransferState();
  }

  Future<bool> sendMoney({
    required String recipientMobile,
    required double amount,
    required String remarks,
  }) async {
    state = state.copyWith(status: TransferStatus.loading, errorMessage: null);
    final result = await _sendMoneyUsecase(
      SendMoneyParams(
        recipientMobile: recipientMobile,
        amount: amount,
        remarks: remarks,
      ),
    );
    return result.fold(
      (failure) {
        state = state.copyWith(
          status: TransferStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (transfer) {
        state = state.copyWith(
          status: TransferStatus.success,
          transfer: transfer,
        );
        return true;
      },
    );
  }

  void reset() {
    state = const TransferState();
  }
}
