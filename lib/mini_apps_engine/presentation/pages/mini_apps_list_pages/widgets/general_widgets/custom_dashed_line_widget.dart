import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

//!
class CustomDashedLineWidget extends StatelessWidget {
  const CustomDashedLineWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.w(354),
      child: const DottedLine(
        direction: Axis.horizontal,
        lineThickness: 1.0,
        dashLength: 2,
        dashColor: Color(0XFFD9D9D9),
        dashGapLength: 2,
        dashGapColor: Colors.transparent,
      ),
    );
  }
}
