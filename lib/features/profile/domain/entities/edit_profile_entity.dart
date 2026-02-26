import 'package:equatable/equatable.dart';

class EditProfileEntity extends Equatable {
  final String fullName;
  final String mobileNumber;
  final String? profilePicture;

  const EditProfileEntity({
    required this.fullName,
    required this.mobileNumber,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [fullName, mobileNumber, profilePicture];
}

