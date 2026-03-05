import 'package:digital_wallett_system/features/bank/domain/entities/bank_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bank_api_model.g.dart';

@JsonSerializable()
class BankApiModel {
  @JsonKey(name: '_id')
  final String? id;
  final String? accountNumber;
  final bool linked;

  const BankApiModel({
    this.id,
    this.accountNumber,
    this.linked = true,
  });

  factory BankApiModel.fromJson(Map<String, dynamic> json) =>
      _$BankApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$BankApiModelToJson(this);

  BankEntity toEntity() {
    return BankEntity(id: id, accountNumber: accountNumber, linked: linked);
  }

  factory BankApiModel.fromEntity(BankEntity entity) {
    return BankApiModel(
      id: entity.id,
      accountNumber: entity.accountNumber,
      linked: entity.linked,
    );
  }
}
