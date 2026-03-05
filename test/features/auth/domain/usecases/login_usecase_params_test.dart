import 'package:digital_wallett_system/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginUsecaseParams', () {
    test('props include mobileNumber and password', () {
      const params = LoginUsecaseParams(
        mobileNumber: '9811111111',
        password: 'secret',
      );
      expect(params.props, contains('9811111111'));
      expect(params.props, contains('secret'));
    });

    test('equality for same values', () {
      const a = LoginUsecaseParams(mobileNumber: '98', password: 'p');
      const b = LoginUsecaseParams(mobileNumber: '98', password: 'p');
      expect(a, equals(b));
    });
  });
}
