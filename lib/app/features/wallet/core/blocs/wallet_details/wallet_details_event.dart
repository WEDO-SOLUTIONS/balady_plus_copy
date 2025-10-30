part of 'wallet_details_bloc.dart';

abstract class WalletDetailsEvent extends Equatable {
  const WalletDetailsEvent();

  @override
  List<Object> get props => [];
}

class ShareWalletItem extends WalletDetailsEvent {
  final WalletItem? selectedIetm;
  ShareWalletItem({this.selectedIetm});
}
