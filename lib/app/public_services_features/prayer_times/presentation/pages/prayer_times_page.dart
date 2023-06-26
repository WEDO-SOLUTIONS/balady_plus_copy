import 'package:balady_plus/app/core/utils/enums/prayers.dart';
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, ContextConversion, IconPath, ImagePath;
import '../../../../features/_shared_feature_/shared_feature_exports.dart'
    show CustomTextWidget, DrawIconBasedTypeWidget;
import '../../../../features/home_page/home_exports.dart' show CircleIcon;
import '../../prayer_times_exports.dart';

class PrayerTimesPage extends StatelessWidget {
  final bool showBillIcon;

  const PrayerTimesPage({
    super.key,
    this.showBillIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(ImagePath.prayerTimesAppBar),
          SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        onPressed: () {
                          context.popRoute();
                        },
                        icon: const Icon(
                          Icons.close,
                          color: AppColor.blackModern50Light,
                        ),
                      ),
                    ),
                    CustomTextWidget(
                      "prayerTimes".tr(),
                      textStyle: AppStyle.appBarTitleTextStyle.copyWith(
                        color: AppColor.blackModern50Light,
                      ),
                    ),
                    const Visibility(
                      visible: false,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircleIcon(
                          icon: IconPath.billIcon,
                          iconColor: AppColor.blackModern50Light,
                          iconSize: 30,
                          backgroundColor: AppColor.primary100Light12,
                          circleSize: 48,
                        ),
                      ),
                    )
                  ],
                ),
                CustomTextWidget(
                  'مواقيت الصلاة في الرياض',
                  textStyle: AppStyle.prayerTimeCityTextStyle,
                ),
                const SizedBox(height: 8),
                CustomTextWidget(
                  HijriCalendar.now().toFormat("yyyy ،MMMM dd"),
                  textStyle: AppStyle.prayerTimeCityTextStyle.copyWith(
                    color: AppColor.blackModern50Light,
                  ),
                ),
                const SizedBox(height: 16),
                NextPrayer(
                  prayer: Prayers.asr,
                  time: DateTime.now().add(
                    const Duration(hours: 0, minutes: 0, seconds: 5),
                  ),
                ),
                const SizedBox(height: 8),
                ...List.generate(
                  Prayers.values.length,
                  (index) => Container(
                    height: 64,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      children: [
                        DrawIconBasedTypeWidget(
                          icon: Prayers.values[index].icon,
                          iconColor: AppColor.primary700Light,
                          iconSize: 32,
                        ),
                        const SizedBox(width: 8),
                        CustomTextWidget(
                          Prayers.values[index].name.tr(),
                          textStyle: AppStyle.prayerTimeCityTextStyle.copyWith(
                            color: AppColor.blackModern700Light,
                          ),
                        ),
                        const Spacer(),
                        CustomTextWidget(
                          "03:25 ${'am'.tr()}",
                          textStyle: AppStyle.prayerTimeCityTextStyle.copyWith(
                            color: AppColor.blackModern700Light,
                          ),
                        ),
                        if (showBillIcon) ...[
                          const SizedBox(width: 8),
                          const DrawIconBasedTypeWidget(
                            icon: IconPath.billIcon,
                            iconColor: AppColor.primary700Light,
                            iconSize: 18,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
