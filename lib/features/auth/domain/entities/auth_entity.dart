import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? authId;
  final String fullName;
  final String? mobileNumber;
  final String username;
  final String? password;
  final String? profilePicture;

  const AuthEntity({
    this.authId,
    required this.fullName,
    this.mobileNumber,
    required this.username,
    this.password,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [
    authId,
    fullName,
    mobileNumber,
    username,
    password,
    profilePicture,
  ];
}
