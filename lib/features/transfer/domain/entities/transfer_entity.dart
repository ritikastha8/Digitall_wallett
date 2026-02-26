import 'package:equatable/equatable.dart';

class TransferEntity extends Equatable {
  final String? id;
  final String recipientMobile;
  final double amount;
  final String remarks;
  final DateTime? createdAt;
  final String? status;

  const TransferEntity({
    this.id,
    required this.recipientMobile,
    required this.amount,
    required this.remarks,
    this.createdAt,
    this.status,
  });

  @override
  List<Object?> get props => [id, recipientMobile, amount, remarks, createdAt, status];
}
