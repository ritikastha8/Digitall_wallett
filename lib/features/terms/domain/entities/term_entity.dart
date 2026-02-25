import 'package:equatable/equatable.dart';

class TermEntity extends Equatable {
  final String? id;
  final String? title;
  final String? content;
  final DateTime? updatedAt;

  const TermEntity({
    this.id,
    this.title,
    this.content,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [id, title, content, updatedAt];
}
