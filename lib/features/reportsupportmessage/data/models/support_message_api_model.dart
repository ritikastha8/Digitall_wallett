import 'package:digital_wallett_system/features/reportsupportmessage/domain/entities/support_message_entity.dart';

class SupportMessageApiModel {
  final String? id;
  final String message;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SupportMessageApiModel({
    this.id,
    required this.message,
    this.createdAt,
    this.updatedAt,
  });

  factory SupportMessageApiModel.fromJson(Map<String, dynamic> json) {
    return SupportMessageApiModel(
      id: (json['_id'] ?? json['id'])?.toString(),
      message:
          json['message']?.toString() ??
          json['body']?.toString() ??
          json['content']?.toString() ??
          '',
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'message': message,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  SupportMessageEntity toEntity() {
    return SupportMessageEntity(
      id: id,
      message: message,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory SupportMessageApiModel.fromEntity(SupportMessageEntity entity) {
    return SupportMessageApiModel(
      id: entity.id,
      message: entity.message,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
