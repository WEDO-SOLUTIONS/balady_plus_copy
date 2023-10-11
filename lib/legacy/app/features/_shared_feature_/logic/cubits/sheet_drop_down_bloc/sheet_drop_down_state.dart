part of 'sheet_drop_down_bloc.dart';

class SheetDropDownState extends Equatable {
  final List<DropDownItem> items;
  final List<DropDownItem> cachedItems;
  final DropDownItem? selectedItem;
  const SheetDropDownState({
    this.items = const [],
    this.cachedItems = const [],
    this.selectedItem,
  });

  @override
  List<Object?> get props => [items, cachedItems, selectedItem];

  SheetDropDownState copyWith({
    List<DropDownItem>? items,
    List<DropDownItem>? cachedItems,
    DropDownItem? selectedItem,
  }) {
    return SheetDropDownState(
      items: items ?? this.items,
      cachedItems: cachedItems ?? this.cachedItems,
      selectedItem: selectedItem ?? this.selectedItem,
    );
  }

  @override
  String toString() => 'SheetDropDownState(selectedItem: $selectedItem)';
}
