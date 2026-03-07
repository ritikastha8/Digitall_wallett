import 'package:digital_wallett_system/core/constants/hive_table_constant.dart';
import 'package:digital_wallett_system/features/auth/domain/entities/auth_entity.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.authTypeId)
class AuthHiveModel extends HiveObject {
  @HiveField(0)
  final String? authId;
  @HiveField(1)
  final String fullName;
  @HiveField(2)
  final String mobileNumber;
  @HiveField(3)
  final String email;
  // @HiveField(3)
  // final String username;
  @HiveField(4)
  final String? password;
  @HiveField(6)
  final String? confirmPassword;
  // @HiveField(7)
  // final String role;
  @HiveField(7)
  final String? profilePicture;

  AuthHiveModel({
    String? authId,
    required this.fullName,
    required this.mobileNumber,
    required this.email,
    // required this.username,
    this.password,
    this.confirmPassword,
    // this.role = "user",
    this.profilePicture,
  }) : authId = authId ?? Uuid().v4();

  // From Entity
  factory AuthHiveModel.fromEntity(AuthEntity entity) {
    return AuthHiveModel(
      authId: entity.authId,
      fullName: entity.fullName,
      mobileNumber: entity.mobileNumber,
      // username: entity.username,
      email: entity.email,
      password: entity.password,
      confirmPassword: entity.confirmPassword,
      // role: entity.role,
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
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      // role: role,
      profilePicture: profilePicture,
    );
  }

  // To Entity List
  static List<AuthEntity> toEntityList(List<AuthHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
