import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import 'package:flutter/material.dart';

class CanBeObjectedToCard extends StatefulWidget {
  final String canObjected;
  final String leadTime;
  const CanBeObjectedToCard(
      {super.key, required this.canObjected, required this.leadTime});

  @override
  State<CanBeObjectedToCard> createState() => _CanBeObjectedToCardState();
}

class _CanBeObjectedToCardState extends State<CanBeObjectedToCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColor.surfaceSecondaryColor,
      ),
      child: Row(
        children: [
          Expanded(
            child: ListTile(
              title: Text(
                "قابلة للاعتراض",
                style: AppStyle.textRegularRomanStyle
                    .copyWith(color: AppColor.textPrimaryColor),
              ),
              subtitle: Text(
                widget.canObjected,
                style: AppStyle.footNoteRomanStyle
                    .copyWith(color: AppColor.textSecondaryColor),
              ),
            ),
          ),
          Expanded(
            child: ListTile(
              title: Text(
                "مهلة الاعتراض",
                style: AppStyle.textRegularRomanStyle
                    .copyWith(color: AppColor.textPrimaryColor),
              ),
              subtitle: Text(
                widget.leadTime,
                style: AppStyle.footNoteRomanStyle
                    .copyWith(color: AppColor.textSecondaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
