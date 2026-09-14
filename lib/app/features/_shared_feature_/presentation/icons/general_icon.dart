import 'package:flutter/material.dart';

import '../../../../core/utils/utils_exports.dart' show AppColor;
import '../../../home_page/home_exports.dart' show CircleIcon;

class GeneralIcon extends StatelessWidget {
  final VoidCallback onTap;
  final String icon;
  const GeneralIcon({super.key, required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: CircleIcon(backgroundColor: AppColor.primary50Light, icon: icon, circleSize: 48.0, iconSize: 30.0),
      ),
    );
  }
}
