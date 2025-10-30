import 'package:flutter/material.dart';
import '../../../../core/utils/utils_exports.dart';
import '../../../_shared_feature_/shared_feature_exports.dart';

class RoundedCard extends StatelessWidget {
  const RoundedCard(
      {super.key,
      required this.title,
      required this.iconPath,
      required this.isSelected,
      required this.onTap});

  final String title;
  final String iconPath;
  final bool isSelected;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 100,
          margin: EdgeInsetsDirectional.only(end: 12),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            color: isSelected
                ? AppColor.primary900Light
                : AppColor.blueSkyLight800.withOpacity(0.1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomSvgIconWidget(
                iconPath,
                iconSize: 27,
                iconColor: isSelected
                    ? AppColor.blackModern50Light
                    : AppColor.primary900Light,
              ),
              const SizedBox(height: 8),
              CustomTextWidget(
                title, //المتاجر المتنقلة
                textAlign: TextAlign.center,
                fontColor: isSelected
                    ? AppColor.blackModern50Light
                    : AppColor.blackModern900Light,
                fontSize: 11,
                height: 1.3,
                maxLines: 2,
                fontWeight: AppFontWeight.bold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
