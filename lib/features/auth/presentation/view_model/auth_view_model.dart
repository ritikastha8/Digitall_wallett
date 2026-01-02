import 'package:digital_wallett_system/features/auth/domain/usecases/login_usecase.dart';
import 'package:digital_wallett_system/features/auth/domain/usecases/register_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/auth_state.dart';

// Provider for the AuthViewModel
final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(
  () => AuthViewModel(),
);

class AuthViewModel extends Notifier<AuthState> {
  late final RegisterUsecase _registerUsecase;
  late final LoginUsecase _loginUsecase;

  @override
  AuthState build() {
    _registerUsecase = ref.read(registerUsecaseProvider);
    _loginUsecase = ref.read(loginUsecaseProvider);
    return AuthState();
  }

  /// REGISTER
  Future<void> register({
    required String fullName,
    required String mobileNumber,
    required String username,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);

    // Example delay for loading simulation
    await Future.delayed(const Duration(seconds: 2));

    final params = RegisterUsecaseParams(
      fullName: fullName,
      mobileNumber: mobileNumber,
      username: username,
      password: password,
    );

    final result = await _registerUsecase(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (isRegistered) {
        if (isRegistered) {
          state = state.copyWith(status: AuthStatus.unauthenticated);
        } else {
          state = state.copyWith(
            status: AuthStatus.error,
            errorMessage: 'Registration failed',
          );
        }
      },
    );
  }

  /// LOGIN
  Future<void> login({
    required String mobileNumber,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);

    final params = LoginUsecaseParams(
      mobileNumber: mobileNumber,
      password: password,
    );

    final result = await _loginUsecase(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (authEntity) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          authEntity: authEntity,
        );
      },
    );
  }
}
