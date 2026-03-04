import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/features/terms/domain/entities/term_entity.dart';
import 'package:digital_wallett_system/features/terms/domain/repositories/term_repository.dart';
import 'package:digital_wallett_system/features/terms/domain/usecases/get_terms_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTermRepository extends Mock implements ITermRepository {}

void main() {
  late MockTermRepository mockRepository;
  late GetTermsUsecase usecase;

  setUp(() {
    mockRepository = MockTermRepository();
    usecase = GetTermsUsecase(repository: mockRepository);
  });

  group('GetTermsUsecase', () {
    test('returns terms when repository call succeeds', () async {
      final terms = [
        const TermEntity(
          id: '1',
          title: 'Terms and Conditions',
          content: 'Sample terms content',
        ),
      ];

      when(() => mockRepository.getTerms()).thenAnswer((_) async => Right(terms));

      final result = await usecase();

      expect(result, Right(terms));
      verify(() => mockRepository.getTerms()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('returns failure when repository call fails', () async {
      const failure = ApiFailure(message: 'Failed to load terms');
      when(() => mockRepository.getTerms())
          .thenAnswer((_) async => const Left(failure));

      final result = await usecase();

      expect(result, const Left(failure));
      verify(() => mockRepository.getTerms()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
