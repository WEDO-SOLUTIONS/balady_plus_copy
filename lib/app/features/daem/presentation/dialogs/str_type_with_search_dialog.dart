import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/enums/app_font_weights.dart';
import '../../../_shared_feature_/presentation/dialogs/dialog_header.dart';
import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/radio_buttons/custom_radio_button_widget copy.dart';
import '../../../_shared_feature_/presentation/widgets/search_text_field_widget.dart';
import '../../../new_appointment/presentation/core/models/lookup_list_model.dart';
import '../../data/models/daem_item.dart';

class DaemTypeWithSearchDialog extends StatefulWidget {
  final Function(DaemItem item) onSelect;
  List<DaemItem> items;
  DaemItem? selectedItem;
  String? title;
  String? searchHint;

  DaemTypeWithSearchDialog(
      {Key? key,
      required this.onSelect,
      this.selectedItem,
      required this.items,
      this.title,
      this.searchHint})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DaemTypeWithSearchDialog();
  }
}

class _DaemTypeWithSearchDialog extends State<DaemTypeWithSearchDialog> {
  List<DaemItem> items = [];
  DaemItem? currentSelected;

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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 26, bottom: 10),
      child: Column(
        children: [
          // header
          DialogHeader(
            title: widget.title ?? ('choose_incident_type').tr(),
          ),
          const CustomVerticalSpace(height: 20),
          // search
          SearchTextFieldWidget(
            containerHeight: 52,
            hintText: widget.searchHint ?? ('searchFor').tr(),
            onTextChanged: /* () {},*/
                (value) {
              setState(() {
                items = widget.items
                    .where((element) => element.name?.contains(value) ?? false)
                    .toList();
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
                  return CustomRadioButtonEnd<DaemItem>(
                    // title: items[index].name,
                    // value: items[index].id,
                    title: items[index].name ?? "",
                    value: items[index],
                    currentSelected: currentSelected,
                    onChange: onItemChanged,
                  );
                }),
          ),
          const CustomVerticalSpace(height: 5),
          // button
          EnhancedCustomElevatedButtonWidget(
            btnColor:
                isButtonDisabled ? AppColor.black200 : AppColor.primary900Light,
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
          )
        ],
      ),
    );
  }

  void onItemChanged(DaemItem item) {
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

class LookupTypeWithSearchDialog extends StatefulWidget {
  final Function(LookUpItem item) onSelect;
  List<LookUpItem> items;
  LookUpItem? selectedItem;
  String? title;
  String? searchHint;

  LookupTypeWithSearchDialog(
      {Key? key,
      required this.onSelect,
      this.selectedItem,
      required this.items,
      this.title,
      this.searchHint})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LookupTypeWithSearchDialog();
  }
}

class _LookupTypeWithSearchDialog extends State<LookupTypeWithSearchDialog> {
  List<LookUpItem> items = [];
  LookUpItem? currentSelected;

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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 26, bottom: 10),
      child: Column(
        children: [
          // header
          DialogHeader(
            title: widget.title ?? ('choose_incident_type').tr(),
          ),
          const CustomVerticalSpace(height: 20),
          // search
          SearchTextFieldWidget(
            containerHeight: 52,
            hintText: widget.searchHint ?? ('searchFor').tr(),
            onTextChanged: /* () {},*/
                (value) {
              setState(() {
                items = widget.items
                    .where((element) => element.name?.contains(value) ?? false)
                    .toList();
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
                  return CustomRadioButtonEnd<LookUpItem>(
                    // title: items[index].name,
                    // value: items[index].id,
                    title: items[index].name ?? "",
                    value: items[index],
                    isDisabled: items[index].isDisblaed,

                    currentSelected: currentSelected,
                    onChange: onItemChanged,
                  );
                }),
          ),
          const CustomVerticalSpace(height: 5),
          // button
          EnhancedCustomElevatedButtonWidget(
            btnColor:
                isButtonDisabled ? AppColor.black200 : AppColor.primary900Light,
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
          )
        ],
      ),
    );
  }

  void onItemChanged(LookUpItem item) {
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
