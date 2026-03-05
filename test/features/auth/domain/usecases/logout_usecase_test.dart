import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/features/auth/domain/repositories/auth_repository.dart';
import 'package:digital_wallett_system/features/auth/domain/usecases/logout_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockIAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late LogoutUsecase usecase;
  late MockIAuthRepository mockRepo;

  setUp(() {
    mockRepo = MockIAuthRepository();
    usecase = LogoutUsecase(authRepository: mockRepo);
  });

  group('LogoutUsecase', () {
    test('should return true when logout is successful', () async {
      when(() => mockRepo.logout()).thenAnswer((_) async => const Right(true));

      final result = await usecase();

      expect(result, const Right(true));
      verify(() => mockRepo.logout()).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('should return failure when logout fails', () async {
      const failure = ApiFailure(message: 'Logout failed');
      when(
        () => mockRepo.logout(),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase();

      expect(result, const Left(failure));
      verify(() => mockRepo.logout()).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test(
      'should return LocalDatabaseFailure when clearing local data fails',
      () async {
        const failure = LocalDatabaseFailure(
          message: 'Failed to clear local data',
        );
        when(
          () => mockRepo.logout(),
        ).thenAnswer((_) async => const Left(failure));

        final result = await usecase();

        expect(result, const Left(failure));
        verify(() => mockRepo.logout()).called(1);
      },
    );

    test('should return ApiFailure when there is no internet', () async {
      const failure = ApiFailure(message: 'No internet connection');
      when(
        () => mockRepo.logout(),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase();

      expect(result, const Left(failure));
      verify(() => mockRepo.logout()).called(1);
    });
  });
}
