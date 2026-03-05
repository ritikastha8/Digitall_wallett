import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/features/auth/domain/entities/auth_entity.dart';
import 'package:digital_wallett_system/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:digital_wallett_system/features/auth/domain/usecases/login_usecase.dart';
import 'package:digital_wallett_system/features/auth/domain/usecases/logout_usecase.dart';
import 'package:digital_wallett_system/features/auth/domain/usecases/register_usecase.dart';
import 'package:digital_wallett_system/features/auth/presentation/state/auth_state.dart';
import 'package:digital_wallett_system/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

class MockRegisterUsecase extends Mock implements RegisterUsecase {}

class MockLoginUsecase extends Mock implements LoginUsecase {}

class MockGetCurrentUserUsecase extends Mock implements GetCurrentUserUsecase {}

class MockLogoutUsecase extends Mock implements LogoutUsecase {}

void main() {
  late MockRegisterUsecase mockRegister;
  late MockLoginUsecase mockLogin;
  late MockGetCurrentUserUsecase mockGetCurrentUser;
  late MockLogoutUsecase mockLogout;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(
      RegisterUsecaseParams(
        fullName: '',
        mobileNumber: '',
        email: '',
        password: '',
        confirmPassword: '',
      ),
    );
    registerFallbackValue(LoginUsecaseParams(mobileNumber: '', password: ''));
  });

  setUp(() {
    mockRegister = MockRegisterUsecase();
    mockLogin = MockLoginUsecase();
    mockGetCurrentUser = MockGetCurrentUserUsecase();
    mockLogout = MockLogoutUsecase();
    container = ProviderContainer(
      overrides: [
        registerUsecaseProvider.overrideWithValue(mockRegister),
        loginUsecaseProvider.overrideWithValue(mockLogin),
        getCurrentUserUsecaseProvider.overrideWithValue(mockGetCurrentUser),
        logoutUsecaseProvider.overrideWithValue(mockLogout),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('AuthViewModel', () {
    test('build returns initial state', () {
      final state = container.read(authViewModelProvider);
      expect(state.status, AuthStatus.initial);
    });

    test('register success sets status to registered', () async {
      when(
        () => mockRegister(any()),
      ).thenAnswer((_) async => const Right(true));
      final notifier = container.read(authViewModelProvider.notifier);
      final user = AuthEntity(
        fullName: 'Test',
        mobileNumber: '9812345678',
        email: 'test@gmail.com',
        password: 'passtest',
        confirmPassword: 'passtest',
      );
      await notifier.register(user);
      expect(
        container.read(authViewModelProvider).status,
        AuthStatus.registered,
      );
    });

    test('register failure sets status to error and errorMessage', () async {
      when(
        () => mockRegister(any()),
      ).thenAnswer((_) async => const Left(ApiFailure(message: 'Fail')));
      final notifier = container.read(authViewModelProvider.notifier);
      final user = AuthEntity(
        fullName: 'Test User',
        mobileNumber: '9800000001',
        email: 'testuser@gmail.com',
        password: 'passtest',
        confirmPassword: 'passtest',
      );
      await notifier.register(user);
      final state = container.read(authViewModelProvider);
      expect(state.status, AuthStatus.error);
      expect(state.errorMessage, 'Fail');
    });

    test('login success sets status to authenticated and authEntity', () async {
      const entity = AuthEntity(
        fullName: 'User Name',
        mobileNumber: '9800000002',
        email: 'username@gmail.com',
      );
      when(() => mockLogin(any())).thenAnswer((_) async => const Right(entity));
      final notifier = container.read(authViewModelProvider.notifier);
      await notifier.login(mobileNumber: '9800000002', password: 'passtest');
      final state = container.read(authViewModelProvider);
      expect(state.status, AuthStatus.authenticated);
      expect(state.authEntity, entity);
    });

    test('login failure sets status to error', () async {
      when(
        () => mockLogin(any()),
      ).thenAnswer((_) async => const Left(ApiFailure(message: 'Invalid')));
      final notifier = container.read(authViewModelProvider.notifier);
      await notifier.login(mobileNumber: '9800000003', password: 'passtest');
      expect(container.read(authViewModelProvider).status, AuthStatus.error);
    });

    test(
      'logout success sets status to unauthenticated and clears authEntity',
      () async {
        when(() => mockLogout()).thenAnswer((_) async => const Right(true));
        final notifier = container.read(authViewModelProvider.notifier);
        await notifier.logout();
        final state = container.read(authViewModelProvider);
        expect(state.status, AuthStatus.unauthenticated);
        expect(state.authEntity, isNull);
      },
    );

    test('clearError can be called without throwing', () {
      final notifier = container.read(authViewModelProvider.notifier);
      expect(() => notifier.clearError(), returnsNormally);
    });
  });
}
