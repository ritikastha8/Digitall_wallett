import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/features/bank/domain/usecases/load_from_bank_usecase.dart';
import 'package:digital_wallett_system/features/bank/presentation/state/bank_state.dart';
import 'package:digital_wallett_system/features/bank/presentation/view_model/bank_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoadFromBankUsecase extends Mock implements LoadFromBankUsecase {}

void main() {
  late MockLoadFromBankUsecase mockLoadFromBankUsecase;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(
      const LoadFromBankParams(accountNumber: '123456', amount: 100),
    );
  });

  setUp(() {
    mockLoadFromBankUsecase = MockLoadFromBankUsecase();
    container = ProviderContainer(
      overrides: [
        loadFromBankUsecaseProvider.overrideWithValue(mockLoadFromBankUsecase),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('BankViewModel', () {
    test('build returns initial state', () {
      final state = container.read(bankViewModelProvider);
      expect(state.status, BankStatus.initial);
      expect(state.errorMessage, isNull);
    });

    test('loadFromBank success sets success state', () async {
      when(
        () => mockLoadFromBankUsecase(any()),
      ).thenAnswer((_) async => const Right(null));

      final error = await container
          .read(bankViewModelProvider.notifier)
          .loadFromBank(accountNumber: '123456', amount: 100);

      final state = container.read(bankViewModelProvider);
      expect(error, isNull);
      expect(state.status, BankStatus.success);
      expect(state.errorMessage, isNull);
    });

    test('loadFromBank failure sets error state', () async {
      when(() => mockLoadFromBankUsecase(any())).thenAnswer(
        (_) async => const Left(ApiFailure(message: 'Load failed')),
      );

      final error = await container
          .read(bankViewModelProvider.notifier)
          .loadFromBank(accountNumber: '123456', amount: 100);

      final state = container.read(bankViewModelProvider);
      expect(error, 'Load failed');
      expect(state.status, BankStatus.error);
      expect(state.errorMessage, 'Load failed');
    });
  });
}
