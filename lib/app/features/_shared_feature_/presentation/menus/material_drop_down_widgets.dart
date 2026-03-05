import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart' show Translation;

import '../../shared_feature_exports.dart' show CustomMaterialDropDownWidget, DropDownItem;

abstract class _MaterialDropDown extends StatelessWidget {
  final Widget child;
  const _MaterialDropDown(this.child);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class MaterialDropDownWidget extends _MaterialDropDown {
  ///
  MaterialDropDownWidget.city({
    List<DropDownItem> items = const [],
    DropDownItem? initialValue,
    String? errorMsg,
    required void Function(DropDownItem?) onSelected,
  }) : super(
         CustomMaterialDropDownWidget(
           items: items,
           initialValue: initialValue,
           label: "city".tr(),
           errorMsg: errorMsg,
           onSelected: onSelected,
         ),
       );

  ///
  MaterialDropDownWidget.district({
    List<DropDownItem> items = const [],
    DropDownItem? initialValue,
    String? errorMsg,
    required void Function(DropDownItem?) onSelected,
  }) : super(
         CustomMaterialDropDownWidget(
           items: items,
           initialValue: initialValue,
           label: "district".tr(),
           errorMsg: errorMsg,
           onSelected: onSelected,
         ),
       );
}
