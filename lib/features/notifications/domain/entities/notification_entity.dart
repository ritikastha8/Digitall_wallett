import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String? id;
  final String? title;
  final String? body;
  final bool read;
  final DateTime? createdAt;

  const NotificationEntity({
    this.id,
    this.title,
    this.body,
    this.read = false,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, title, body, read, createdAt];
}
