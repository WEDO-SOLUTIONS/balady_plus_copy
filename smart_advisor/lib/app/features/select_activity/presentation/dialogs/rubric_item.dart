import 'package:smart_advisor/app/core/utils/utils_exports.dart';

import '/app/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

class RubricItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onPressed;

  const RubricItem({
    Key? key,
    required this.title,
    required this.isSelected,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPressed(),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: 16, vertical: 16), // Uniform horizontal padding
          margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColor.surfaceSecondaryColor
                : AppColor.surfaceSecondaryColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppColor.primary
                  : AppColor.surfaceSecondaryColor,
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.start,
            style: AppStyle.textRegularRomanStyle,
          ),
        ),
      ),
    );
  }
}
