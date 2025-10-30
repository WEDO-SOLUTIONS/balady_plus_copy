part of 'wallet_bloc.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object> get props => [];
}

class GetWalletDataEvent extends WalletEvent {
  GetWalletDataEvent();
}

class ChangeWalletItem extends WalletEvent {
  final WalletItem? selectedIetm;
  ChangeWalletItem({this.selectedIetm});
}

class ShareWalletItemEvent extends WalletEvent {
  final WalletItem? selectedIetm;
  ShareWalletItemEvent({this.selectedIetm});
}

class ChangeViewAllEvent extends WalletEvent {
  const ChangeViewAllEvent();
}

class ChangeTypeEvent extends WalletEvent {
  final int index;
  const ChangeTypeEvent({required this.index});
}
