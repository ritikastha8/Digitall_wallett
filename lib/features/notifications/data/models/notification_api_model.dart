import 'package:digital_wallett_system/features/notifications/domain/entities/notification_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_api_model.g.dart';

@JsonSerializable()
class NotificationApiModel {
  @JsonKey(name: '_id')
  final String? id;
  final String? title;
  final String? body;
  final bool read;
  final DateTime? createdAt;

  const NotificationApiModel({
    this.id,
    this.title,
    this.body,
    this.read = false,
    this.createdAt,
  });

  factory NotificationApiModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationApiModelToJson(this);

  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      title: title,
      body: body,
      read: read,
      createdAt: createdAt,
    );
  }

  factory NotificationApiModel.fromEntity(NotificationEntity entity) {
    return NotificationApiModel(
      id: entity.id,
      title: entity.title,
      body: entity.body,
      read: entity.read,
      createdAt: entity.createdAt,
    );
  }
}
