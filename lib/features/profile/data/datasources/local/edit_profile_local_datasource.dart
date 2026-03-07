import 'package:digital_wallett_system/core/services/storage/user_session_service.dart';
import 'package:digital_wallett_system/features/profile/domain/entities/edit_profile_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final editProfileLocalDatasourceProvider = Provider<EditProfileLocalDatasource>((
  ref,
) {
  final userSession = ref.read(userSessionServiceProvider);
  return EditProfileLocalDatasource(userSession: userSession);
});

class EditProfileLocalDatasource {
  final UserSessionService _userSession;

  EditProfileLocalDatasource({required UserSessionService userSession})
    : _userSession = userSession;

  Future<void> cacheProfile(EditProfileEntity entity) async {
    await _userSession.updateeProfile(
      fullName: entity.fullName,
      mobileNumber: entity.mobileNumber,
      profilePicture: entity.profilePicture,
    );
  }

  EditProfileEntity getCachedProfile() {
    return EditProfileEntity(
      fullName: _userSession.getCurrentUserFullName() ?? '',
      mobileNumber: _userSession.getCurrentUserMobileNumber() ?? '',
      profilePicture: _userSession.getCurrentUserProfilePicture(),
    );
  }
}

