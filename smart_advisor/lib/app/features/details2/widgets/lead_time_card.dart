import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import 'package:flutter/material.dart';

class LeadTimeCard extends StatefulWidget {
  final String title;
  final String details;
  const LeadTimeCard({super.key, required this.title, required this.details});

  @override
  State<LeadTimeCard> createState() => _LeadTimeCardState();
}

class _LeadTimeCardState extends State<LeadTimeCard> {
  final isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColor.surfaceSecondaryColor,
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.title,
              style: AppStyle.textRegularRomanStyle
                  .copyWith(color: AppColor.textPrimaryColor),
            ),
            subtitle: Text(
              widget.details,
              style: AppStyle.footNoteRomanStyle
                  .copyWith(color: AppColor.textSecondaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
