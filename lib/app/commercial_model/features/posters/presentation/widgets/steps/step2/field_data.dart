import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';

class FieldDataCustomData extends StatelessWidget {
  final String title;
  final List<Widget>? sub;
  final BorderRadius? radius;

  const FieldDataCustomData(
      {super.key, this.sub, required this.title, this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Color(0x80E6EFEF),
          borderRadius: radius ?? BorderRadius.circular(8)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomTextWidget(
                title,
                fontColor: AppColor.primary700Light,
                fontSize: 12,
                fontWeight: AppFontWeight.semiBold,
              ),
            ],
          ),
          if (sub != null) ...sub!
        ],
      ),
    );
  }
}
