import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/core/usecases/app_usecase.dart';
import 'package:digital_wallett_system/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:digital_wallett_system/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final uploadPhotoUsecaseProvider = Provider<uploadPhotoUsecase>((ref) {
  final repository = ref.read(dashboardRepositoryProvider);
  return uploadPhotoUsecase(repository: repository);
});

class uploadPhotoUsecase implements UsecaseWithParams<String, File> {
  final DDashboardRepository _repository;
  uploadPhotoUsecase({required DDashboardRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, String>> call(File params) {
    return _repository.uploadImage(params);
  }
}
