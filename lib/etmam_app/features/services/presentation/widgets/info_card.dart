import 'package:flutter/material.dart';

import '../../../../../app/core/utils/utils_exports.dart';
import '../../../../../app/features/_shared_feature_/shared_feature_exports.dart';

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.iconPath,
    required this.title,
    required this.value,
    this.leading,
    this.onTap,
    this.suffix,
    this.body,
  });

  final String iconPath;
  final String title;
  final String? value;
  final Widget? leading;
  final Widget? suffix;
  final Widget? body;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          color: AppColor.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomSvgIconWidget(
              iconPath,
              iconSize: 16,
              iconColor: AppColor.primary600Light,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextWidget(
                    title,
                    fontColor: AppColor.blackModern600Light,
                    fontSize: 15,
                    fontWeight: AppFontWeight.bold,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      SizedBox(
                        child: suffix,
                      ),
                      Expanded(
                        child: CustomTextWidget(
                          value ?? '',
                          fontColor: AppColor.blackModern500Light,
                          fontSize: 14,
                          fontWeight: AppFontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        child: leading,
                      ),
                    ],
                  ),
                  SizedBox(child: body),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
