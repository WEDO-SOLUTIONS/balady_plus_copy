import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart' show AppColor, AppFontWeight, AppStyle, IconPath;
import '../../../shared_feature_exports.dart'
    show BottomSheetWithActions, CustomTextFieldWidget, CustomTextWidget, DrawIconBasedTypeWidget, ElevatedButtonWidget;

class GenericBottomSheetList<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final T? selectedValue;
  final List<T>? selectedValues;
  final void Function(dynamic)? onTap;
  final bool searchable;
  final String? noDataMsg;

  const GenericBottomSheetList({
    super.key,
    required this.title,
    required this.items,
    this.selectedValue,
    this.selectedValues,
    required this.onTap,
    this.noDataMsg,
    this.searchable = true,
  });

  @override
  State<GenericBottomSheetList> createState() => _GenericBottomSheetListState<T>();
}

class _GenericBottomSheetListState<T> extends State<GenericBottomSheetList> {
  late bool multipleSelection;
  late List<dynamic> items;
  dynamic selectedValue;
  List<dynamic>? selectedValues;

  @override
  void initState() {
    super.initState();
    items = [...widget.items];
    selectedValue = widget.selectedValue;
    selectedValues = [...widget.selectedValues ?? []];
    multipleSelection = widget.selectedValues != null;
  }

  @override
  Widget build(BuildContext context) {
    bool showNoDataMsg = (widget.items.isEmpty && widget.noDataMsg != null);
    return BottomSheetWithActions(
      title: widget.title,
      isList: true,
      searchable: widget.searchable,
      onSearchChanged: (String? text) {
        setState(() {
          items = widget.items.where((element) => element.text.toLowerCase().contains(text ?? "")).toList();
        });
      },
      body: !showNoDataMsg
          ? Flexible(
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
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppColor.primary50Light50,
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 125,
                                child: CustomTextWidget(item.text, textStyle: AppStyle.listTitleTextStyle, maxLines: 2),
                              ),
                              const Spacer(),
                              if (widget.onTap != null && !multipleSelection)
                                Radio(
                                  value: item,
                                  groupValue: selectedValue,
                                  activeColor: AppColor.primary700Light,
                                  onChanged: (_) => selectItem(item),
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
            )
          : Column(
              children: [
                const SizedBox(height: 32),
                CustomTextWidget(
                  widget.noDataMsg ?? "",
                  fontWeight: AppFontWeight.bold,
                  fontSize: 16,
                  fontColor: AppColor.blackModern700Light,
                ),
              ],
            ),
      action: widget.onTap == null || showNoDataMsg
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

  void selectItem(T item) {
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
