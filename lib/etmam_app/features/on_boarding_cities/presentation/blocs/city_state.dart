part of 'city_bloc.dart';

class CityState extends Equatable {
  BlocStatus status;
  String? errorMessage;
  List<CityItem>? items;
  List<CityItem>? searchedItems;

  CityItem? selectedItem;
  int? totalPageCount;
  int? totalItemCount;
  int nextPageIndex;
  CityState(
      {this.status = BlocStatus.initial,
      this.errorMessage,
      this.items,
      this.nextPageIndex = 1,
      this.searchedItems,
      this.selectedItem,
      this.totalItemCount,
      this.totalPageCount});

  CityState copyWith(
      {BlocStatus? status,
      String? errorMessage,
      List<CityItem>? items,
      List<CityItem>? searchedItems,
      int? totalPageCount,
      int? totalItemCount,
      int? nextPageIndex,
      CityItem? selectedItem}) {
    return CityState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        items: items ?? this.items,
        totalPageCount: totalPageCount ?? this.totalPageCount,
        totalItemCount: totalItemCount ?? this.totalItemCount,
        nextPageIndex: nextPageIndex ?? this.nextPageIndex,
        selectedItem: selectedItem ?? this.selectedItem,
        searchedItems: searchedItems ?? this.searchedItems);
  }

  @override
  List<Object> get props => [status, selectedItem ?? 0];
}
