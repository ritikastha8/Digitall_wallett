import 'package:digital_wallett_system/features/profile/domain/entities/edit_profile_entity.dart';

class EditProfileApiModel {
  final String fullName;
  final String mobileNumber;
  final String? profilePicture;

  const EditProfileApiModel({
    required this.fullName,
    required this.mobileNumber,
    this.profilePicture,
  });

  EditProfileEntity toEntity() {
    return EditProfileEntity(
      fullName: fullName,
      mobileNumber: mobileNumber,
      profilePicture: profilePicture,
    );
  }
}

