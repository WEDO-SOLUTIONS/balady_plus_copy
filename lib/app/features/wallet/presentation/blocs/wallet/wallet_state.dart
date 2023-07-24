part of 'wallet_cubit.dart';

class WalletState extends Equatable {
  final bool viewAll;

  const WalletState({
    this.viewAll = false,
  });

  @override
  List<Object> get props => [
        viewAll,
      ];

  WalletState copyWith({
    bool? viewAll,
  }) {
    return WalletState(
      viewAll: viewAll ?? this.viewAll,
    );
  }
}
