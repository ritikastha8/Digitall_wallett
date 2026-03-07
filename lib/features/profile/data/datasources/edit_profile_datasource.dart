import 'package:digital_wallett_system/features/profile/data/models/edit_profile_api_model.dart';

abstract interface class EditProfileDatasource {
  Future<EditProfileApiModel> updateProfile({
    required String fullName,
    required String mobileNumber,
    required String? userId,
    String? imagePath,
  });
}

