// import 'package:equatable/equatable.dart';

// class FeedbackEntity extends Equatable {
//   final String? id;
//   final String message;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;

//   const FeedbackEntity({
//     this.id,
//     required this.message,
//     this.createdAt,
//     this.updatedAt,
//   });

//   @override
//   List<Object?> get props => [id, message, createdAt, updatedAt];
// }

import 'package:equatable/equatable.dart';

class FeedbackEntity extends Equatable {
  final String? id;
  final String feedback; // The main feedback content
  final String futureImprovements; // The improvement ideas content
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const FeedbackEntity({
    this.id,
    required this.feedback,
    required this.futureImprovements,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    feedback,
    futureImprovements,
    createdAt,
    updatedAt,
  ];
}
