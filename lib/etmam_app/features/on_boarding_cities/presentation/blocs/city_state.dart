part of 'city_bloc.dart';

class CityState extends Equatable {
  BlocStatus status;
  BlocStatus providersStatus;

  String? errorMessage;
  List<CityItem>? items;
  List<CityItem>? searchedItems;

  CityItem? selectedItem;
  int? totalPageCount;
  int? totalItemCount;
  int nextPageIndex;
  String? searchText;

  CityState(
      {this.status = BlocStatus.initial,
      this.providersStatus = BlocStatus.initial,
      this.errorMessage,
      this.items,
      this.nextPageIndex = 1,
      this.searchedItems,
      this.selectedItem,
      this.totalItemCount,
      this.totalPageCount,
      this.searchText});

  CityState copyWith(
      {BlocStatus? status,
      String? errorMessage,
      BlocStatus? providersStatus,
      List<CityItem>? items,
      List<CityItem>? searchedItems,
      int? totalPageCount,
      int? totalItemCount,
      int? nextPageIndex,
      CityItem? selectedItem,
      String? searchText}) {
    return CityState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        items: items ?? this.items,
        totalPageCount: totalPageCount ?? this.totalPageCount,
        totalItemCount: totalItemCount ?? this.totalItemCount,
        nextPageIndex: nextPageIndex ?? this.nextPageIndex,
        selectedItem: selectedItem ?? this.selectedItem,
        providersStatus: providersStatus ?? this.providersStatus,
        searchedItems: searchedItems ?? this.searchedItems,
        searchText: searchText ?? this.searchText);
  }

  @override
  List<Object?> get props =>
      [status, selectedItem ?? 0, providersStatus, searchText];
}
