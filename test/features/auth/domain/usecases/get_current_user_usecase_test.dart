import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/features/auth/domain/entities/auth_entity.dart';
import 'package:digital_wallett_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:digital_wallett_system/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockIAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late GetCurrentUserUsecase usecase;
  late MockIAuthRepository mockRepo;

  setUp(() {
    mockRepo = MockIAuthRepository();
    usecase = GetCurrentUserUsecase(authRepository: mockRepo);
  });

  const tUser = AuthEntity(
    authId: '1',
    fullName: 'Test User',
    mobileNumber: '9811111111',
    email: 'test@example.com',
  );

  group('GetCurrentUserUsecase', () {
    test('should return AuthEntity when user is authenticated', () async {
      when(
        () => mockRepo.getCurrentUser(),
      ).thenAnswer((_) async => const Right(tUser));

      final result = await usecase();

      expect(result, const Right(tUser));
      verify(() => mockRepo.getCurrentUser()).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('should return failure when user is not authenticated', () async {
      const failure = ApiFailure(message: 'User not authenticated');
      when(
        () => mockRepo.getCurrentUser(),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase();

      expect(result, const Left(failure));
      verify(() => mockRepo.getCurrentUser()).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test(
      'should return LocalDatabaseFailure when local storage fails',
      () async {
        const failure = LocalDatabaseFailure(
          message: 'Failed to read user data',
        );
        when(
          () => mockRepo.getCurrentUser(),
        ).thenAnswer((_) async => const Left(failure));

        final result = await usecase();

        expect(result, const Left(failure));
        verify(() => mockRepo.getCurrentUser()).called(1);
      },
    );

    test('should return user with all fields populated', () async {
      const userWithAllFields = AuthEntity(
        authId: '1',
        fullName: 'Test User',
        mobileNumber: '1234567890',
        email: 'test@example.com',
        profilePicture: 'https://example.com/pic.jpg',
        token: 'token_123',
      );
      when(
        () => mockRepo.getCurrentUser(),
      ).thenAnswer((_) async => const Right(userWithAllFields));

      final result = await usecase();

      result.fold((failure) => fail('Should return user'), (user) {
        expect(user.authId, '1');
        expect(user.fullName, 'Test User');
        expect(user.mobileNumber, '1234567890');
        expect(user.email, 'test@example.com');
        expect(user.profilePicture, 'https://example.com/pic.jpg');
        expect(user.token, 'token_123');
      });
    });
  });
}
