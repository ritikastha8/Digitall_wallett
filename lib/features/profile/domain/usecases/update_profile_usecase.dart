import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/core/usecases/app_usecase.dart';
import 'package:digital_wallett_system/features/profile/data/repositories/edit_profile_repository.dart';
import 'package:digital_wallett_system/features/profile/domain/entities/edit_profile_entity.dart';
import 'package:digital_wallett_system/features/profile/domain/repositories/edit_profile_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateProfileParams extends Equatable {
  final String fullName;
  final String mobileNumber;
  final String? imagePath;

  const UpdateProfileParams({
    required this.fullName,
    required this.mobileNumber,
    this.imagePath,
  });

  @override
  List<Object?> get props => [fullName, mobileNumber, imagePath];
}

final updateProfileUsecaseProvider = Provider<UpdateProfileUsecase>((ref) {
  final repository = ref.read(editProfileRepositoryProvider);
  return UpdateProfileUsecase(repository: repository);
});

class UpdateProfileUsecase
    implements UsecaseWithParams<EditProfileEntity, UpdateProfileParams> {
  final IEditProfileRepository _repository;

  UpdateProfileUsecase({required IEditProfileRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, EditProfileEntity>> call(UpdateProfileParams params) {
    return _repository.updateProfile(
      fullName: params.fullName,
      mobileNumber: params.mobileNumber,
      imagePath: params.imagePath,
    );
  }
}

