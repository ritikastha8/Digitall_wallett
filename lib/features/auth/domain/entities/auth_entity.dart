import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? authId;
  final String fullName;
  final String mobileNumber;
  final String email;
  // final String username;
  final String? password;
  final String? confirmPassword;
  // final String role;
  final String? profilePicture;
  final String? token;

  const AuthEntity({
    this.authId,
    required this.fullName,
    required this.mobileNumber,
    required this.email,
    // required this.username,
    this.password,
    this.confirmPassword,
    // this.role = "user",
    this.profilePicture,
    this.token,
  });

  @override
  List<Object?> get props => [
    authId,
    fullName,
    mobileNumber,
    // username,
    email,
    password,
    confirmPassword,
    // role,
    profilePicture,
    token,
  ];
}
