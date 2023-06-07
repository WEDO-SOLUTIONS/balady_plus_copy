import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart' show AppColor, Prayers;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show ElevatedButtonWidget;
import '../../../home_exports.dart' show HomeSection, PrayerIcon;

class PrayerTimes extends StatelessWidget {
  const PrayerTimes({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeSection(
      title: "prayerTimes".tr(),
      child: Container(
        width: double.infinity,
        height: 160,
        margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.all(Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: AppColor.darkSlateBlue6,
              offset: Offset(0, 16),
              blurRadius: 32,
            )
          ],
        ),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PrayerIcon(
                  prayer: Prayers.fajr,
                  time: "05:00",
                ),
                PrayerIcon(
                  prayer: Prayers.dhuhr,
                  time: "05:00",
                ),
                PrayerIcon(
                  prayer: Prayers.asr,
                  time: "05:00",
                  isNextPrayer: true,
                ),
                PrayerIcon(
                  prayer: Prayers.maghrib,
                  time: "05:00",
                ),
                PrayerIcon(
                  prayer: Prayers.isha,
                  time: "05:00",
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButtonWidget.allPrayerTimes(
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
