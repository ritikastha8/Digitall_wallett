import 'package:equatable/equatable.dart';

class DashboardEntity extends Equatable {
  final String? itemId;
  final String? media; // image/file path
  final String? mediaType; // image, video, etc.
  // not sure about status
  final String? status;

  const DashboardEntity({this.itemId, this.media, this.mediaType, this.status});

  @override
  List<Object?> get props => [itemId, media, mediaType, status];
}
