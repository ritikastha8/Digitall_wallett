import 'package:equatable/equatable.dart';

class WalletEntity extends Equatable {
  final double balance;
  final String? currency;

  const WalletEntity({
    required this.balance,
    this.currency,
  });

  @override
  List<Object?> get props => [balance, currency];
}
