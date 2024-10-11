import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TableTag extends StatelessWidget {
  final String title;
  const TableTag({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 44,
        decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFCCD6E2)),
            borderRadius: BorderRadius.circular(6),
            color: Color(0xFFEAEFF5)),
        child: Center(
          child: Text(
            title,
            style: AppStyle.textRegularRomanStyle
                .copyWith(color: AppColor.textSecondaryColor),
          ),
        ));
  }
}
