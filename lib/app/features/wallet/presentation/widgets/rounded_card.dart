import 'package:flutter/material.dart';
import '../../../../core/utils/utils_exports.dart';
import '../../../_shared_feature_/shared_feature_exports.dart';

class RoundedCard extends StatelessWidget {
  const RoundedCard({
    super.key,
    required this.title,
    required this.iconPath,
    required this.isSelected,
  });

  final String title;
  final String iconPath;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          color: isSelected
              ? AppColor.primary800Light
              : AppColor.secondary50Light.withOpacity(0.7),
        ),
        child: Column(
          children: [
            CustomSvgIconWidget(
              iconPath,
              iconSize: 27,
              iconColor: isSelected
                  ? AppColor.blackModern50Light
                  : AppColor.secondary300Light,
            ),
            const SizedBox(height: 8),
            CustomTextWidget(
              title,
              fontColor: isSelected
                  ? AppColor.blackModern50Light
                  : AppColor.blackModern900Light,
              fontSize: 11,
              fontWeight: AppFontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }
}
