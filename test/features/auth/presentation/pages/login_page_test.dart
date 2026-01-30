import 'package:digital_wallett_system/core/services/storage/user_session_service.dart';
import 'package:digital_wallett_system/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    // Mock SharedPreferences for all tests
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('1. Check if all main texts are displayed', (
    WidgetTester tester,
  ) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(sharedPrefs)],
        child: const MaterialApp(home: LoginPage()),
      ),
    );

    await tester.pumpAndSettle();

    // Check texts
    expect(find.text('Welcome Back!'), findsOneWidget);
    expect(find.text('Sign in to continue'), findsOneWidget);
    expect(find.text('Forgot Password?'), findsOneWidget);
    expect(find.text("Don't have an account? "), findsOneWidget);
    expect(find.text('Register'), findsOneWidget);
  });

  testWidgets('2. Check if input fields exist', (WidgetTester tester) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(sharedPrefs)],
        child: const MaterialApp(home: LoginPage()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.widgetWithText(TextFormField, 'Mobile'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
  });

  testWidgets('3. Login button is present and tappable', (
    WidgetTester tester,
  ) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(sharedPrefs)],
        child: const MaterialApp(home: LoginPage()),
      ),
    );

    await tester.pumpAndSettle();

    final loginBtn = find.widgetWithText(ElevatedButton, 'Log In');
    expect(loginBtn, findsOneWidget);

    // Tap button
    await tester.tap(loginBtn);
    await tester.pump();

    // Validation messages should appear
    expect(find.text('Please enter mobile number'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
  });

  testWidgets('4. Mobile input validation works', (WidgetTester tester) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(sharedPrefs)],
        child: const MaterialApp(home: LoginPage()),
      ),
    );

    await tester.pumpAndSettle();

    // Enter invalid mobile
    await tester.enterText(find.byType(TextFormField).first, '9876543123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Log In'));
    await tester.pump();

    expect(find.text('Enter valid mobile number'), findsOneWidget);
  });

  testWidgets('5. Password input validation works', (
    WidgetTester tester,
  ) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(sharedPrefs)],
        child: const MaterialApp(home: LoginPage()),
      ),
    );

    await tester.pumpAndSettle();

    // Enter valid mobile but short password
    await tester.enterText(find.byType(TextFormField).first, '9812345678');
    await tester.enterText(find.byType(TextFormField).last, '128');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Log In'));
    await tester.pump();

    expect(find.text('Password must be at least 6 characters'), findsOneWidget);
  });
}
