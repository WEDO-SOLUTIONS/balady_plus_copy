import 'package:flutter/material.dart';

import '../../../../../../../core/utils/constants/app_colors.dart';

class Item extends StatelessWidget {
  final String desc;
  const Item({
    super.key,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColor.primary100Light,
        ),
        child: Text(
          desc,
          style: const TextStyle(
            color: Color(0xFF52525B),
            fontSize: 14,
            fontFamily: 'packages/balady_uikit/Frutiger',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
