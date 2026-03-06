import 'package:digital_wallett_system/core/services/hive/hive_service.dart';
import 'package:digital_wallett_system/core/services/storage/user_session_service.dart';
import 'package:digital_wallett_system/features/auth/presentation/pages/login_page.dart';
import 'package:digital_wallett_system/features/auth/presentation/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Auth Integration Tests', () {
    late SharedPreferences sharedPreferences;

    setUpAll(() async {
      await HiveService().init();
      SharedPreferences.setMockInitialValues({});
      sharedPreferences = await SharedPreferences.getInstance();
    });

    group('Login Page Integration Tests', () {
      Widget createLoginPage() {
        return ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          ],
          child: const MaterialApp(home: LoginPage()),
        );
      }

      testWidgets('Login page should display all UI elements', (tester) async {
        await tester.pumpWidget(createLoginPage());
        await tester.pumpAndSettle();

        expect(find.text('Welcome Back!'), findsOneWidget);
        expect(find.text('Sign in to continue'), findsOneWidget);
        expect(find.text('Mobile'), findsOneWidget);
        expect(find.text('Password'), findsOneWidget);
        expect(find.byType(TextFormField), findsNWidgets(2));
        expect(find.text('Log In'), findsOneWidget);
        expect(find.text('Forgot Password?'), findsOneWidget);
        expect(find.text('Register'), findsOneWidget);
      });

      testWidgets('Login page should allow text entry', (tester) async {
        await tester.pumpWidget(createLoginPage());
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextFormField).first, '9800000000');
        await tester.enterText(find.byType(TextFormField).last, 'password123');
        await tester.pump();

        expect(find.text('9800000000'), findsOneWidget);
        final passwordField = tester.widget<TextFormField>(
          find.byType(TextFormField).last,
        );
        expect(passwordField.controller?.text, 'password123');
      });

      testWidgets('Login page should toggle password visibility', (
        tester,
      ) async {
        await tester.pumpWidget(createLoginPage());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
        await tester.tap(find.byIcon(Icons.visibility_outlined));
        await tester.pump();
        expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
      });

      testWidgets('Login page should show validation errors', (tester) async {
        await tester.pumpWidget(createLoginPage());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Log In'));
        await tester.pump();

        expect(find.text('Please enter mobile number'), findsOneWidget);
      });
    });

    group('Register Page Integration Tests', () {
      Widget createRegisterPage() {
        return ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          ],
          child: const MaterialApp(home: RegisterPage()),
        );
      }

      testWidgets('Register page should display all UI elements', (
        tester,
      ) async {
        await tester.pumpWidget(createRegisterPage());
        await tester.pumpAndSettle();

        expect(find.text('Register New Account'), findsOneWidget);
        expect(
          find.text('Create your account to start using NovaCash'),
          findsOneWidget,
        );
        expect(find.byType(TextFormField), findsNWidgets(5));
        expect(find.text('Register Account'), findsOneWidget);
        expect(find.text('Log In'), findsOneWidget);
      });

      testWidgets('Register page should allow text entry in name field', (
        tester,
      ) async {
        await tester.pumpWidget(createRegisterPage());
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextFormField).first, 'John Doe');
        await tester.pump();

        expect(find.text('John Doe'), findsOneWidget);
      });

      testWidgets('Register page should have back button and checkbox', (
        tester,
      ) async {
        await tester.pumpWidget(createRegisterPage());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.arrow_back), findsOneWidget);
        expect(find.byType(Checkbox), findsOneWidget);
      });

      testWidgets('Register page should toggle terms checkbox', (
        tester,
      ) async {
        await tester.pumpWidget(createRegisterPage());
        await tester.pumpAndSettle();

        final checkbox = find.byType(Checkbox);
        Checkbox checkboxWidget = tester.widget(checkbox);
        expect(checkboxWidget.value, false);

        await tester.tap(checkbox);
        await tester.pump();

        checkboxWidget = tester.widget(checkbox);
        expect(checkboxWidget.value, true);
      });
    });
  });
}
