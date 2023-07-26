import 'package:balady_plus/app/core/utils/enums/prayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../core/utils/utils_exports.dart'
    show
        AppColor,
        AppStyle,
        BlocRequestStatus,
        CommonFunctions,
        ContextConversion,
        IconPath,
        ImagePath;
import '../../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show CustomTextWidget, DrawIconBasedTypeWidget, ShimmerEffectWidget;
import '../../../../home_page/home_exports.dart' show CircleIcon;
import '../../prayer_times_exports.dart';
import '../widgets/prayer_unkown_location.dart';

class PrayerTimesPage extends StatefulWidget {
  final PrayerTimesCubit cubit;

  const PrayerTimesPage({
    super.key,
    required this.cubit,
  });

  @override
  State<PrayerTimesPage> createState() => _PrayerTimesPageState();
}

class _PrayerTimesPageState extends State<PrayerTimesPage> {
  @override
  void initState() {
    super.initState();

    widget.cubit.getPrayerTime();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.cubit,
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
                          print("STAAAAATE $state");

                          return CustomTextWidget(
                            "${"prayerTimesIn".tr()} ${state.gisResponse?.adminMunicipalityName}",
                            textStyle: AppStyle.prayerTimeCityTextStyle,
                          );
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
                              BlocRequestStatus.submissionGetLoading)
                            return Container();
                          if (state.userLocationUnkown == true) {
                            return UnKownPrayerLocation(
                              onTap: () => widget.cubit.getPrayerTime(),
                            );
                          }
                          if (state.nextPrayer != null)
                            return NextPrayer(
                              prayer: state.nextPrayer!.prayer,
                              time: state.nextPrayer!.dateTime,
                            );
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
                                CustomTextWidget(
                                  state.prayerTimesResponse?.fotmattedTimeFor(
                                        Prayers.values[index],
                                      ) ??
                                      "00:00",
                                  textStyle:
                                      AppStyle.prayerTimeCityTextStyle.copyWith(
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
      ),
    );
  }
}
