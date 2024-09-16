import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import 'package:flutter/material.dart';

class ItemNumberAndNotificationCard extends StatefulWidget {
  final String number;
  final String notification;
  const ItemNumberAndNotificationCard(
      {super.key, required this.number, required this.notification});

  @override
  State<ItemNumberAndNotificationCard> createState() => _ItemCardCardState();
}

class _ItemCardCardState extends State<ItemNumberAndNotificationCard> {
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
                "رقم البند",
                style: AppStyle.textRegularRomanStyle
                    .copyWith(color: AppColor.textPrimaryColor),
              ),
              subtitle: Text(
                widget.number,
                style: AppStyle.footNoteRomanStyle
                    .copyWith(color: AppColor.textSecondaryColor),
              ),
            ),
          ),
          /* Expanded(
            child: ListTile(
              title: Text(
                "التنبيه",
                style: AppStyle.textRegularRomanStyle
                    .copyWith(color: AppColor.textPrimaryColor),
              ),
              subtitle: Text(
                widget.notification,
                style: AppStyle.footNoteRomanStyle
                    .copyWith(color: AppColor.textSecondaryColor),
              ),
            ),
          ),*/
        ],
      ),
    );
  }
}
