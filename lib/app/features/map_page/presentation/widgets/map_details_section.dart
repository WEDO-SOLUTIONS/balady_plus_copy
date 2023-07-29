import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MapDetailsSection extends StatelessWidget {
  final String title;
  final String icon;

  const MapDetailsSection({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      width: double.infinity,
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SvgPicture.asset(icon),
        CustomHorizontalSpace(width: 8),
        CustomTextWidget(
          title,
          fontSize: 15,
          fontWeight: AppFontWeight.bold,
          fontColor: AppColor.blackModern600Light,
        ),
      ]),
    );
  }
}
