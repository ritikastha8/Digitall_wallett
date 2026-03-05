import 'package:digital_wallett_system/features/dashboard/presentation/state/dashboard_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DashboardState', () {
    test('initial state has default values', () {
      const state = DashboardState();
      expect(state.status, DashboardStatus.initial);
      expect(state.errorMessage, isNull);
      expect(state.uploadPhotoName, isNull);
    });

    test('copyWith updates status and uploadPhotoName', () {
      const initial = DashboardState();
      final updated = initial.copyWith(
        status: DashboardStatus.loaded,
        uploadPhotoName: 'photo.jpg',
      );
      expect(updated.status, DashboardStatus.loaded);
      expect(updated.uploadPhotoName, 'photo.jpg');
    });
  });
}
