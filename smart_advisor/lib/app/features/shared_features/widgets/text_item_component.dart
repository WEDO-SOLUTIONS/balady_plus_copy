import 'package:flutter/material.dart';

import '../../../core/utils/utils_exports.dart';

class TextItemComponent extends StatelessWidget {
  final String description;
  const TextItemComponent({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromARGB(134, 223, 231, 235),
      ),
      child: Text(
        description,
        style:
            AppStyle.textRegularRomanStyle.copyWith(color: Color(0xFF17263D)),
      ),
    );
  }
}
