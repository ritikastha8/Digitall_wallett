// import 'package:digital_wallett_system/features/feedback/domain/entities/feedback_entity.dart';

// class FeedbackApiModel {
//   final String? id;
//   final String message;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;

//   const FeedbackApiModel({
//     this.id,
//     required this.message,
//     this.createdAt,
//     this.updatedAt,
//   });

//   factory FeedbackApiModel.fromJson(Map<String, dynamic> json) {
//     return FeedbackApiModel(
//       id: (json['_id'] ?? json['id'])?.toString(),
//       message:
//           json['message']?.toString() ??
//           json['body']?.toString() ??
//           json['content']?.toString() ??
//           '',
//       createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
//       updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? ''),
//     );
//   }

//   FeedbackEntity toEntity() {
//     return FeedbackEntity(
//       id: id,
//       message: message,
//       createdAt: createdAt,
//       updatedAt: updatedAt,
//     );
//   }
// }
import 'package:digital_wallett_system/features/feedback/domain/entities/feedback_entity.dart';

class FeedbackApiModel {
  final String? id;
  final String feedback;
  final String futureImprovements;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const FeedbackApiModel({
    this.id,
    required this.feedback,
    required this.futureImprovements,
    this.createdAt,
    this.updatedAt,
  });

  factory FeedbackApiModel.fromJson(Map<String, dynamic> json) {
    return FeedbackApiModel(
      id: (json['_id'] ?? json['id'])?.toString(),
      feedback: json['feedback']?.toString() ?? '',
      futureImprovements: json['futureImprovements']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'feedback': feedback,
      'futureImprovements': futureImprovements,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  FeedbackEntity toEntity() {
    return FeedbackEntity(
      id: id,
      feedback: feedback,
      futureImprovements: futureImprovements,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory FeedbackApiModel.fromEntity(FeedbackEntity entity) {
    return FeedbackApiModel(
      id: entity.id,
      feedback: entity.feedback,
      futureImprovements: entity.futureImprovements,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
