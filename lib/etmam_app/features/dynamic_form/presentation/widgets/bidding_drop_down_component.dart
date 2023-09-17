import 'package:balady_plus/app/core/services/local/helpers.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/presentation/widgets/drop_down_widgets/bidding_custom_tap_widget_for_long_dialog.dart';
import 'package:flutter/material.dart';

import '../../../../../app/features/_shared_feature_/data/entities/drop_down_item.dart';

class BiddingDropDownListAddetionalField extends StatelessWidget {
  final String fieldName;
  final bool isMandatory;
  final DropDownItem? currentItem;
  final List<DropDownItem> items;
  final Function(DropDownItem?) onChanged;
  final Function onEmptyList;

  BiddingDropDownListAddetionalField(
      {Key? key,
      this.currentItem,
      required this.isMandatory,
      required this.fieldName,
      required this.items,
      required this.onChanged,
      required this.onEmptyList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BiddingCustomTapWidgetForLongDialog(
      items: items,
      value: currentItem,
      showOptional: !isMandatory,
      showHintAsTitle: false,
      onChangeType: (DropDownItem? item) {
        onChanged(item);
      },
      onEmptyList: onEmptyList,
      label: fieldName,
      hint: Helpers.translatingWord("choose_hint"),
      searchHint: Helpers.translatingWord("searchFor"),
    );
  }
}
