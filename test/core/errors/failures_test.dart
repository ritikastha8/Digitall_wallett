import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Failure', () {
    test('ApiFailure has message and optional statusCode', () {
      const f = ApiFailure(message: 'Bad request', statusCode: 400);
      expect(f.message, 'Bad request');
      expect(f.statusCode, 400);
    });

    test('LocalDatabaseFailure has default message', () {
      const f = LocalDatabaseFailure();
      expect(f.message, 'Local database operation failed');
    });

    test('LocalDatabaseFailure accepts custom message', () {
      const f = LocalDatabaseFailure(message: 'Custom');
      expect(f.message, 'Custom');
    });
  });
}
