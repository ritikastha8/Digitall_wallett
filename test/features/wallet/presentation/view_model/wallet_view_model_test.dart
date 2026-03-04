import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/features/wallet/domain/entities/wallet_entity.dart';
import 'package:digital_wallett_system/features/wallet/domain/usecases/get_balance_usecase.dart';
import 'package:digital_wallett_system/features/wallet/domain/usecases/link_bank_usecase.dart';
import 'package:digital_wallett_system/features/wallet/presentation/state/wallet_state.dart';
import 'package:digital_wallett_system/features/wallet/presentation/view_model/wallet_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

class MockGetBalanceUsecase extends Mock implements GetBalanceUsecase {}
class MockLinkBankUsecase extends Mock implements LinkBankUsecase {}

void main() {
  late MockGetBalanceUsecase mockGetBalance;
  late MockLinkBankUsecase mockLinkBank;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(
      const LinkBankParams(accountNumber: '123456', password: 'pass123'),
    );
  });

  setUp(() {
    mockGetBalance = MockGetBalanceUsecase();
    mockLinkBank = MockLinkBankUsecase();
    container = ProviderContainer(
      overrides: [
        getBalanceUsecaseProvider.overrideWithValue(mockGetBalance),
        linkBankUsecaseProvider.overrideWithValue(mockLinkBank),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('WalletViewModel', () {
    test('build returns initial WalletState', () {
      final state = container.read(walletViewModelProvider);
      expect(state.status, WalletStatus.initial);
      expect(state.wallet, isNull);
    });

    test('loadBalance success sets status loaded and wallet', () async {
      const wallet = WalletEntity(balance: 500.0);
      when(() => mockGetBalance()).thenAnswer((_) async => const Right(wallet));
      await container.read(walletViewModelProvider.notifier).loadBalance();
      final state = container.read(walletViewModelProvider);
      expect(state.status, WalletStatus.loaded);
      expect(state.wallet?.balance, 500.0);
    });

    test('loadBalance failure sets status error and errorMessage', () async {
      when(() => mockGetBalance())
          .thenAnswer((_) async => const Left(ApiFailure(message: 'Network error')));
      await container.read(walletViewModelProvider.notifier).loadBalance();
      final state = container.read(walletViewModelProvider);
      expect(state.status, WalletStatus.error);
      expect(state.errorMessage, 'Network error');
    });

    test('linkBank success returns null', () async {
      when(() => mockLinkBank(any())).thenAnswer((_) async => const Right(null));
      final error = await container
          .read(walletViewModelProvider.notifier)
          .linkBank(accountNumber: '123456', password: 'pass123');

      expect(error, isNull);
    });

    test('linkBank failure returns message', () async {
      when(() => mockLinkBank(any()))
          .thenAnswer((_) async => const Left(ApiFailure(message: 'Link failed')));
      final error = await container
          .read(walletViewModelProvider.notifier)
          .linkBank(accountNumber: '123456', password: 'pass123');

      expect(error, 'Link failed');
    });
  });
}
