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
              color: Color(0xFF036362),
              fontSize: 12,
              fontFamily: 'Arabic UI Display',
              fontWeight: FontWeight.w600,
              height: 24,
            ),
          ),
          for (final requirement in requirements)
            TextSpan(
              text: requirement,
              style: const TextStyle(
                color: Color(0xFF71717A),
                fontSize: 10,
                fontFamily: 'Arabic UI Display',
                fontWeight: FontWeight.w600,
                height: 24,
              ),
            ),
        ],
      ),
    );
  }
}
