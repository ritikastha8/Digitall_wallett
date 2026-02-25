// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationApiModel _$NotificationApiModelFromJson(
        Map<String, dynamic> json) =>
    NotificationApiModel(
      id: json['_id'] as String?,
      title: json['title'] as String?,
      body: json['body'] as String?,
      read: json['read'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$NotificationApiModelToJson(
        NotificationApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'read': instance.read,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
