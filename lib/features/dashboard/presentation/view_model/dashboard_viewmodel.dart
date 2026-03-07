import 'dart:io';

import 'package:digital_wallett_system/features/dashboard/domain/usecases/upload_photo_usecase.dart';
import 'package:digital_wallett_system/features/dashboard/presentation/state/dashboard_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardViewModelProvider =
    NotifierProvider<DashboardViewModel, DashboardState>(
      DashboardViewModel.new,
    );

class DashboardViewModel extends Notifier<DashboardState> {
  late final UploadPhotoUsecase _uploadPhotoUsecase;

  @override
  DashboardState build() {
    _uploadPhotoUsecase = ref.read(uploadPhotoUsecaseProvider);
    return const DashboardState();
  }

  // upload photo
  Future<void> uploadPhoto(File photo) async {
    state = state.copyWith(status: DashboardStatus.loading);
    final result = await _uploadPhotoUsecase(photo);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: DashboardStatus.error,
          errorMessage: failure.message,
        );
      },
      (imageName) {
        state = state.copyWith(
          status: DashboardStatus.loaded,
          uploadPhotoName: imageName,
        );
      },
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
