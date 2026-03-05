// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BankApiModel _$BankApiModelFromJson(Map<String, dynamic> json) => BankApiModel(
      id: json['_id'] as String?,
      accountNumber: json['accountNumber'] as String?,
      linked: json['linked'] as bool? ?? true,
    );

Map<String, dynamic> _$BankApiModelToJson(BankApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'accountNumber': instance.accountNumber,
      'linked': instance.linked,
    };
