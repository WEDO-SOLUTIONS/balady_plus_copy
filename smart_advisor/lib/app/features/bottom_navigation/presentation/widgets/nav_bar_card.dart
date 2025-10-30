import '/app/core/utils/constants/app_style.dart';
import '/app/features/_shared_feature_/presentation/widgets/custom_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart' show AutoSizeText;

import '../../../../core/utils/utils_exports.dart'
    show AppColor, WidgetConversion, trans;

class BottomNavBarCardWidget extends StatelessWidget {
  final String icon;
  final String iconActive;
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const BottomNavBarCardWidget({
    super.key,
    required this.icon,
    required this.iconActive,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelected,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon widget
          CustomIconWidget(isSelected ? iconActive : icon, iconSize: 24),
          const SizedBox(height: 10),
          // Label widget
          AutoSizeText(
            trans(label),
            textAlign: TextAlign.center,
            maxFontSize: 10,
            minFontSize: 8,
            maxLines: 1,
            style: AppStyle.mainTextStyle.copyWith(
                color: isSelected ? AppColor.black : AppColor.gray,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
