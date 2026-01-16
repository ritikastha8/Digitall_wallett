import 'package:digital_wallett_system/core/constants/hive_table_constant.dart';
import 'package:digital_wallett_system/features/auth/domain/entities/auth_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.authTypeId)
class AuthHiveModel {
  @HiveField(0)
  final String? authId;
  @HiveField(1)
  final String fullName;
  @HiveField(2)
  final String mobileNumber;
  // @HiveField(3)
  // final String username;
  @HiveField(3)
  final String? password;
  @HiveField(4)
  final String? profilePicture;

  AuthHiveModel({
    String? authId,
    required this.fullName,
    required this.mobileNumber,
    // required this.username,
    this.password,
    this.profilePicture,
  }) : authId = authId ?? Uuid().v4();

  // From Entity
  factory AuthHiveModel.fromEntity(AuthEntity entity) {
    return AuthHiveModel(
      authId: entity.authId,
      fullName: entity.fullName,
      mobileNumber: entity.mobileNumber,
      // username: entity.username,
      password: entity.password,
      profilePicture: entity.profilePicture,
    );
  }
  // To entity
  AuthEntity toEntity() {
    return AuthEntity(
      authId: authId,
      fullName: fullName,
      mobileNumber: mobileNumber,
      // username: username,
      password: password,
      profilePicture: profilePicture,
    );
  }

  // To Entity List
  static List<AuthEntity> toEntityList(List<AuthHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
