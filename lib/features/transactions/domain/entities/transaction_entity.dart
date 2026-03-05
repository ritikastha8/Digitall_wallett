import 'package:equatable/equatable.dart';

class TransactionEntity extends Equatable {
  final String? id;
  final String type;
  final String? mobileNumber;
  final String? toMobileNumber;
  final double amount;
  final String? remarks;
  final DateTime? createdAt;
  final String? status;

  const TransactionEntity({
    this.id,
    required this.type,
    this.mobileNumber,
    this.toMobileNumber,
    required this.amount,
    this.remarks,
    this.createdAt,
    this.status,
  });

  @override
  List<Object?> get props => [id, type, mobileNumber, toMobileNumber, amount, remarks, createdAt, status];
}
