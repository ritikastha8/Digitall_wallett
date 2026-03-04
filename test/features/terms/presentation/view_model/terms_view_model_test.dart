import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/features/terms/domain/entities/term_entity.dart';
import 'package:digital_wallett_system/features/terms/domain/usecases/get_terms_usecase.dart';
import 'package:digital_wallett_system/features/terms/presentation/state/terms_state.dart';
import 'package:digital_wallett_system/features/terms/presentation/view_model/terms_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetTermsUsecase extends Mock implements GetTermsUsecase {}

void main() {
  late MockGetTermsUsecase mockGetTermsUsecase;
  late ProviderContainer container;

  setUp(() {
    mockGetTermsUsecase = MockGetTermsUsecase();
    container = ProviderContainer(
      overrides: [
        getTermsUsecaseProvider.overrideWithValue(mockGetTermsUsecase),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('TermsViewModel', () {
    test('build returns initial state', () {
      final state = container.read(termsViewModelProvider);
      expect(state.status, TermsStatus.initial);
      expect(state.terms, isEmpty);
      expect(state.errorMessage, isNull);
    });

    test('loadTerms success sets loaded state', () async {
      const terms = [
        TermEntity(title: 'terms title', content: 'terms content'),
      ];
      when(
        () => mockGetTermsUsecase(),
      ).thenAnswer((_) async => const Right(terms));

      await container.read(termsViewModelProvider.notifier).loadTerms();
      final state = container.read(termsViewModelProvider);

      expect(state.status, TermsStatus.loaded);
      expect(state.terms, terms);
      expect(state.errorMessage, isNull);
    });

    test('loadTerms failure sets error state', () async {
      when(() => mockGetTermsUsecase()).thenAnswer(
        (_) async => const Left(ApiFailure(message: 'Terms failed')),
      );

      await container.read(termsViewModelProvider.notifier).loadTerms();
      final state = container.read(termsViewModelProvider);

      expect(state.status, TermsStatus.error);
      expect(state.errorMessage, 'Terms failed');
    });
  });
}
