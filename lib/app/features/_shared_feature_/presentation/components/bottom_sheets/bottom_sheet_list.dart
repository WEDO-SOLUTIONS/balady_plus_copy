import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart' show AppColor, AppStyle;
import '../../../shared_feature_exports.dart' show BottomSheetWithActions, CustomTextWidget, ElevatedButtonWidget;

class BottomSheetList extends StatefulWidget {
  final String title;
  final List<String> items;
  final String? selectedValue;
  final List<String>? selectedValues;
  final void Function(dynamic)? onTap;
  final bool searchable;

  const BottomSheetList({
    super.key,
    required this.title,
    required this.items,
    this.selectedValue,
    this.selectedValues,
    required this.onTap,
    this.searchable = true,
  });

  @override
  State<BottomSheetList> createState() => _BottomSheetListState();
}

class _BottomSheetListState extends State<BottomSheetList> {
  late bool multipleSelection;
  late List<String> items;
  String? selectedValue;
  List<String>? selectedValues;

  @override
  void initState() {
    super.initState();
    items = widget.items;
    selectedValue = widget.selectedValue;
    selectedValues = widget.selectedValues;
    multipleSelection = widget.selectedValues != null;
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetWithActions(
      title: widget.title,
      isList: true,
      searchable: widget.searchable,
      onSearchChanged: (String? text) {
        setState(() {
          items = widget.items.where((element) => element.toLowerCase().contains(text ?? "")).toList();
        });
      },
      body: Flexible(
        child: CustomScrollView(
          shrinkWrap: true,
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final item = items[index];
                return InkWell(
                  onTap: () => selectItem(item),
                  child: Container(
                    height: 56,
                    padding: const EdgeInsetsDirectional.only(start: 12),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColor.primary50Light50),
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 125,
                          child: CustomTextWidget(item, textStyle: AppStyle.listTitleTextStyle, maxLines: 2),
                        ),
                        const Spacer(),
                        if (widget.onTap != null && !multipleSelection)
                          RadioGroup<String>(
                            groupValue: selectedValue,
                            onChanged: (_) => selectItem(item),
                            child: Radio<String>(value: item, activeColor: AppColor.primary700Light),
                          )
                        else if (widget.onTap != null)
                          Checkbox(
                            value: selectedValues!.contains(item),
                            activeColor: AppColor.primary700Light,
                            onChanged: (_) => selectItem(item),
                          ),
                      ],
                    ),
                  ),
                );
              }, childCount: items.length),
            ),
          ],
        ),
      ),
      action: widget.onTap == null
          ? null
          : ElevatedButtonWidget.choose(
              onPressed: () {
                if (selectedValue != null) {
                  widget.onTap!(selectedValue!);
                } else if (selectedValues != null) {
                  widget.onTap!(selectedValues);
                }
              },
            ),
    );
  }

  void selectItem(String item) {
    setState(() {
      if (multipleSelection) {
        if (selectedValues!.contains(item)) {
          selectedValues!.remove(item);
        } else {
          selectedValues!.add(item);
        }
      } else {
        selectedValue = item;
      }
    });
  }
}
