import 'package:digital_wallett_system/features/auth/domain/entities/auth_entity.dart';
import 'package:digital_wallett_system/features/auth/presentation/state/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthState', () {
    test('initial state has default values', () {
      const state = AuthState();
      expect(state.status, AuthStatus.initial);
      expect(state.authEntity, isNull);
      expect(state.errorMessage, isNull);
    });

    test('copyWith updates only provided fields', () {
      const initial = AuthState();
      final updated = initial.copyWith(status: AuthStatus.loading);
      expect(updated.status, AuthStatus.loading);
      expect(updated.authEntity, initial.authEntity);
      expect(updated.errorMessage, initial.errorMessage);
    });

    test('copyWith sets authEntity and errorMessage', () {
      const entity = AuthEntity(
        fullName: 'U',
        mobileNumber: '98',
        email: 'e@e.com',
      );
      const initial = AuthState();
      final updated = initial.copyWith(
        authEntity: entity,
        errorMessage: 'err',
      );
      expect(updated.authEntity, entity);
      expect(updated.errorMessage, 'err');
    });
  });
}
