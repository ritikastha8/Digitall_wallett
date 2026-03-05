import 'package:digital_wallett_system/features/auth/domain/entities/auth_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthEntity', () {
    test('props include all fields', () {
      const entity = AuthEntity(
        authId: '1',
        fullName: 'Test',
        mobileNumber: '9811111111',
        email: 'test@test.com',
      );
      expect(entity.props, contains('1'));
      expect(entity.props, contains('Test'));
      expect(entity.props, contains('9811111111'));
      expect(entity.props, contains('test@test.com'));
    });

    test('equality works for same values', () {
      const a = AuthEntity(
        authId: '1',
        fullName: 'A',
        mobileNumber: '98',
        email: 'a@a.com',
      );
      const b = AuthEntity(
        authId: '1',
        fullName: 'A',
        mobileNumber: '98',
        email: 'a@a.com',
      );
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });
  });
}
