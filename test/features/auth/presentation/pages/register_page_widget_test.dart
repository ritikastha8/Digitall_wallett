import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:digital_wallett_system/features/auth/domain/usecases/login_usecase.dart';
import 'package:digital_wallett_system/features/auth/domain/usecases/logout_usecase.dart';
import 'package:digital_wallett_system/features/auth/domain/usecases/register_usecase.dart';
import 'package:digital_wallett_system/features/auth/presentation/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRegisterUsecase extends Mock implements RegisterUsecase {}

class MockLoginUsecase extends Mock implements LoginUsecase {}

class MockGetCurrentUserUsecase extends Mock implements GetCurrentUserUsecase {}

class MockLogoutUsecase extends Mock implements LogoutUsecase {}

void main() {
  late MockRegisterUsecase mockRegisterUsecase;
  late MockLoginUsecase mockLoginUsecase;
  late MockGetCurrentUserUsecase mockGetCurrentUserUsecase;
  late MockLogoutUsecase mockLogoutUsecase;

  setUpAll(() {
    registerFallbackValue(
      const RegisterUsecaseParams(
        fullName: 'fallback',
        mobileNumber: '9800000000',
        email: 'fallback@email.com',
        password: 'fallback123',
        confirmPassword: 'fallback123',
      ),
    );
    registerFallbackValue(
      const LoginUsecaseParams(
        mobileNumber: '9800000000',
        password: 'fallback123',
      ),
    );
  });

  setUp(() {
    mockRegisterUsecase = MockRegisterUsecase();
    mockLoginUsecase = MockLoginUsecase();
    mockGetCurrentUserUsecase = MockGetCurrentUserUsecase();
    mockLogoutUsecase = MockLogoutUsecase();
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        registerUsecaseProvider.overrideWithValue(mockRegisterUsecase),
        loginUsecaseProvider.overrideWithValue(mockLoginUsecase),
        getCurrentUserUsecaseProvider.overrideWithValue(
          mockGetCurrentUserUsecase,
        ),
        logoutUsecaseProvider.overrideWithValue(mockLogoutUsecase),
      ],
      child: const MaterialApp(home: RegisterPage()),
    );
  }

  group('RegisterPage UI Elements', () {
    testWidgets('should display header text and form fields', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Register New Account'), findsOneWidget);
      expect(
        find.text('Create your account to start using NovaCash'),
        findsOneWidget,
      );
      expect(find.byType(TextFormField), findsNWidgets(5));
    });

    testWidgets('should display field hints', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Mobile Number'), findsOneWidget);
      expect(find.text('Email Address'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
    });

    testWidgets('should display key icons', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byIcon(Icons.person_outline_rounded), findsOneWidget);
      expect(find.byIcon(Icons.phone_outlined), findsOneWidget);
      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline_rounded), findsNWidgets(2));
    });

    testWidgets('should display terms and login link', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Checkbox), findsOneWidget);
      expect(find.text('Already have an account? '), findsOneWidget);
      expect(find.text('Log In'), findsOneWidget);
      expect(find.text('Register Account'), findsOneWidget);
    });
  });

  group('RegisterPage Form Input', () {
    testWidgets('should allow entering all field values', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'Test User');
      await tester.enterText(textFields.at(1), '9800000000');
      await tester.enterText(textFields.at(2), 'test@example.com');
      await tester.enterText(textFields.at(3), 'password123');
      await tester.enterText(textFields.at(4), 'password123');
      await tester.pump();

      expect(find.text('Test User'), findsOneWidget);
      expect(find.text('9800000000'), findsOneWidget);
      expect(find.text('test@example.com'), findsOneWidget);
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should toggle password visibility icons', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_outlined), findsNWidgets(2));

      await tester.tap(find.byIcon(Icons.visibility_outlined).first);
      await tester.pump();
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });
  });

  group('RegisterPage Form Validation', () {
    testWidgets('should show error when name is empty', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(1), '9800000000');
      await tester.enterText(textFields.at(2), 'test@example.com');
      await tester.enterText(textFields.at(3), 'password123');
      await tester.enterText(textFields.at(4), 'password123');
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      await tester.tap(find.text('Register Account'));
      await tester.pump();

      expect(find.text('Enter your name'), findsOneWidget);
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should show error when mobile is invalid', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'Test User');
      await tester.enterText(textFields.at(1), '12345');
      await tester.enterText(textFields.at(2), 'test@example.com');
      await tester.enterText(textFields.at(3), 'password123');
      await tester.enterText(textFields.at(4), 'password123');
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      await tester.tap(find.text('Register Account'));
      await tester.pump();

      expect(
        find.text('Mobile number must be exactly 10 digits'),
        findsOneWidget,
      );
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should show error when email is invalid', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'Test User');
      await tester.enterText(textFields.at(1), '9800000000');
      await tester.enterText(textFields.at(2), 'invalidemail');
      await tester.enterText(textFields.at(3), 'password123');
      await tester.enterText(textFields.at(4), 'password123');
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      await tester.tap(find.text('Register Account'));
      await tester.pump();

      expect(find.text('Please enter a valid email'), findsOneWidget);
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should show error when passwords do not match', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'Test User');
      await tester.enterText(textFields.at(1), '9800000000');
      await tester.enterText(textFields.at(2), 'test@example.com');
      await tester.enterText(textFields.at(3), 'password123');
      await tester.enterText(textFields.at(4), 'different123');
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      await tester.tap(find.text('Register Account'));
      await tester.pump();

      expect(find.text('Passwords do not match'), findsOneWidget);
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should not call register when terms are not accepted', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'Test User');
      await tester.enterText(textFields.at(1), '9800000000');
      await tester.enterText(textFields.at(2), 'test@example.com');
      await tester.enterText(textFields.at(3), 'password123');
      await tester.enterText(textFields.at(4), 'password123');
      await tester.pump();

      await tester.tap(find.text('Register Account'));
      await tester.pump();

      verifyNever(() => mockRegisterUsecase(any()));
      expect(
        find.text('Please agree to the Terms & Conditions'),
        findsOneWidget,
      );
      await tester.binding.setSurfaceSize(null);
    });
  });

  group('RegisterPage Form Submission', () {
    testWidgets('should call register usecase when form is valid', (
      tester,
    ) async {
      when(
        () => mockRegisterUsecase(any()),
      ).thenAnswer((_) async => const Left(ApiFailure(message: 'test')));

      await tester.binding.setSurfaceSize(const Size(800, 2000));
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'Test User');
      await tester.enterText(textFields.at(1), '9800000000');
      await tester.enterText(textFields.at(2), 'test@example.com');
      await tester.enterText(textFields.at(3), 'password123');
      await tester.enterText(textFields.at(4), 'password123');
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      await tester.tap(find.text('Register Account'));
      await tester.pumpAndSettle();

      verify(() => mockRegisterUsecase(any())).called(1);
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should pass correct params to register usecase', (tester) async {
      RegisterUsecaseParams? capturedParams;
      when(() => mockRegisterUsecase(any())).thenAnswer((invocation) async {
        capturedParams =
            invocation.positionalArguments[0] as RegisterUsecaseParams;
        return const Left(ApiFailure(message: 'test'));
      });

      await tester.binding.setSurfaceSize(const Size(800, 2000));
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'John Doe');
      await tester.enterText(textFields.at(1), '9800000001');
      await tester.enterText(textFields.at(2), 'john@example.com');
      await tester.enterText(textFields.at(3), 'mypassword');
      await tester.enterText(textFields.at(4), 'mypassword');
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      await tester.tap(find.text('Register Account'));
      await tester.pumpAndSettle();

      expect(capturedParams?.fullName, 'John Doe');
      expect(capturedParams?.mobileNumber, '9800000001');
      expect(capturedParams?.email, 'john@example.com');
      expect(capturedParams?.password, 'mypassword');
      expect(capturedParams?.confirmPassword, 'mypassword');
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should show loading indicator while registering', (tester) async {
      final completer = Completer<Either<Failure, bool>>();
      when(() => mockRegisterUsecase(any())).thenAnswer((_) => completer.future);

      await tester.binding.setSurfaceSize(const Size(800, 2000));
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'Test User');
      await tester.enterText(textFields.at(1), '9800000000');
      await tester.enterText(textFields.at(2), 'test@example.com');
      await tester.enterText(textFields.at(3), 'password123');
      await tester.enterText(textFields.at(4), 'password123');
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      await tester.tap(find.text('Register Account'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(const Left(ApiFailure(message: 'done')));
      await tester.pumpAndSettle();
      await tester.binding.setSurfaceSize(null);
    });
  });
}
