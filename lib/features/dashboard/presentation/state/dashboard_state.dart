import 'package:equatable/equatable.dart';

enum DashboardStatus {
  initial,
  loading,
  loaded,
  error,
  created,
  updated,
  deleted,
}

class DashboardState extends Equatable {
  final DashboardStatus status;

  final String? errorMessage;
  // store image name temp
  final String? uploadPhotoName;

  const DashboardState({
    this.status = DashboardStatus.initial,
    this.errorMessage,
    this.uploadPhotoName,
  });

  DashboardState copyWith({
    DashboardStatus? status,
    String? errorMessage,
    String? uploadPhotoName,
  }) {
    return DashboardState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      uploadPhotoName: uploadPhotoName ?? this.uploadPhotoName,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, uploadPhotoName];
}
