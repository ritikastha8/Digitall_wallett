import 'package:digital_wallett_system/features/auth/domain/usecases/register_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tFullName = 'Test User';
  const tMobileNumber = '9811111111';
  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tConfirmPassword = 'password123';
  const tProfilePicture = 'https://example.com/pic.jpg';

  group('RegisterUsecaseParams', () {
    test('should have correct props with all values', () {
      const params = RegisterUsecaseParams(
        fullName: tFullName,
        mobileNumber: tMobileNumber,
        email: tEmail,
        password: tPassword,
        confirmPassword: tConfirmPassword,
        profilePicture: tProfilePicture,
      );

      expect(params.props, [
        tFullName,
        tMobileNumber,
        tEmail,
        tPassword,
        tConfirmPassword,
        tProfilePicture,
      ]);
    });

    test('should have correct props with optional value as null', () {
      const params = RegisterUsecaseParams(
        fullName: tFullName,
        mobileNumber: tMobileNumber,
        email: tEmail,
        password: tPassword,
        confirmPassword: tConfirmPassword,
      );

      expect(params.props, [
        tFullName,
        tMobileNumber,
        tEmail,
        tPassword,
        tConfirmPassword,
        null,
      ]);
    });

    test('two params with same values should be equal', () {
      const params1 = RegisterUsecaseParams(
        fullName: tFullName,
        mobileNumber: tMobileNumber,
        email: tEmail,
        password: tPassword,
        confirmPassword: tConfirmPassword,
      );
      const params2 = RegisterUsecaseParams(
        fullName: tFullName,
        mobileNumber: tMobileNumber,
        email: tEmail,
        password: tPassword,
        confirmPassword: tConfirmPassword,
      );

      expect(params1, params2);
    });
  });
}
