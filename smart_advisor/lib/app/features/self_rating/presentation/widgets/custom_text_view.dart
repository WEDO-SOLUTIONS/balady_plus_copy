import '/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';

class CustomTextDisplay extends StatelessWidget {
  final String unit;
  final String value;
  final String title;

  // Constructor accepting unit and value as parameters
  const CustomTextDisplay(
      {required this.unit, required this.value, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppStyle.captionRomanStyle
              .copyWith(color: const Color(0xff1A1A1A)),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            //   border: Border.all(color: Colors.teal, width: 1.5),
            color: const Color(0xFFF7F9FC), // Light background color
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: AppStyle.footNoteRomanStyle
                    .copyWith(color: const Color(0xffB2B2B2), fontSize: 15),
              ),
              Text(unit,
                  style: AppStyle.footNoteRomanStyle
                      .copyWith(color: const Color(0xffB2B2B2), fontSize: 15)),
            ],
          ),
        ),
      ],
    );
  }
}
