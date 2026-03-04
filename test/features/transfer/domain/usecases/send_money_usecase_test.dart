import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/features/transfer/domain/entities/transfer_entity.dart';
import 'package:digital_wallett_system/features/transfer/domain/repositories/transfer_repository.dart';
import 'package:digital_wallett_system/features/transfer/domain/usecases/send_money_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTransferRepository extends Mock implements ITransferRepository {}

void main() {
  late MockTransferRepository mockRepository;
  late SendMoneyUsecase usecase;
  late SendMoneyParams params;
  late TransferEntity transfer;
  late ApiFailure apiFailure;

  setUpAll(() {
    params = const SendMoneyParams(
      recipientMobile: '9800000001',
      amount: 250.0,
      remarks: 'Lunch',
    );
    transfer = const TransferEntity(
      id: 'tx_1',
      recipientMobile: '9800000001',
      amount: 250.0,
      remarks: 'Lunch',
      createdAt: null,
      status: 'SUCCESS',
    );
    apiFailure = const ApiFailure(message: 'Transfer failed', statusCode: 400);
  });

  setUp(() {
    mockRepository = MockTransferRepository();
    usecase = SendMoneyUsecase(repository: mockRepository);
  });

  group('SendMoneyUsecase', () {
    test('returns Right(TransferEntity) when repository call succeeds', () async {
      when(
        () => mockRepository.sendMoney(
          recipientMobile: params.recipientMobile,
          amount: params.amount,
          remarks: params.remarks,
        ),
      ).thenAnswer((_) async => Right(transfer));

      final result = await usecase(params);

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return transfer entity'),
        (value) => expect(value, transfer),
      );
      verify(
        () => mockRepository.sendMoney(
          recipientMobile: params.recipientMobile,
          amount: params.amount,
          remarks: params.remarks,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('returns Left(Failure) when repository call fails', () async {
      when(
        () => mockRepository.sendMoney(
          recipientMobile: params.recipientMobile,
          amount: params.amount,
          remarks: params.remarks,
        ),
      ).thenAnswer((_) async => Left(apiFailure));

      final result = await usecase(params);

      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<ApiFailure>());
          expect((failure as ApiFailure).message, 'Transfer failed');
          expect(failure.statusCode, 400);
        },
        (_) => fail('Should return failure'),
      );
      verify(
        () => mockRepository.sendMoney(
          recipientMobile: params.recipientMobile,
          amount: params.amount,
          remarks: params.remarks,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('SendMoneyParams supports value equality', () {
      const sameParams = SendMoneyParams(
        recipientMobile: '9800000001',
        amount: 250.0,
        remarks: 'Lunch',
      );

      expect(params, sameParams);
      expect(params.props, ['9800000001', 250.0, 'Lunch']);
    });
  });
}
