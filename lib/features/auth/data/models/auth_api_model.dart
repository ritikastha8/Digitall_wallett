import 'package:digital_wallett_system/features/auth/domain/entities/auth_entity.dart';

class AuthApiModel {
  final String? id;
  final String fullName;
  final String mobileNumber;
  // final String username;
  final String? password;
  final String? profilePicture;

  AuthApiModel({
    this.id,
    required this.fullName,
    required this.mobileNumber,
    // required this.username,
    this.password,
    this.profilePicture,
  });

  // toJSON
  Map<String, dynamic> toJson() {
    return {
      "name": fullName,
      "mobileNumber": mobileNumber,
      // "username": username,
      "password": password,
      "profilePicture": profilePicture,
    };
  }

  // fromJson
  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    return AuthApiModel(
      id: json['_id'] as String,
      fullName: json['name'] as String,
      mobileNumber: json['mobileNumber'] as String,
      // username: json['username'] as String,
      profilePicture: json['profilePicture'] as String?,
    );
  }

  // toEntity
  AuthEntity toEntity() {
    return AuthEntity(
      authId: id,
      fullName: fullName,
      mobileNumber: mobileNumber,
      // username: username,
      profilePicture: profilePicture,
    );
  }

  // fromEntity
  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      fullName: entity.fullName,
      mobileNumber: entity.mobileNumber,
      // username: entity.username,
      password: entity.password,
      profilePicture: entity.profilePicture,
    );
  }

  // toEntityList
  static List<AuthEntity> toEntityList(List<AuthApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
