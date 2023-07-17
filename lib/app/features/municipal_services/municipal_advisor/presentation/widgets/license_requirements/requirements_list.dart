import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

class RequirementsList extends StatelessWidget {
  final int number;
  final String title;
  final List<String> requirements;

  const RequirementsList({
    super.key,
    required this.number,
    required this.title,
    required this.requirements,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$number. $title\n',
            style: const TextStyle(
              color: AppColor.darkTurquoise,
              fontSize: 12,
              fontFamily: 'Arabic UI Display',
              fontWeight: FontWeight.w600,
            ),
          ),
          for (final requirement in requirements)
            TextSpan(
              text: '- $requirement \n',
              style: const TextStyle(
                color: AppColor.jumbo,
                fontSize: 10,
                fontFamily: 'Arabic UI Display',
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}
