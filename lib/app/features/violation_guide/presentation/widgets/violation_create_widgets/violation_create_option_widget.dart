import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';

class ViolationCreateOptionWidget extends StatelessWidget {
  const ViolationCreateOptionWidget({
    super.key,
    required this.color,
    required this.logoPath,
    required this.optionTitle,
    required this.onPressed,
  });
  final String logoPath;
  final String optionTitle;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 315,
        height: 141,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            CustomSvgIconWidget(logoPath),
            const SizedBox(
              height: 5,
            ),
            CustomTextWidget(
              optionTitle,
            ),
          ]),
        ),
      ),
    );
  }
}
