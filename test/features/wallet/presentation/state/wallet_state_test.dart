import 'package:digital_wallett_system/features/wallet/domain/entities/wallet_entity.dart';
import 'package:digital_wallett_system/features/wallet/presentation/state/wallet_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WalletState', () {
    test('initial state has default values', () {
      const state = WalletState();
      expect(state.status, WalletStatus.initial);
      expect(state.wallet, isNull);
      expect(state.errorMessage, isNull);
    });

    test('copyWith updates status and wallet', () {
      const wallet = WalletEntity(balance: 100.0);
      const initial = WalletState();
      final updated = initial.copyWith(
        status: WalletStatus.loaded,
        wallet: wallet,
      );
      expect(updated.status, WalletStatus.loaded);
      expect(updated.wallet?.balance, 100.0);
    });

    test('copyWith preserves errorMessage when not provided', () {
      const initial = WalletState(errorMessage: 'err');
      final updated = initial.copyWith(status: WalletStatus.error);
      expect(updated.errorMessage, 'err');
    });
  });
}
