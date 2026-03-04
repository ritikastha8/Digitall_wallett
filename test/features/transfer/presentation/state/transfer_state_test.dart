import 'package:digital_wallett_system/features/transfer/domain/entities/transfer_entity.dart';
import 'package:digital_wallett_system/features/transfer/presentation/state/transfer_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TransferState', () {
    test('initial state has default values', () {
      const state = TransferState();
      expect(state.status, TransferStatus.initial);
      expect(state.transfer, isNull);
      expect(state.errorMessage, isNull);
    });

    test('copyWith updates status and errorMessage', () {
      const initial = TransferState();
      final updated = initial.copyWith(
        status: TransferStatus.error,
        errorMessage: 'Failed',
      );
      expect(updated.status, TransferStatus.error);
      expect(updated.errorMessage, 'Failed');
    });
  });
}
