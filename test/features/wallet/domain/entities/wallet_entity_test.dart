import 'package:digital_wallett_system/features/wallet/domain/entities/wallet_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WalletEntity', () {
    test('props include balance and currency', () {
      const entity = WalletEntity(balance: 100.5, currency: 'NPR');
      expect(entity.props, contains(100.5));
      expect(entity.props, contains('NPR'));
    });

    test('equality for same balance and currency', () {
      const a = WalletEntity(balance: 50.0, currency: 'NPR');
      const b = WalletEntity(balance: 50.0, currency: 'NPR');
      expect(a, equals(b));
    });
  });
}
