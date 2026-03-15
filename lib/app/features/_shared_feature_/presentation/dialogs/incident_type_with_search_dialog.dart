import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../data/entities/drop_down_item.dart';
import '../widgets/buttons/custom_buttons_widgets.dart';
import '../widgets/custom_spaces_widgets.dart';
import '../widgets/radio_buttons/custom_radio_button_widget copy.dart';
import '../widgets/search_text_field_widget.dart';
import 'dialog_header.dart';

class IncidentTypeWithSearchDialog extends StatefulWidget {
  final Function(DropDownItem item) onSelect;
  List<DropDownItem> items;
  DropDownItem? selectedItem;
  String? title;
  String? searchHint;
  final bool? isButtonDisabled;

  IncidentTypeWithSearchDialog({
    super.key,
    required this.onSelect,
    this.selectedItem,
    required this.items,
    this.title,
    this.searchHint,
    this.isButtonDisabled,
  });

  @override
  State<StatefulWidget> createState() {
    return _IncidentTypeWithSearchDialog();
  }
}

class _IncidentTypeWithSearchDialog extends State<IncidentTypeWithSearchDialog> {
  List<DropDownItem> items = [];
  DropDownItem? currentSelected;

  //List<SpecializedClassificationItem> items = [];
  final ScrollController _scrollController = ScrollController();
  bool isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    currentSelected = widget.selectedItem;
    items.clear();
    items.addAll(widget.items);
    scrollToPrevoiusSelected();
    if (widget.isButtonDisabled != null) {
      isButtonDisabled = widget.isButtonDisabled!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 26, bottom: 10),
      child: Column(
        children: [
          // header
          DialogHeader(title: widget.title ?? ('choose_incident_type').tr()),
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
                return CustomRadioButtonEnd<DropDownItem>(
                  // title: items[index].name,
                  // value: items[index].id,
                  title: items[index].name ?? "",
                  value: items[index],
                  currentSelected: currentSelected,
                  onChange: onItemChanged,
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
                    //     SpecializedClassificationItem item = items.firstWhere(
                    //             (element) => element.id == currentSelected,
                    //         orElse: () => null);
                    if (currentSelected != null) {
                      widget.onSelect(currentSelected!);
                    }
                  },
            btnText: ("bookNewAppointmentSelectWord").tr(),
            btnTextSize: 16,
            btnTextWeight: AppFontWeight.regular,
            btnHeight: 56,
            btnRadius: 8,
          ),
        ],
      ),
    );
  }

  void onItemChanged(DropDownItem item) {
    FocusScope.of(context).unfocus();
    isButtonDisabled = false;
    setState(() {
      currentSelected = item;
    });
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
    //   LogsViewModel().sendEventFromModel(
    //     event: ErrorExceptionModel(
    //       nameEvent: EventsName.handledException,
    //       message: error.toString(),
    //       stackTrace: stackTrace.toString(),
    //     ),
    //   );
    // }
  }
}
