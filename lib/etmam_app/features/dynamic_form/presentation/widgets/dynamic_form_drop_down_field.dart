import 'package:balady_plus/etmam_app/features/dynamic_form/presentation/widgets/bidding_drop_down_component.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/presentation/widgets/bidding_error_widget.dart';
import 'package:flutter/material.dart';

import '../../../../../app/features/_shared_feature_/data/entities/drop_down_item.dart';

class DynamicFormDropDownField extends StatelessWidget {
  final String label;
  final bool isRequired;
  final bool isReadOnly;
  final List<DropDownItem>? items;
  final Function(DropDownItem?) onChanged;
  final DropDownItem? currentItem;
  final List<String>? errors;

  final Function() onEmptyList;

  const DynamicFormDropDownField(
      {super.key,
      required this.label,
      this.isRequired = false,
      this.isReadOnly = false,
      required this.onChanged,
      required this.onEmptyList,
      this.currentItem,
      this.errors,
      this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        BiddingDropDownListAddetionalField(
          isMandatory: isRequired,
          fieldName: label,
          currentItem: currentItem,
          items: items ?? [],
          onChanged: onChanged,
          onEmptyList: onEmptyList,
        ),
        BiddingErrorsWidget(
          errors: errors,
        )
      ],
    ));
  }
}
