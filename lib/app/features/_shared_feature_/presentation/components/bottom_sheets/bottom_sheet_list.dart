import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart' show AppStyle, AppColor;
import '../../../shared_feature_exports.dart'
    show CustomTextWidget, ElevatedButtonWidget;

class BottomSheetList extends StatefulWidget {
  final List<String> items;
  final String? selectedValue;
  final Function(String) onTap;

  const BottomSheetList({
    super.key,
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
    return Column(
      children: [
        for (var item in widget.items)
          InkWell(
            onTap: () => setState(() => selectedValue = item),
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width - 100,
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
        const SizedBox(height: 16),
        ElevatedButtonWidget.choose(
          onPressed: () {
            if (selectedValue != null) {
              widget.onTap(selectedValue!);
            }
          },
        )
      ],
    );
  }
}
