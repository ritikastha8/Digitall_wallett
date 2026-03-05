import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/features/auth/domain/entities/auth_entity.dart';
import 'package:digital_wallett_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:digital_wallett_system/features/auth/domain/usecases/register_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockIAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late RegisterUsecase usecase;
  late MockIAuthRepository mockRepo;

  setUpAll(() {
    registerFallbackValue(
      const AuthEntity(
        fullName: 'fallback',
        mobileNumber: '9800000000',
        email: 'fallback@email.com',
      ),
    );
  });

  setUp(() {
    mockRepo = MockIAuthRepository();
    usecase = RegisterUsecase(authRepository: mockRepo);
  });

  const tFullName = 'Test User';
  const tMobileNumber = '9811111111';
  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tConfirmPassword = 'password123';
  const tProfilePicture = 'https://example.com/pic.jpg';

  group('RegisterUsecase', () {
    test('should return true when registration is successful', () async {
      when(() => mockRepo.register(any())).thenAnswer((_) async => const Right(true));

      final result = await usecase(
        const RegisterUsecaseParams(
          fullName: tFullName,
          mobileNumber: tMobileNumber,
          email: tEmail,
          password: tPassword,
          confirmPassword: tConfirmPassword,
        ),
      );

      expect(result, const Right(true));
      verify(() => mockRepo.register(any())).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('should pass AuthEntity with correct values to repository', () async {
      AuthEntity? capturedEntity;
      when(() => mockRepo.register(any())).thenAnswer((invocation) {
        capturedEntity = invocation.positionalArguments[0] as AuthEntity;
        return Future.value(const Right(true));
      });

      await usecase(
        const RegisterUsecaseParams(
          fullName: tFullName,
          mobileNumber: tMobileNumber,
          email: tEmail,
          password: tPassword,
          confirmPassword: tConfirmPassword,
          profilePicture: tProfilePicture,
        ),
      );

      expect(capturedEntity?.fullName, tFullName);
      expect(capturedEntity?.mobileNumber, tMobileNumber);
      expect(capturedEntity?.email, tEmail);
      expect(capturedEntity?.password, tPassword);
      expect(capturedEntity?.confirmPassword, tConfirmPassword);
      expect(capturedEntity?.profilePicture, tProfilePicture);
    });

    test('should handle optional parameters correctly', () async {
      AuthEntity? capturedEntity;
      when(() => mockRepo.register(any())).thenAnswer((invocation) {
        capturedEntity = invocation.positionalArguments[0] as AuthEntity;
        return Future.value(const Right(true));
      });

      await usecase(
        const RegisterUsecaseParams(
          fullName: tFullName,
          mobileNumber: tMobileNumber,
          email: tEmail,
          password: tPassword,
          confirmPassword: tConfirmPassword,
        ),
      );

      expect(capturedEntity?.profilePicture, isNull);
    });

    test('should return failure when registration fails', () async {
      const failure = ApiFailure(message: 'Email already exists');
      when(() => mockRepo.register(any())).thenAnswer((_) async => const Left(failure));

      final result = await usecase(
        const RegisterUsecaseParams(
          fullName: tFullName,
          mobileNumber: tMobileNumber,
          email: tEmail,
          password: tPassword,
          confirmPassword: tConfirmPassword,
        ),
      );

      expect(result, const Left(failure));
      verify(() => mockRepo.register(any())).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('should return ApiFailure when there is no internet', () async {
      const failure = ApiFailure(message: 'No internet connection');
      when(() => mockRepo.register(any())).thenAnswer((_) async => const Left(failure));

      final result = await usecase(
        const RegisterUsecaseParams(
          fullName: tFullName,
          mobileNumber: tMobileNumber,
          email: tEmail,
          password: tPassword,
          confirmPassword: tConfirmPassword,
        ),
      );

      expect(result, const Left(failure));
      verify(() => mockRepo.register(any())).called(1);
    });
  });
}
