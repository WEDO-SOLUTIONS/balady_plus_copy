import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart' show Translation;

import '../../shared_feature_exports.dart' show CustomSheetDropDownWidget, DropDownItem;

abstract class _SheetDropDown extends StatelessWidget {
  final Widget child;
  const _SheetDropDown(this.child);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class SheetDropDownWidget extends _SheetDropDown {
  ///
  SheetDropDownWidget.city({
    List<DropDownItem> items = const [],
    DropDownItem? initialValue,
    String? errorMsg,
    required void Function(DropDownItem?) onSelected,
  }) : super(
         CustomSheetDropDownWidget(
           items: items,
           initialValue: initialValue,
           label: "city".tr(),
           errorMsg: errorMsg,
           onSelected: onSelected,
         ),
       );

  ///
  SheetDropDownWidget.district({
    List<DropDownItem> items = const [],
    DropDownItem? initialValue,
    String? errorMsg,
    required void Function(DropDownItem?) onSelected,
  }) : super(
         CustomSheetDropDownWidget(
           items: items,
           initialValue: initialValue,
           label: "district".tr(),
           errorMsg: errorMsg,
           onSelected: onSelected,
         ),
       );
}
