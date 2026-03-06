import 'package:json_annotation/json_annotation.dart';

part 'dashboard_api_model.g.dart';

@JsonSerializable()
class DashboardApiModel {
  final String? media;

  const DashboardApiModel({this.media});

  factory DashboardApiModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardApiModelToJson(this);
}
