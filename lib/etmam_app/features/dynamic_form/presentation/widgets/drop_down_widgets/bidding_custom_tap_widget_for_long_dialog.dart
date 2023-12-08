import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';
import 'package:flutter/material.dart';

import '../../../../../../app/core/services/local/navigation_services.dart';
import '../../../../../../app/features/_shared_feature_/data/entities/drop_down_item.dart';
import '../../../../../../app/features/_shared_feature_/presentation/dialogs/incident_type_with_search_dialog.dart';
import '../../../../../../app/features/_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../../../../app/features/_shared_feature_/presentation/widgets/custom_popups_widgets.dart';

class BiddingCustomTapWidgetForLongDialog extends StatefulWidget {
  DropDownItem? value;
  Function(DropDownItem? item) onChangeType;
  Function onEmptyList;
  List<DropDownItem> items;
  String label;
  String? hint;
  String? searchHint;
  String? errorText;
  final bool? showOptional;
  final bool showHintAsTitle;

  BiddingCustomTapWidgetForLongDialog(
      {Key? key,
      required this.onChangeType,
      required this.onEmptyList,
      this.value,
      required this.items,
      this.hint,
      required this.label,
      this.searchHint,
      this.errorText,
      this.showOptional = false,
      this.showHintAsTitle = true})
      : super(key: key);

  @override
  State<BiddingCustomTapWidgetForLongDialog> createState() =>
      _BiddingCustomTapWidgetForLongDialog();
}

class _BiddingCustomTapWidgetForLongDialog
    extends State<BiddingCustomTapWidgetForLongDialog> {
  @override
  Widget build(BuildContext context) {
    return CustomHeaderAndDescOnTapWidget(
      label: widget.label,
      hintText: widget.hint!,
      textValue: widget.value?.name,
      showOptional: widget.showOptional,
      onTap: widget.items.isNotEmpty
          ? () async {
              FocusManager.instance.primaryFocus?.unfocus();
              await CustomPopUpsWidgets.showBottomSheet(
                NavigationService.navigatorKey.currentContext!,
                child: IncidentTypeWithSearchDialog(
                  onSelect: (DropDownItem item) => widget.onChangeType(item),
                  items: widget.items,
                  selectedItem: widget.value,
                  title: widget.showHintAsTitle ? widget.hint : widget.label,
                  searchHint: widget.searchHint,
                ),
              );
            }
          : () async {
              FocusManager.instance.primaryFocus?.unfocus();
              List<DropDownItem>? items = await widget.onEmptyList();
              if (items != null) {
                FocusManager.instance.primaryFocus?.unfocus();
                await CustomPopUpsWidgets.showBottomSheet(
                  NavigationService.navigatorKey.currentContext!,
                  child: IncidentTypeWithSearchDialog(
                    onSelect: (DropDownItem item) => widget.onChangeType(item),
                    items: items,
                    selectedItem: widget.value,
                    title: widget.showHintAsTitle ? widget.hint : widget.label,
                    searchHint: widget.searchHint,
                  ),
                );
              }
            },
    );
  }
}
