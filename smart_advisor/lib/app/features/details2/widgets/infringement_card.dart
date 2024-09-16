import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import 'package:flutter/material.dart';

class InfringementCard extends StatefulWidget {
  final String title;
  final String details;
  final bool isCritical;
  const InfringementCard(
      {super.key,
      required this.title,
      required this.details,
      required this.isCritical});

  @override
  State<InfringementCard> createState() => _InfringementCardState();
}

class _InfringementCardState extends State<InfringementCard> {
  final isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColor.surfaceSecondaryColor,
      ),
      child: Column(
        children: [
          ListTile(
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: AppStyle.heading2BoldStyle
                        .copyWith(color: AppColor.textPrimaryColor),
                  ),
                ),
                Container(
                  height: 24,
                  width: 66,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: const Color(0XFFF2DEE1)),
                  child: Center(
                    child: Text(
                      widget.isCritical ? "جسيمة" : "غير جسيمة",
                      style: AppStyle.footNoteRomanStyle
                          .copyWith(color: AppColor.statusNegativeColor),
                    ),
                  ),
                ),
              ],
            ),
            subtitle: Text(
              widget.details,
              style: AppStyle.textRegularRomanStyle
                  .copyWith(color: AppColor.textSecondaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
