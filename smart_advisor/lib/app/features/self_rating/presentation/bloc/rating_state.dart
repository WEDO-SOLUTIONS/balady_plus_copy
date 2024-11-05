part of 'rating_bloc.dart';

class RatingState extends Equatable {
  final BlocStatus status;
  final BlocStatus itemsStatus;
  final String? errorMessage;
  final RatingItemsResponseModel? items;
  final Map<int, List<RatingItemsResponseItem>>? sortedItems;
  // Constructor
  const RatingState(
      {this.status = BlocStatus.initial,
      this.itemsStatus = BlocStatus.initial,
      this.items,
      this.errorMessage,
      this.sortedItems});

  // CopyWith Method
  RatingState copyWith(
      {BlocStatus? status,
      BlocStatus? itemsStatus,
      String? errorMessage,
      RatingItemsResponseModel? items,
      Map<int, List<RatingItemsResponseItem>>? sortedItems}) {
    return RatingState(
        items: items ?? this.items,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        itemsStatus: itemsStatus ?? this.itemsStatus,
        sortedItems: sortedItems ?? this.sortedItems);
  }

  @override
  List<Object?> get props =>
      [status, errorMessage, itemsStatus, items, sortedItems];

  Map<int, List<RatingItemsResponseItem>> getRatingsItems(
      final RatingItemsResponseModel? items) {
    Map<int, List<RatingItemsResponseItem>> data = {};

    for (int i = 0; i < (items?.result?.length ?? 0); i++) {
      RatingItemsResponseItem item = items!.result![i];

      if (data.containsKey(item.clauseNo)) {
        List<RatingItemsResponseItem> ratings = data[item.clauseNo] ?? [];
        ratings.add(item);
        data.putIfAbsent(item.clauseNo!, () => ratings);
      } else {
        data.putIfAbsent(item.clauseNo!, () => [item]);
      }
    }

    return data;
  }

  String getClausesName(int clauseNo) {
    for (int i = 0; i < (items?.result?.length ?? 0); i++) {
      RatingItemsResponseItem item = items!.result![i];

      if (item.clauseNo == clauseNo) {
        return item.clauseName ?? "";
      }
    }
    return "";
  }
}
