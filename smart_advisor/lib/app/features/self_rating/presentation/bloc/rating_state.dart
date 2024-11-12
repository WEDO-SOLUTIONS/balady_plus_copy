part of 'rating_bloc.dart';

class RatingState extends Equatable {
  final BlocStatus status;
  final BlocStatus itemsStatus;
  final String? errorMessage;
  final RatingItemsResponseModel? items;
  final Map<String, List<RatingItemsResponseItem>>? sortedItems;
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
      Map<String, List<RatingItemsResponseItem>>? sortedItems}) {
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

  Map<String, List<RatingItemsResponseItem>> getRatingsItems(
      final RatingItemsResponseModel? items) {
    Map<String, List<RatingItemsResponseItem>> data = {};

    for (int i = 0; i < (items?.result?.length ?? 0); i++) {
      RatingItemsResponseItem item = items!.result![i];

      if (!data.containsKey(item.getClausesName())) {
        // If clauseName not in the map, initialize with the current item
        data[item.getClausesName()!] = [item];
      } else {
        // Check for duplicate subClauseName under the same clauseName
        bool isDuplicate = data[item.getClausesName()]!.any(
            (existingItem) => existingItem.subClauseName == item.subClauseName);

        if (isDuplicate) {
          item.isDuplicated = true; // Mark as duplicate
        } else {
          item.isDuplicated =
              false; // Ensure unique items have false as default
        }
        data[item.getClausesName()]!.add(item);
      }
    }

    return data;
  }

  String getClausesName(int clauseNo) {
    for (int i = 0; i < (items?.result?.length ?? 0); i++) {
      RatingItemsResponseItem item = items!.result![i];

      if (item.clauseNo == clauseNo) {
        return item.getClausesName();
      }
    }
    return "";
  }

  int? getNoOfNonCompliaanceReason(List<RatingItemsResponseItem> items) {
    int no = items.where((e) => e.isClausesValidated == 2).length;

    if (items.firstOrNull?.isSaved == true) {
      return no;
    } else {
      return null;
    }
  }
}
