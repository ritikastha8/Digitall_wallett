import 'package:digital_wallett_system/core/services/hive/hive_service.dart';
import 'package:digital_wallett_system/core/services/storage/user_session_service.dart';
import 'package:digital_wallett_system/features/bank/presentation/pages/load_from_bank_page.dart';
import 'package:digital_wallett_system/features/transfer/presentation/pages/send_money_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Transfer & Bank Integration Tests', () {
    late SharedPreferences sharedPreferences;

    setUpAll(() async {
      await HiveService().init();
      SharedPreferences.setMockInitialValues({});
      sharedPreferences = await SharedPreferences.getInstance();
    });

    group('Send Money Page Integration Tests', () {
      Widget createSendMoneyPage() {
        return ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          ],
          child: const MaterialApp(home: SendMoneyPage()),
        );
      }

      testWidgets('Send Money page should display header and fields', (
        tester,
      ) async {
        await tester.pumpWidget(createSendMoneyPage());
        await tester.pumpAndSettle();

        expect(find.text('Send Money'), findsNWidgets(2));
        expect(find.text('Recipient mobile number'), findsOneWidget);
        expect(find.text('Amount (NPR)'), findsOneWidget);
        expect(find.text('Remarks (optional)'), findsOneWidget);
        expect(find.byType(TextFormField), findsNWidgets(3));
      });

      testWidgets('Send Money page should allow text entry', (tester) async {
        await tester.pumpWidget(createSendMoneyPage());
        await tester.pumpAndSettle();

        final textFields = find.byType(TextFormField);
        await tester.enterText(textFields.at(0), '9800000001');
        await tester.enterText(textFields.at(1), '100');
        await tester.enterText(textFields.at(2), 'For lunch');
        await tester.pump();

        expect(find.text('9800000001'), findsOneWidget);
        expect(find.text('100'), findsOneWidget);
        expect(find.text('For lunch'), findsOneWidget);
      });

      testWidgets('Send Money page should show validation errors', (
        tester,
      ) async {
        await tester.pumpWidget(createSendMoneyPage());
        await tester.pumpAndSettle();

        await tester.tap(find.widgetWithText(ElevatedButton, 'Send Money'));
        await tester.pump();

        expect(find.text('Please enter mobile number'), findsOneWidget);
      });
    });

    group('Load From Bank Page Integration Tests', () {
      Widget createLoadFromBankPage() {
        return ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          ],
          child: const MaterialApp(home: LoadFromBankPage()),
        );
      }

      testWidgets('Load from bank page should display UI elements', (
        tester,
      ) async {
        await tester.pumpWidget(createLoadFromBankPage());
        await tester.pumpAndSettle();

        expect(find.text('Load from Bank'), findsOneWidget);
        expect(find.text('Account number'), findsOneWidget);
        expect(find.text('Amount (NPR)'), findsOneWidget);
        expect(find.text('Load from bank'), findsOneWidget);
      });

      testWidgets('Load from bank page should allow text entry', (
        tester,
      ) async {
        await tester.pumpWidget(createLoadFromBankPage());
        await tester.pumpAndSettle();

        final textFields = find.byType(TextFormField);
        await tester.enterText(textFields.first, '1234567890');
        await tester.enterText(textFields.last, '500');
        await tester.pump();

        expect(find.text('1234567890'), findsOneWidget);
        expect(find.text('500'), findsOneWidget);
      });

      testWidgets('Load from bank page should show validation errors', (
        tester,
      ) async {
        await tester.pumpWidget(createLoadFromBankPage());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Load from bank'));
        await tester.pump();

        expect(find.text('Required'), findsNWidgets(2));
      });
    });
  });
}
