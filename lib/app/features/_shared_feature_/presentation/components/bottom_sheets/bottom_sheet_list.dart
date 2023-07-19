import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart' show AppStyle, AppColor;
import '../../../shared_feature_exports.dart'
    show BottomSheetWithActions, CustomTextWidget, ElevatedButtonWidget;

class BottomSheetList extends StatefulWidget {
  final String title;
  final List<String> items;
  final String? selectedValue;
  final Function(String) onTap;

  const BottomSheetList({
    super.key,
    required this.title,
    required this.items,
    this.selectedValue,
    required this.onTap,
  });

  @override
  State<BottomSheetList> createState() => _BottomSheetListState();
}

class _BottomSheetListState extends State<BottomSheetList> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetWithActions(
      title: widget.title,
      body: Column(
        children: [
          for (var item in widget.items)
            InkWell(
              onTap: () => setState(() => selectedValue = item),
              child: Container(
                height: 56,
                padding: const EdgeInsetsDirectional.only(start: 12),
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColor.primary50Light50,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 125,
                      child: CustomTextWidget(
                        item,
                        textStyle: AppStyle.listTitleTextStyle,
                        maxLines: 2,
                      ),
                    ),
                    const Spacer(),
                    Radio(
                      value: item,
                      groupValue: selectedValue,
                      activeColor: AppColor.primary700Light,
                      onChanged: (_) => setState(() => selectedValue = item),
                    )
                  ],
                ),
              ),
            ),
          const SizedBox(height: 50),
        ],
      ),
      action: ElevatedButtonWidget.choose(
        onPressed: () {
          if (selectedValue != null) {
            widget.onTap(selectedValue!);
          }
        },
      ),
    );
  }
}
