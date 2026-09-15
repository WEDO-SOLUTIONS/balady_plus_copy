/*import 'package:balady_plus/app/core/core_exports.dart';
import 'package:balady_plus/shared/core/data/entities/lookup_item.dart';
import 'package:flutter/material.dart';

import '../widgets/buttons/custom_buttons_widgets.dart';
import '../widgets/custom_spaces_widgets.dart';

class LookupWithSearchDialog extends StatefulWidget {
  final Function(LookUpItem item) onSelect;
  List<LookUpItem> items;
  LookUpItem? selectedItem;
  String? title;
  String? searchHint;

  LookupWithSearchDialog(
      {Key? key,
      required this.onSelect,
      this.selectedItem,
      required this.items,
      this.title,
      this.searchHint})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _IncidentTypeWithSearchDialog();
  }
}

class _IncidentTypeWithSearchDialog extends State<LookupWithSearchDialog> {
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
            title:
                widget.title ?? Helpers.translatingWord('choose_incident_type'),
          ),
          const CustomVerticalSpace(height: 20),
          // search
          SearchTextFieldWidget(
            containerHeight: 52,
            hintText: widget.searchHint ?? Helpers.translatingWord('searchFor'),
            onTextChanged: /* () {},*/
                (value) {
              setState(() {
                items = widget.items
                    .where((element) =>
                        element.name?.contains(value) ?? element.name == value)
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
            btnTextColor:
                isButtonDisabled ? AppColor.black400 : AppColor.white,
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
            btnText: Helpers.translatingWord("bookNewAppointmentSelectWord"),
            btnTextSize: 16,
            btnTextWeight: AppFontWeight.regular,
            btnHeight: 56,
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
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
  }
}
*/
