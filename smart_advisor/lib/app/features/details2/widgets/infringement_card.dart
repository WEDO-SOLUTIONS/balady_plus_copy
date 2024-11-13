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
                        widget.isCritical == true ? "جسيمة" : "غير جسيمة",
                        style: AppStyle.textRegularRomanStyle.copyWith(
                            color: widget.isCritical == true
                                ? const Color(0xffE0373D)
                                : AppColor.textPrimaryColor))),
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
