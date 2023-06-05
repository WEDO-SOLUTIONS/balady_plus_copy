import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show Bloc;

import '../../../../../core/utils/utils_exports.dart' show CommonFunctions;
import '../../../shared_feature_exports.dart' show DropDownItem;

part 'sheet_drop_down_event.dart';
part 'sheet_drop_down_state.dart';

class SheetDropDownBloc extends Bloc<SheetDropDownEvent, SheetDropDownState> {
  final List<DropDownItem> initialItems;
  SheetDropDownBloc({required this.initialItems})
      : super(SheetDropDownState(
          items: initialItems,
          cachedItems: initialItems,
        )) {
    ///
    on<OnUpdating>((event, emit) {
      emit(SheetDropDownState(
        selectedItem: state.items[event.index],
        items: initialItems,
        cachedItems: initialItems,
      ));
    });

    ///
    on<OnSearching>((event, emit) {
      final searchTerm = event.query;
      if (searchTerm.isEmpty) {
        emit(state.copyWith(items: state.cachedItems));
      } else {
        List<DropDownItem> filteredList = [];
        for (var item in state.cachedItems) {
          if (item.name.toLowerCase().contains(searchTerm) ||
              item.value.toLowerCase().contains(searchTerm) ||
              item.code.toLowerCase().contains(searchTerm)) {
            filteredList.add(item);
          }
        }
        emit(state.copyWith(items: filteredList));
      }
    }, transformer: CommonFunctions.debounce());

    ///
    on<OnBackToDefault>((event, emit) {
      emit(SheetDropDownState(
        selectedItem: state.selectedItem,
        items: initialItems,
        cachedItems: initialItems,
      ));
    });
  }
}
