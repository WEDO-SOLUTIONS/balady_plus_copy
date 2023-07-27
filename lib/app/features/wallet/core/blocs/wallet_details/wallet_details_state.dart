part of 'wallet_details_bloc.dart';

class WalletDetailsState extends Equatable {
  BlocStatus status;
  WalletItem? selectedItem;
  String? errorMessage;
  WalletDetailsState(
      {this.status = BlocStatus.initial, this.selectedItem, this.errorMessage});

  WalletDetailsState copyWith(
      {BlocStatus? status, WalletItem? selectedItem, String? errorMessage}) {
    return WalletDetailsState(
        status: status ?? this.status,
        selectedItem: selectedItem ?? this.selectedItem,
        errorMessage: errorMessage ?? this.errorMessage);
  }

  @override
  List<Object> get props => [status];
}
