import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';

class TermsItem extends StatelessWidget {
  final String name;
  final String desc;
  const TermsItem({super.key, required this.name, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Color(0xFF145E75),
              fontSize: 18,
              fontFamily: 'packages/balady_uikit/Frutiger',
              fontWeight: FontWeight.w700,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(14),
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 8),
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
        ],
      ),
    );
  }
}
