import 'package:equatable/equatable.dart';

class ReceiveQrEntity extends Equatable {
  final String payload;
  final String? mobileNumber;
  final String? name;
  final double? amount;
  final String? qrImageBase64;

  const ReceiveQrEntity({
    required this.payload,
    this.mobileNumber,
    this.name,
    this.amount,
    this.qrImageBase64,
  });

  @override
  List<Object?> get props => [payload, mobileNumber, name, amount, qrImageBase64];
}
