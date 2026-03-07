import 'package:dartz/dartz.dart';
import 'package:digital_wallett_system/core/errors/failures.dart';
import 'package:digital_wallett_system/features/profile/domain/entities/edit_profile_entity.dart';

abstract interface class IEditProfileRepository {
  Future<Either<Failure, EditProfileEntity>> updateProfile({
    required String fullName,
    required String mobileNumber,
    String? imagePath,
  });
}

