import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/features/auth/domain/entities/auth_entity.dart';
import 'package:digital_wallett_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:digital_wallett_system/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockIAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late LoginUsecase usecase;
  late MockIAuthRepository mockRepo;

  setUp(() {
    mockRepo = MockIAuthRepository();
    usecase = LoginUsecase(authRepository: mockRepo);
  });

  const tMobileNumber = '9811111111';
  const tPassword = 'password123';

  const tParams = LoginUsecaseParams(
    mobileNumber: '9811111111',
    password: tPassword,
  );

  const tUser = AuthEntity(
    fullName: 'fullName',
    mobileNumber: 'mobileNumber',
    email: 'email',
  );

  group('LoginUsecase', () {
    test('should return AuthEntity when login is successful', () async {
      when(
        () => mockRepo.login(tMobileNumber, tPassword),
      ).thenAnswer((_) async => const Right(tUser));

      final result = await usecase(tParams);

      expect(result, const Right(tUser));
      verify(() => mockRepo.login(tMobileNumber, tPassword)).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('should return failure when login fails', () async {
      const failure = ApiFailure(message: 'Invalid credentials');

      when(
        () => mockRepo.login(tMobileNumber, tPassword),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase(tParams);

      expect(result, const Left(failure));
      verify(() => mockRepo.login(tMobileNumber, tPassword)).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('should return ApiFailure when internet is unavailable', () async {
      const failure = ApiFailure(message: 'No internet');

      when(
        () => mockRepo.login(tMobileNumber, tPassword),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase(tParams);

      expect(result, const Left(failure));
      verify(() => mockRepo.login(tMobileNumber, tPassword)).called(1);
    });

    test('should pass correct mobile number and password to repository', () async {
      when(
        () => mockRepo.login(any(), any()),
      ).thenAnswer((_) async => const Right(tUser));

      await usecase(tParams);

      verify(() => mockRepo.login(tMobileNumber, tPassword)).called(1);
    });

    test(
      'should succeed with correct credentials and fail with wrong credentials',
      () async {
        const wrongMobileNumber = '9800000000';
        const wrongPassword = 'wrongpassword';
        const failure = ApiFailure(message: 'Invalid credentials');

        when(() => mockRepo.login(any(), any())).thenAnswer((invocation) async {
          final mobileNumber = invocation.positionalArguments[0] as String;
          final password = invocation.positionalArguments[1] as String;

          if (mobileNumber == tMobileNumber && password == tPassword) {
            return const Right(tUser);
          }
          return const Left(failure);
        });

        final successResult = await usecase(tParams);
        expect(successResult, const Right(tUser));

        final wrongMobileResult = await usecase(
          const LoginUsecaseParams(
            mobileNumber: wrongMobileNumber,
            password: tPassword,
          ),
        );
        expect(wrongMobileResult, const Left(failure));

        final wrongPasswordResult = await usecase(
          const LoginUsecaseParams(
            mobileNumber: tMobileNumber,
            password: wrongPassword,
          ),
        );
        expect(wrongPasswordResult, const Left(failure));
      },
    );

  });
}
