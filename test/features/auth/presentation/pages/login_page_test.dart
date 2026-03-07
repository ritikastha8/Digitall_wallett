import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/features/auth/domain/entities/auth_entity.dart';
import 'package:digital_wallett_system/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:digital_wallett_system/features/auth/domain/usecases/login_usecase.dart';
import 'package:digital_wallett_system/features/auth/domain/usecases/logout_usecase.dart';
import 'package:digital_wallett_system/features/auth/domain/usecases/register_usecase.dart';
import 'package:digital_wallett_system/features/auth/presentation/pages/login_page.dart';
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
      child: const MaterialApp(home: LoginPage()),
    );
  }

  group('LoginPage UI Elements', () {
    testWidgets('should display welcome text', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Welcome Back!'), findsOneWidget);
      expect(find.text('Sign in to continue'), findsOneWidget);
    });

    testWidgets('should display mobile and password labels', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Mobile'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('should display login button', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Log In'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should display two text form fields', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('should display mobile icon', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.phone_android_outlined), findsOneWidget);
    });

    testWidgets('should display lock icon', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    });

    testWidgets('should display visibility icon for password', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    });

    testWidgets('should toggle password visibility', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pump();

      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });

    testWidgets('should display forgot password button', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Forgot Password?'), findsOneWidget);
    });

    testWidgets('should display register link text', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text("Don't have an account? "), findsOneWidget);
      expect(find.text('Register'), findsOneWidget);
    });

    testWidgets('should display hint texts', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Enter your mobile number'), findsOneWidget);
      expect(find.text('Enter your password'), findsOneWidget);
    });
  });

  group('LoginPage Form Validation', () {
    testWidgets('should show error for empty mobile', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.tap(find.text('Log In'));
      await tester.pump();

      expect(find.text('Please enter mobile number'), findsOneWidget);
    });

    testWidgets('should show error for invalid mobile', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextFormField).first, '98123');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.tap(find.text('Log In'));
      await tester.pump();

      expect(find.text('Enter valid mobile number'), findsOneWidget);
    });

    testWidgets('should show error for empty password', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextFormField).first, '9812345678');
      await tester.tap(find.text('Log In'));
      await tester.pump();

      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('should show error for short password', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextFormField).first, '9812345678');
      await tester.enterText(find.byType(TextFormField).last, '12345');
      await tester.tap(find.text('Log In'));
      await tester.pump();

      expect(
        find.text('Password must be at least 6 characters'),
        findsOneWidget,
      );
    });
  });

  group('LoginPage Form Submission', () {
    testWidgets('should call login usecase when form is valid', (tester) async {
      final completer = Completer<Either<Failure, AuthEntity>>();
      when(() => mockLoginUsecase(any())).thenAnswer((_) => completer.future);

      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextFormField).first, '9812345678');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.tap(find.text('Log In'));
      await tester.pump();

      verify(() => mockLoginUsecase(any())).called(1);

      completer.complete(const Left(ApiFailure(message: 'done')));
      await tester.pump();
    });

    testWidgets('should call login with correct mobile and password', (
      tester,
    ) async {
      LoginUsecaseParams? capturedParams;
      when(() => mockLoginUsecase(any())).thenAnswer((invocation) async {
        capturedParams = invocation.positionalArguments[0] as LoginUsecaseParams;
        return const Left(ApiFailure(message: 'stop navigation in test'));
      });

      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextFormField).first, '9800000001');
      await tester.enterText(find.byType(TextFormField).last, 'mypassword');
      await tester.tap(find.text('Log In'));
      await tester.pump();

      expect(capturedParams?.mobileNumber, '9800000001');
      expect(capturedParams?.password, 'mypassword');
    });

    testWidgets('should not call login usecase when form is invalid', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextFormField).first, '9812345678');
      await tester.tap(find.text('Log In'));
      await tester.pump();

      verifyNever(() => mockLoginUsecase(any()));
    });

    testWidgets('should show loading indicator while logging in', (tester) async {
      final completer = Completer<Either<Failure, AuthEntity>>();
      when(() => mockLoginUsecase(any())).thenAnswer((_) => completer.future);

      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextFormField).first, '9812345678');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.tap(find.text('Log In'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(const Left(ApiFailure(message: 'done')));
      await tester.pump();
    });

    testWidgets('should accept different credentials and call usecase each time', (
      tester,
    ) async {
      final capturedParams = <LoginUsecaseParams>[];
      when(() => mockLoginUsecase(any())).thenAnswer((invocation) async {
        capturedParams.add(invocation.positionalArguments[0] as LoginUsecaseParams);
        return const Left(ApiFailure(message: 'test complete'));
      });

      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextFormField).first, '9800000002');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.tap(find.text('Log In'));
      await tester.pump();

      await tester.enterText(find.byType(TextFormField).first, '9800000003');
      await tester.enterText(find.byType(TextFormField).last, 'password456');
      await tester.tap(find.text('Log In'));
      await tester.pump();

      expect(capturedParams.length, 2);
      expect(capturedParams[0].mobileNumber, '9800000002');
      expect(capturedParams[1].mobileNumber, '9800000003');
    });
  });
}
