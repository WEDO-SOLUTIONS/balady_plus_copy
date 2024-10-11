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
      child: Container(
        height: 90,
        width: 109,
        padding:
            EdgeInsets.symmetric(horizontal: 16), // Uniform horizontal padding
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColor.statusAccentContrastColor
              : AppColor.surfaceSecondaryColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColor.statusAccentColor
                : AppColor.surfaceSecondaryColor,
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? AppColor.statusAccentColor : AppColor.black,
            ),
          ),
        ),
      ),
    );
  }
}
