part of 'wallet_bloc.dart';

class WalletState extends Equatable {
  BlocStatus status;
  List<WalletItem>? items;
  WalletItem? selectedItem;
  String? errorMessage;
  bool? showAll;
  int selectedTypeIndex;
  WalletState(
      {this.status = BlocStatus.initial,
      this.items,
      this.selectedItem,
      this.errorMessage,
      this.showAll = false,
      this.selectedTypeIndex = 0});

  WalletState copyWith(
      {BlocStatus? status,
      List<WalletItem>? items,
      WalletItem? selectedItem,
      String? errorMessage,
      bool? showAll,
      int? selectedTypeIndex}) {
    return WalletState(
        status: status ?? this.status,
        items: items ?? this.items,
        selectedItem: selectedItem ?? this.selectedItem,
        errorMessage: errorMessage ?? this.errorMessage,
        showAll: showAll ?? this.showAll,
        selectedTypeIndex: selectedTypeIndex ?? this.selectedTypeIndex);
  }

  List<WalletItem> getItems() {
    return selectedTypeIndex != 0
        ? items
                ?.where((e) =>
                    e.getLicenseType() ==
                    wallerTypesData[selectedTypeIndex - 1].types)
                .toList() ??
            []
        : items ?? [];
  }

  @override
  List<Object?> get props => [status, showAll, selectedTypeIndex];
}
