import 'package:flutter/material.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';

class TagMap extends StatelessWidget {
  const TagMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: EdgeInsets.all(8),
      height: 68,
      width: 107,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 12,
                  width: 12,
                  decoration: BoxDecoration(
                      color: AppColor.statusPositiveColor,
                      borderRadius: BorderRadius.circular(2)),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  "مسموح",
                  style: AppStyle.textMediumStyle
                      .copyWith(color: AppColor.textPrimaryColor),
                )
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Container(
                  height: 12,
                  width: 12,
                  decoration: BoxDecoration(
                      color: AppColor.statusNegativeColor,
                      borderRadius: BorderRadius.circular(2)),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  "غير مسموح",
                  style: AppStyle.textMediumStyle
                      .copyWith(color: AppColor.textPrimaryColor),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
