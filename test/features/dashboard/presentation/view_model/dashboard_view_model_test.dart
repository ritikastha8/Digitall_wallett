import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/features/dashboard/domain/usecases/upload_photo_usecase.dart';
import 'package:digital_wallett_system/features/dashboard/presentation/state/dashboard_state.dart';
import 'package:digital_wallett_system/features/dashboard/presentation/view_model/dashboard_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

class MockUploadPhotoUsecase extends Mock implements UploadPhotoUsecase {}

void main() {
  late MockUploadPhotoUsecase mockUploadPhoto;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(File(''));
  });

  setUp(() {
    mockUploadPhoto = MockUploadPhotoUsecase();
    container = ProviderContainer(
      overrides: [
        uploadPhotoUsecaseProvider.overrideWithValue(mockUploadPhoto),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('DashboardViewModel', () {
    test('build returns initial DashboardState', () {
      final state = container.read(dashboardViewModelProvider);
      expect(state.status, DashboardStatus.initial);
    });

    test('uploadPhoto success sets status loaded and uploadPhotoName', () async {
      when(() => mockUploadPhoto(any())).thenAnswer((_) async => const Right('photo.jpg'));
      await container.read(dashboardViewModelProvider.notifier).uploadPhoto(File('x'));
      final state = container.read(dashboardViewModelProvider);
      expect(state.status, DashboardStatus.loaded);
      expect(state.uploadPhotoName, 'photo.jpg');
    });

    test('uploadPhoto failure sets status error and errorMessage', () async {
      when(() => mockUploadPhoto(any()))
          .thenAnswer((_) async => const Left(ApiFailure(message: 'Upload failed')));
      await container.read(dashboardViewModelProvider.notifier).uploadPhoto(File('x'));
      final state = container.read(dashboardViewModelProvider);
      expect(state.status, DashboardStatus.error);
      expect(state.errorMessage, 'Upload failed');
    });

    test('clearError can be called without throwing', () {
      final notifier = container.read(dashboardViewModelProvider.notifier);
      expect(() => notifier.clearError(), returnsNormally);
    });
  });
}
