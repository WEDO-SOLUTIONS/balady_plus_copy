part of 'wallet_details_bloc.dart';

class WalletDetailsState extends Equatable {
  BlocStatus status;
  BlocStatus photoStatus;
  bool? photoNeedUpdate;
  WalletItem? selectedItem;
  String? errorMessage;
  WalletDetailsState(
      {this.status = BlocStatus.initial,
      this.selectedItem,
      this.errorMessage,
      this.photoStatus = BlocStatus.initial,
      this.photoNeedUpdate});

  WalletDetailsState copyWith(
      {BlocStatus? status,
      WalletItem? selectedItem,
      String? errorMessage,
      BlocStatus? photoStatus,
      bool? photoNeedUpdate}) {
    return WalletDetailsState(
        status: status ?? this.status,
        photoStatus: photoStatus ?? this.photoStatus,
        selectedItem: selectedItem ?? this.selectedItem,
        errorMessage: errorMessage ?? this.errorMessage,
        photoNeedUpdate: photoNeedUpdate ?? this.photoNeedUpdate);
  }

  @override
  List<Object?> get props => [status, photoStatus, photoNeedUpdate];
}
