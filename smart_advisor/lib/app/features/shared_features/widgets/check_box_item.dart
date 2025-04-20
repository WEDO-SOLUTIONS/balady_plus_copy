import 'package:flutter/material.dart';

import '../../../core/utils/constants/app_colors.dart';
import '../../../core/utils/constants/app_style.dart';

class CheckBoxItem extends StatelessWidget {
  final bool currentValue;
  final Function(bool?) onSelect;
  final String title;
  final Color? color;
  final bool? isDeleting;
  const CheckBoxItem(
      {super.key,
      required this.currentValue,
      required this.onSelect,
      required this.title,
      this.isDeleting = false,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color ?? AppColor.surfaceSecondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Row(
        children: [
          Checkbox(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            side: BorderSide(color: AppColor.gray.withOpacity(0.50), width: 1),
            value: currentValue,
            onChanged: onSelect,
            checkColor: AppColor.white,
            activeColor:
                isDeleting! ? AppColor.statusAttentionColor : AppColor.primary,
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
