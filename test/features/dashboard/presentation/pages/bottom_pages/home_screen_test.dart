import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/services/storage/user_session_service.dart';
import 'package:digital_wallett_system/features/dashboard/presentation/pages/bottom_pages/home_screen.dart';
import 'package:digital_wallett_system/features/wallet/domain/entities/wallet_entity.dart';
import 'package:digital_wallett_system/features/wallet/domain/usecases/get_balance_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockGetBalanceUsecase extends Mock implements GetBalanceUsecase {}

void main() {
  late MockGetBalanceUsecase mockGetBalanceUsecase;
  late SharedPreferences sharedPreferences;

  setUp(() async {
    mockGetBalanceUsecase = MockGetBalanceUsecase();
    SharedPreferences.setMockInitialValues({});
    sharedPreferences = await SharedPreferences.getInstance();
    when(
      () => mockGetBalanceUsecase(),
    ).thenAnswer((_) async => const Right(WalletEntity(balance: 500.0)));
  });

  group('HomesScreen', () {
    testWidgets('UI and basic interaction', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(sharedPreferences),
            getBalanceUsecaseProvider.overrideWithValue(mockGetBalanceUsecase),
          ],
          child: const MaterialApp(home: HomesScreen()),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Welcome'), findsOneWidget);
      expect(find.text('Balance'), findsOneWidget);
      expect(find.text('Operations'), findsOneWidget);
    });
  });
}
