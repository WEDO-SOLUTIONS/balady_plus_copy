import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../data/entities/drop_down_item.dart';
import '../widgets/buttons/custom_buttons_widgets.dart';
import '../widgets/check_boxes/custom_checkbox.dart';
import '../widgets/custom_spaces_widgets.dart';
import '../widgets/search_text_field_widget.dart';
import 'dialog_header.dart';

class MultiSelectionWithSearchDialog extends StatefulWidget {
  final Function(List<DropDownItem> items) onSelect;
  final List<DropDownItem> items;
  final List<DropDownItem>? selectedItem;
  final String? title;
  final String? searchHint;

  const MultiSelectionWithSearchDialog({
    super.key,
    required this.onSelect,
    this.selectedItem,
    required this.items,
    this.title,
    this.searchHint,
  });

  @override
  State<StatefulWidget> createState() {
    return _MultiSelectionWithSearchDialog();
  }
}

class _MultiSelectionWithSearchDialog extends State<MultiSelectionWithSearchDialog> {
  List<DropDownItem> items = [];
  List<DropDownItem> currentSelectedItems = [];

  //List<SpecializedClassificationItem> items = [];
  final ScrollController _scrollController = ScrollController();
  bool isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    currentSelectedItems = widget.selectedItem?.map((e) => e).toList() ?? [];
    items.clear();
    items.addAll(widget.items);
    scrollToPrevoiusSelected();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 26, bottom: 10),
      child: Column(
        children: [
          // header
          DialogHeader(title: widget.title ?? ""),
          const CustomVerticalSpace(height: 20),
          // search
          SearchTextFieldWidget(
            containerHeight: 52,
            hintText: widget.searchHint ?? ('searchFor').tr(),
            onTextChanged: /* () {},*/ (value) {
              setState(() {
                items = widget.items.where((element) => element.name.contains(value) ?? element.name == value).toList();
              });
            },
            onSubmitSearch: (String val) {},
          ),
          const CustomVerticalSpace(height: 20),
          // incident type list
          Expanded(
            child: ListView.builder(
              //   itemCount: items != null ? items.length : 0,
              itemCount: items.length,
              shrinkWrap: true,
              controller: _scrollController,
              itemBuilder: (ctx, index) {
                return CustomCheckbox(
                  key: ValueKey(items[index].id),
                  title: items[index].name ?? "",
                  isSelected: currentSelectedItems.contains(items[index]),
                  onSelect: (v) {
                    if (v) {
                      currentSelectedItems.add(items[index]);
                    } else {
                      currentSelectedItems.remove(items[index]);
                    }
                    isButtonDisabled = false;
                    /*if (currentSelectedItems.isEmpty) {
                        isButtonDisabled = true;
                      } else {
                        isButtonDisabled = false;
                      }*/
                    setState(() {});
                  },
                );
              },
            ),
          ),
          const CustomVerticalSpace(height: 5),
          // button
          EnhancedCustomElevatedButtonWidget(
            btnColor: isButtonDisabled ? AppColor.black200 : AppColor.primary900Light,
            btnTextColor: isButtonDisabled ? AppColor.black400 : AppColor.white,
            btnPressed: isButtonDisabled
                ? null
                : () {
                    Navigator.of(context).pop();

                    widget.onSelect(currentSelectedItems);
                  },
            btnText: ("bookNewAppointmentSelectWord").tr(),
            btnTextSize: 16,
            btnTextWeight: AppFontWeight.regular,
            btnHeight: 56,
          ),
        ],
      ),
    );
  }

  void scrollToPrevoiusSelected() {
    // if (currentSelected != "0")
    // try {
    //   double rowHeight = 72.0;
    //   int index =
    //   items.indexWhere((element) => element.id == currentSelected);
    //   WidgetsBinding.instance.addPostFrameCallback((_) => {
    //     _scrollController.animateTo(rowHeight * index,
    //         duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn)
    //   });
    // } catch (error, stackTrace) {
    // LogsViewModel().sendEventFromModel(
    //   event: ErrorExceptionModel(
    //     nameEvent: EventsName.handledException,
    //     message: error.toString(),
    //     stackTrace: stackTrace.toString(),
    //   ),
    // );
    // }
  }
}
