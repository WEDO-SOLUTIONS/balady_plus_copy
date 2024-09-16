import 'package:flutter/material.dart';

import '../../../core/utils/constants/app_colors.dart';
import '../../../core/utils/constants/app_style.dart';

class CheckBoxItem extends StatelessWidget {
  final bool currentValue;
  final Function(bool?) onSelect;
  final String title;
  const CheckBoxItem(
      {super.key,
      required this.currentValue,
      required this.onSelect,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.surfaceSecondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Row(
        children: [
          Checkbox(
            value: currentValue,
            onChanged: onSelect,
            checkColor: AppColor.white,
            activeColor: AppColor.statusAccentColor,
          ),
          const SizedBox(
            width: 8,
          ),
          Flexible(
            child: Text(
              title,
              style: AppStyle.textRegularRomanStyle
                  .copyWith(color: AppColor.textPrimaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
