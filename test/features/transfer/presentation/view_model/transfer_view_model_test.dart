import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/features/transfer/domain/entities/transfer_entity.dart';
import 'package:digital_wallett_system/features/transfer/domain/usecases/send_money_usecase.dart';
import 'package:digital_wallett_system/features/transfer/presentation/state/transfer_state.dart';
import 'package:digital_wallett_system/features/transfer/presentation/view_model/transfer_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSendMoneyUsecase extends Mock implements SendMoneyUsecase {}

void main() {
  late MockSendMoneyUsecase mockSendMoneyUsecase;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(
      const SendMoneyParams(recipientMobile: '9800000000', amount: 100, remarks: 'test'),
    );
  });

  setUp(() {
    mockSendMoneyUsecase = MockSendMoneyUsecase();
    container = ProviderContainer(
      overrides: [
        sendMoneyUsecaseProvider.overrideWithValue(mockSendMoneyUsecase),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('TransferViewModel', () {
    test('build returns initial TransferState', () {
      final state = container.read(transferViewModelProvider);
      expect(state.status, TransferStatus.initial);
      expect(state.transfer, isNull);
      expect(state.errorMessage, isNull);
    });

    test('sendMoney success returns true and sets success state', () async {
      const transfer = TransferEntity(
        recipientMobile: '9800000000',
        amount: 100,
        remarks: 'test',
      );
      when(() => mockSendMoneyUsecase(any())).thenAnswer((_) async => const Right(transfer));

      final result = await container.read(transferViewModelProvider.notifier).sendMoney(
            recipientMobile: '9800000000',
            amount: 100,
            remarks: 'test',
          );
      final state = container.read(transferViewModelProvider);

      expect(result, isTrue);
      expect(state.status, TransferStatus.success);
      expect(state.transfer, transfer);
      expect(state.errorMessage, isNull);
    });

    test('sendMoney failure returns false and sets error state', () async {
      when(() => mockSendMoneyUsecase(any()))
          .thenAnswer((_) async => const Left(ApiFailure(message: 'Transfer failed')));

      final result = await container.read(transferViewModelProvider.notifier).sendMoney(
            recipientMobile: '9800000000',
            amount: 100,
            remarks: 'test',
          );
      final state = container.read(transferViewModelProvider);

      expect(result, isFalse);
      expect(state.status, TransferStatus.error);
      expect(state.errorMessage, 'Transfer failed');
    });

    test('reset sets state back to initial', () async {
      when(() => mockSendMoneyUsecase(any()))
          .thenAnswer((_) async => const Left(ApiFailure(message: 'Transfer failed')));
      await container.read(transferViewModelProvider.notifier).sendMoney(
            recipientMobile: '9800000000',
            amount: 100,
            remarks: 'test',
          );

      container.read(transferViewModelProvider.notifier).reset();
      final state = container.read(transferViewModelProvider);

      expect(state, const TransferState());
    });
  });
}
