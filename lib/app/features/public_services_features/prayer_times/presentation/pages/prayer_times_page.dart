import 'package:balady_plus/app/core/utils/enums/prayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart'
    show
        AppColor,
        AppStyle,
        BlocRequestStatus,
        ContextConversion,
        IconPath,
        ImagePath;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show CustomTextWidget, DrawIconBasedTypeWidget, ShimmerEffectWidget;
import '../../../../home_page/home_exports.dart' show CircleIcon;
import '../../prayer_times_exports.dart';

class PrayerTimesPage extends StatelessWidget {
  final PrayerTimesCubit cubit;

  const PrayerTimesPage({
    super.key,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: Scaffold(
        body: Stack(
          children: [
            Image.asset(
              ImagePath.prayerTimesAppBar,
              height: 370,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
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
                  BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
                    builder: (context, state) {
                      return CustomTextWidget(
                        "${"prayerTimesIn".tr()} ${state.gisResponse?.municipalityName}",
                        textStyle: AppStyle.prayerTimeCityTextStyle,
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  CustomTextWidget(
                    HijriCalendar.now().toFormat("yyyy ،MMMM dd"),
                    textStyle: AppStyle.prayerTimeCityTextStyle.copyWith(
                      color: AppColor.blackModern50Light,
                    ),
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
                    builder: (context, state) {
                      if (state.nextPrayer == null) {
                        return Container(height: 120);
                      }
                      return NextPrayer(
                        prayer: state.nextPrayer!.prayer,
                        time: state.nextPrayer!.dateTime,
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: SingleChildScrollView(
                      child: BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
                        builder: (context, state) {
                          return Column(
                            children: List.generate(
                              Prayers.values.length,
                              (index) {
                                if (state.status ==
                                    BlocRequestStatus.submissionGetLoading) {
                                  return Container(
                                    height: 64,
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 16,
                                    ),
                                    child: const ShimmerEffectWidget(
                                      borderRadius: 8,
                                    ),
                                  );
                                }
                                return Container(
                                  height: 64,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 16,
                                  ),
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
                                        textStyle: AppStyle
                                            .prayerTimeCityTextStyle
                                            .copyWith(
                                          color: AppColor.blackModern700Light,
                                        ),
                                      ),
                                      const Spacer(),
                                      CustomTextWidget(
                                        state.prayerTimesResponse
                                                ?.fotmattedTimeFor(
                                              Prayers.values[index],
                                            ) ??
                                            "00:00",
                                        textStyle: AppStyle
                                            .prayerTimeCityTextStyle
                                            .copyWith(
                                          color: AppColor.blackModern700Light,
                                        ),
                                      ),
                                      // const SizedBox(width: 8),
                                      // const DrawIconBasedTypeWidget(
                                      //   icon: IconPath.billIcon,
                                      //   iconColor: AppColor.primary700Light,
                                      //   iconSize: 18,
                                      // ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
