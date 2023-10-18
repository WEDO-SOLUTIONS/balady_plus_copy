import 'package:flutter/material.dart';

import '../../../../core/utils/utils_exports.dart' show AppColor, IconPath;
import '../../../home_page/home_exports.dart' show CircleIcon;

class FilterIcon extends StatelessWidget {
  final VoidCallback onTap;
  const FilterIcon({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: const CircleIcon(
          backgroundColor: AppColor.primary50Light,
          icon: IconPath.filter,
          circleSize: 48.0,
          iconSize: 30.0,
        ),
      ),
    );
  }
}
