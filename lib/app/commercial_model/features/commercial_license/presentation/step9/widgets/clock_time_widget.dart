import 'package:flutter/material.dart';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import '../../../../../../features/_shared_feature_/shared_feature_exports.dart';

class ClockTimeWidget extends StatelessWidget {
  const ClockTimeWidget({
    super.key,
    required this.title,
    required this.currentTime,
    required this.onSelectedTime,
  });

  final String title;
  final String currentTime;
  final Function(TimeOfDay?) onSelectedTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextWidget(
          title,
          fontSize: 12,
          fontWeight: AppFontWeight.bold,
          fontColor: AppColor.blackModern700Light,
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () async {
            final time = await CommonFunctions.pickTime(context);
            onSelectedTime(time);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(6)),
              border: Border.all(color: AppColor.blackModern300Light),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomTextWidget(
                  currentTime,
                  fontWeight: AppFontWeight.bold,
                  fontSize: 14,
                  fontColor: AppColor.blackModern700Light,
                ),
                const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
              ],
            ),
          ),
        )
      ],
    );
  }
}
