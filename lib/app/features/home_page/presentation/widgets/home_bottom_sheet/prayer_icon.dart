import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart' show AppStyle, Prayers;
import '../../../../_shared_feature_/shared_feature_exports.dart' show DrawIconBasedTypeWidget;

class PrayerIcon extends StatelessWidget {
  final Prayers prayer;
  final String time;
  final bool isNextPrayer;

  const PrayerIcon({
    super.key,
    required this.prayer,
    required this.time,
    this.isNextPrayer = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isNextPrayer
            ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColor.greyishTeal27,
                  Colors.transparent,
                  Colors.transparent,
                ],
              )
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DrawIconBasedTypeWidget(
            icon: prayer.icon,
            iconColor: AppColor.primary500Light,
            iconSize: 18,
          ),
          CustomTextWidget(
            prayer.label.tr(),
            textStyle: AppStyle.mainTextStyle.copyWith(
              fontSize: 12,
            ),
          ),
          CustomTextWidget(
            time,
            textStyle: AppStyle.prayerTimeStyle,
          ),
        ],
      ),
    );
  }
}
