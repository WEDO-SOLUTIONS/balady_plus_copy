import 'package:flutter_bloc/flutter_bloc.dart' show Cubit;

import '../../../shared_feature_exports.dart' show DropDownItem;

//! ---------- Cubit ------------
class DropDownCubit extends Cubit<DropDownItem?> {
  // final List<DropDownItem> items;
  final DropDownItem? initialValue;
  DropDownCubit({/* required this.items, */ required this.initialValue})
      // In the initial-state, if user pass value for hint or leave it blank
      // then, search inside list, if matched with any value
      // then, return that drop-down of matched value
      // otherwise, pass this hint to to a new instance of drop-down
      // : super(items.firstWhere(
      //     (item) => item.selected || item.value == initialHint,
      //     orElse: () => sl<DropDownItem>().copyWith(value: initialHint),
      //   ));
      : super(initialValue);

  void onChangeValue(DropDownItem? selectedItem) => emit(selectedItem);
}
//! ---------- Eng of Cubit ------------

//! ---------- Cubit ------------
class CupertinoDropDownCubit extends Cubit<DropDownItem?> {
  final List<DropDownItem> items;
  // final String initialHint;
  final DropDownItem? initialValue;
  CupertinoDropDownCubit({required this.items, required this.initialValue})
      // _CupertinoDropDownCubit({required this.items, required this.initialHint})
      // In the initial-state, if user pass value for hint or leave it blank
      // then, search inside list, if matched with any value
      // then, return that drop-down of matched value
      // otherwise, pass this hint to to a new instance of drop-down
      // : super(items.firstWhere(
      //     (item) => item.selected || item.value == initialHint,
      //     orElse: () => sl<DropDownItem>().copyWith(value: initialHint),
      //   ));
      : super(initialValue);

  void onChangeValue(int selectedIndex) => emit(items.elementAt(selectedIndex));
}
//! ---------- Eng of Cubit ------------
