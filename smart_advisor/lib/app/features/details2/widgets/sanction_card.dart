import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import 'package:flutter/material.dart';

class SanctionCard extends StatefulWidget {
  final String title;
  final String details;
  const SanctionCard({super.key, required this.title, required this.details});

  @override
  State<SanctionCard> createState() => _SanctionCardState();
}

class _SanctionCardState extends State<SanctionCard> {
  final isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColor.surfaceSecondaryColor),
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
