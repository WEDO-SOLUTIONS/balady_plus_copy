import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';

class ViolationSelectOptionsWidget extends StatelessWidget {
  const ViolationSelectOptionsWidget({
    super.key,
    required this.color1,
    required this.color2,
    required this.logo,
    required this.subtitle,
    required this.title,
    required this.onPressed,
  });
  final String logo;
  final String title;
  final String subtitle;
  final Color color1;
  final Color color2;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 16,
        ),
        margin: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 255, 255, 0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
            child: Column(
          children: [
            Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    shape: BoxShape.rectangle,
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          color1,
                          color2,
                        ])),
                child: CustomSvgIconWidget(
                  logo,
                )),
            const SizedBox(
              height: 7,
            ),
            CustomTextWidget(
              title,
              textStyle: AppStyle.violationSelectOptionTitleStyle,
            ),
            CustomTextWidget(
              subtitle,
              maxLines: 10,
              textStyle: AppStyle.violationSelectOptionSubtitleStyle,
            ),
          ],
        )),
      ),
    );
  }
}
