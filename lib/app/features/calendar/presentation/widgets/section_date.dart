import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';

class SectionDate extends StatelessWidget {
  final String month;
  final String year;
  const SectionDate({super.key, required this.month, required this.year});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomTextWidget(
            month,
            fontSize: 20,
            fontWeight: AppFontWeight.bold,
            fontColor: Color(0xFF292929),
          ),
          CustomTextWidget(
            year,
            fontSize: 20,
            fontWeight: AppFontWeight.bold,
            fontColor: Color(0xFF292929),
          ),
        ],
      ),
    );
  }
}
