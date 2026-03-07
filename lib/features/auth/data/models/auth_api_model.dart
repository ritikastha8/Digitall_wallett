import 'package:digital_wallett_system/features/auth/domain/entities/auth_entity.dart';

class AuthApiModel {
  final String? id;
  final String fullName;
  final String mobileNumber;
  final String email;
  // final String username;
  final String? password;
  final String? confirmPassword;
  // final String role;
  final String? token;
  final String? profilePicture;

  AuthApiModel({
    this.id,
    required this.fullName,
    required this.mobileNumber,
    required this.email,
    // required this.username,
    this.password,
    this.confirmPassword,
    // required this.role,
    this.token,
    this.profilePicture,
  });

  // fromJson — backend: login has { "data": <user>, "token" }; register has { "data": <user> }
  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> userData = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : (json['user'] is Map<String, dynamic>
              ? json['user'] as Map<String, dynamic>
              : json);
    return AuthApiModel(
      token: json['token'] as String?,
      id: (userData['_id'] ?? userData['id'])?.toString(),
      fullName: userData['name']?.toString() ?? '',
      mobileNumber: userData['mobileNumber']?.toString() ?? '',
      email: userData['email']?.toString() ?? '',
      password: userData['password']?.toString(),
      confirmPassword: userData['confirmPassword']?.toString(),
      profilePicture:
          (userData['profilePicture'] ??
                  userData['profilePhoto'] ??
                  userData['imageUrl'])
              ?.toString(),
    );
  }

  // toEntity
  AuthEntity toEntity() {
    return AuthEntity(
      authId: id,
      fullName: fullName,
      mobileNumber: mobileNumber,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      // role: role,
      token: token,
      // username: username,
      profilePicture: profilePicture,
    );
  }

  // toJSON
  Map<String, dynamic> toJson() {
    return {
      "name": fullName,
      "mobileNumber": mobileNumber,
      "email": email,
      // "username": username,
      "password": password,
      "confirmPassword": confirmPassword,
      "profilePicture": profilePicture,
    };
  }

  // fromEntity
  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      id: entity.authId,
      fullName: entity.fullName,
      mobileNumber: entity.mobileNumber,
      // username: entity.username,
      email: entity.email,
      password: entity.password,
      confirmPassword: entity.confirmPassword,
      // role: entity.role,
      token: entity.token,
      profilePicture: entity.profilePicture,
    );
  }

  // toEntityList
  static List<AuthEntity> toEntityList(List<AuthApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
