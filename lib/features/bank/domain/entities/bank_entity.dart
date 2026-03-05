import 'package:equatable/equatable.dart';

class BankEntity extends Equatable {
  final String? id;
  final String? accountNumber;
  final bool linked;

  const BankEntity({
    this.id,
    this.accountNumber,
    this.linked = true,
  });

  @override
  List<Object?> get props => [id, accountNumber, linked];
}
