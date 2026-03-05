import 'package:digital_wallett_system/features/wallet/domain/entities/wallet_entity.dart';
import 'package:equatable/equatable.dart';

enum WalletStatus {
  initial,
  loading,
  loaded,
  error,
}

class WalletState extends Equatable {
  final WalletStatus status;
  final WalletEntity? wallet;
  final String? errorMessage;

  const WalletState({
    this.status = WalletStatus.initial,
    this.wallet,
    this.errorMessage,
  });

  WalletState copyWith({
    WalletStatus? status,
    WalletEntity? wallet,
    String? errorMessage,
  }) {
    return WalletState(
      status: status ?? this.status,
      wallet: wallet ?? this.wallet,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, wallet, errorMessage];
}
