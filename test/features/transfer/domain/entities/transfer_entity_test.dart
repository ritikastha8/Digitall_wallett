import 'package:digital_wallett_system/features/transfer/domain/entities/transfer_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TransferEntity', () {
    test('props include recipientMobile, amount, remarks', () {
      const entity = TransferEntity(
        recipientMobile: '9811111111',
        amount: 100.0,
        remarks: 'Test',
      );
      expect(entity.props, contains('9811111111'));
      expect(entity.props, contains(100.0));
      expect(entity.props, contains('Test'));
    });
  });
}
