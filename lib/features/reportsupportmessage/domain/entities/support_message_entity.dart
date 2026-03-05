import 'package:equatable/equatable.dart';

class SupportMessageEntity extends Equatable {
  final String? id;
  final String message;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SupportMessageEntity({
    this.id,
    required this.message,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [id, message, createdAt, updatedAt];
}
