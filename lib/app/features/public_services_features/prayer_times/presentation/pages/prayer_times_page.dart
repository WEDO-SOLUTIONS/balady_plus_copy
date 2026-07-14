import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/services/local/notification_service.dart';
import 'package:balady_plus/app/core/utils/enums/prayers.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/app_analytics_events.dart';
import '../../../../../core/utils/constants/analytics_events.dart';
import '../../../../../core/utils/utils_exports.dart'
    show
        AppColor,
        AppStyle,
        BlocRequestStatus,
        CommonFunctions,
        ContextConversion,
        IconPath,
        ImagePath;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show CustomTextWidget, DrawIconBasedTypeWidget, ShimmerEffectWidget;
import '../../../../home_page/home_exports.dart' show CircleIcon;
import '../../prayer_times_exports.dart';
import '../widgets/prayer_unkown_location.dart';

class PrayerTimesPage extends StatefulWidget {
  const PrayerTimesPage({
    super.key,
  });

  @override
  State<PrayerTimesPage> createState() => _PrayerTimesPageState();
}

class _PrayerTimesPageState extends State<PrayerTimesPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      cubit.getPrayerTime();
      cubit.getPrayerTimeRange();
    });

    CommonFunctions.sendEventToAnalytics(AppEvents.prayingTimes);
    CommonFunctions.sendAnalyticsEvent(AnalyticsEvents.startServicePrayerTimes);
  }

  late PrayerTimesCubit cubit;
  @override
  Widget build(BuildContext context) {
    cubit = NavigationService.bottomNavKey.currentContext!.read<PrayerTimesCubit>();
    return BlocProvider.value(
      value: cubit,
      child: Scaffold(
        body: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  ImagePath.prayerTimesAppBar,
                  height: 340,
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
                          BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
                            builder: (context, state) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Visibility(
                                  visible: state.status.isSubmissionGetSuccess,
                                  child: GestureDetector(
                                    onTap: () => context
                                        .read<PrayerTimesCubit>()
                                        .prayerSettingsOnOff(),
                                    // onTap: () => NotificationService
                                    //     .showScheduledNotification(
                                    //     id: 1,
                                    //     title: "حان الان موعد أذان العصر",
                                    //     // body: "Bahaaasaaa",
                                    //     // payload: "Payload",
                                    //     scheduledDate: DateTime.now()
                                    //         .add(const Duration(
                                    //         seconds: 10))),
                                    child: CircleIcon(
                                      icon: IconPath.billIcon,
                                      iconColor: state.isNotificationDisable
                                          ? AppColor.blackModern50Light
                                          : AppColor.secondary500Light,
                                      iconSize: 30,
                                      backgroundColor:
                                          AppColor.primary100Light12,
                                      circleSize: 48,
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                      BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
                        builder: (context, state) {
                          String? cityName = state.gisResponse?.cityName ??
                              state.gisResponse?.adminMunicipalityName;
                          if (cityName != null) {
                            return CustomTextWidget(
                              "${"prayerTimesIn".tr()} $cityName",
                              textStyle: AppStyle.prayerTimeCityTextStyle,
                            );
                          }
                          return SizedBox();
                        },
                      ),
                      const SizedBox(height: 8),
                      CustomTextWidget(
                        CommonFunctions.replaceArabicNumberWithEnglish(
                            HijriCalendar.now().toFormat("dd MMMM، yyyy")),
                        textStyle: AppStyle.prayerTimeCityTextStyle.copyWith(
                          color: AppColor.blackModern50Light,
                        ),
                      ),
                      const SizedBox(height: 16),
                      BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
                        builder: (context, state) {
                          if (state.status ==
                              BlocRequestStatus.submissionGetLoading) {
                            return Container();
                          }
                          if (state.userLocationUnkown == true) {
                            return UnKownPrayerLocation(
                              onTap: () => cubit.getPrayerTime(),
                            );
                          }
                          if (state.nextPrayer != null) {
                            return NextPrayer(
                              prayer: state.nextPrayer!.prayer,
                              time: state.nextPrayer!.dateTime,
                            );
                          }
                          return Container();
                        },
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
                  builder: (context, state) {
                    if (state.status ==
                        BlocRequestStatus.submissionGetFailure) {
                      return ReloadWidget(onTab: () {
                        cubit.getPrayerTime();
                        cubit.getPrayerTimeRange();
                      });
                    }
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
                                  textStyle:
                                      AppStyle.prayerTimeCityTextStyle.copyWith(
                                    color: AppColor.blackModern700Light,
                                  ),
                                ),
                                const Spacer(),
                                Row(
                                  children: [
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
                                    const SizedBox(width: 20),
                                    GestureDetector(
                                      onTap: () => context
                                          .read<PrayerTimesCubit>()
                                          .onChangePrayerSettings(index),
                                      child: CustomSvgIconWidget(
                                        IconPath.notificationIc,
                                        iconColor:
                                            state.prayerTimeSettings[index] ==
                                                    "0"
                                                ? AppColor.blackModern500Light
                                                : AppColor.primary700Light,
                                      ),
                                    ),
                                  ],
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
      ),
    );
  }
}
