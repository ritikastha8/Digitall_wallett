import 'package:digital_wallett_system/features/auth/domain/entities/auth_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:digital_wallett_system/features/auth/domain/usecases/login_usecase.dart';
import 'package:digital_wallett_system/features/auth/domain/usecases/register_usecase.dart';
import 'package:digital_wallett_system/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:digital_wallett_system/features/auth/domain/usecases/logout_usecase.dart';
import '../state/auth_state.dart';

/// Provider for the AuthViewModel
final authViewModelProvider = NotifierProvider<AuthViewModel, AuthState>(
  AuthViewModel.new,
);

class AuthViewModel extends Notifier<AuthState> {
  late final RegisterUsecase _registerUsecase;
  late final LoginUsecase _loginUsecase;
  late final GetCurrentUserUsecase _getCurrentUserUsecase;
  late final LogoutUsecase _logoutUsecase;

  @override
  AuthState build() {
    _registerUsecase = ref.read(registerUsecaseProvider);
    _loginUsecase = ref.read(loginUsecaseProvider);
    _getCurrentUserUsecase = ref.read(getCurrentUserUsecaseProvider);
    _logoutUsecase = ref.read(logoutUsecaseProvider);

    return const AuthState(); // initial state
  }

  Future<void> register(AuthEntity user) async {
    state = state.copyWith(status: AuthStatus.loading);

    final params = RegisterUsecaseParams(
      fullName: user.fullName,
      mobileNumber: user.mobileNumber,
      // username: username,
      email: user.email,
      password: user.password!,
      confirmPassword: user.confirmPassword!,
      profilePicture: user.profilePicture,
    );

    final result = await _registerUsecase(params);

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (success) => state = state.copyWith(status: AuthStatus.registered),
    );
  }

  /// LOGIN
  Future<void> login({
    required String mobileNumber,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _loginUsecase(
      LoginUsecaseParams(mobileNumber: mobileNumber, password: password),
    );

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

  /// GET CURRENT USER
  Future<void> getCurrentUser() async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _getCurrentUserUsecase();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
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

  /// LOGOUT
  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _logoutUsecase();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (_) {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          authEntity: null,
        );
      },
    );
  }

  /// CLEAR ERROR
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
