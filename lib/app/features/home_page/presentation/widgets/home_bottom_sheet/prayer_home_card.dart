import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_shimmer_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../../public_services_features/prayer_times/prayer_times_exports.dart';
import '../../../home_exports.dart';

class PrayerHomeCard extends StatelessWidget {
  const PrayerHomeCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
      builder: (context, state) {
        return HomeSection(
            title: "prayerTimes".tr(),
            child: state.nextPrayer != null &&
                    state.status != BlocRequestStatus.submissionGetLoading
                ? Container(
                    height: 234,
                    margin: const EdgeInsets.only(left: 16, right: 16, top: 12),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      image: DecorationImage(
                        image: AssetImage(
                            state.nextPrayer!.prayer == Prayers.fajr
                                ? ImagePath.fajrBg
                                : state.nextPrayer!.prayer == Prayers.dhuhr
                                    ? ImagePath.zuhrBg
                                    : state.nextPrayer!.prayer == Prayers.asr
                                        ? ImagePath.asrBg
                                        : state.nextPrayer!.prayer ==
                                                Prayers.maghrib
                                            ? ImagePath.maghrbBg
                                            : ImagePath.ishabBg),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    child: BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
                      builder: (context, state) {
                        return Column(
                          children: [
                            const SizedBox(height: 18),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      state.nextPrayer != null
                                          ? CustomTextWidget(
                                              "صلاة ${state.nextPrayer!.prayer.label.tr()}",
                                              fontColor: state
                                                          .nextPrayer!.prayer ==
                                                      Prayers.fajr
                                                  ? AppColor.primary900Light
                                                  : state.nextPrayer!.prayer ==
                                                          Prayers.dhuhr
                                                      ? AppColor
                                                          .secondary900Light
                                                      : state.nextPrayer!
                                                                  .prayer ==
                                                              Prayers.asr
                                                          ? AppColor
                                                              .secondary900Light
                                                          : state.nextPrayer!
                                                                      .prayer ==
                                                                  Prayers
                                                                      .maghrib
                                                              ? AppColor.brown2
                                                              : AppColor.white
                                                                  .withOpacity(
                                                                      0.4),
                                              fontWeight: AppFontWeight.bold,
                                              fontSize: 13,
                                            )
                                          : const ShimmerEffectWidget(
                                              width: 80,
                                              height: 20,
                                              borderRadius: 4,
                                            ),
                                      const SizedBox(height: 8),
                                      state.nextPrayer != null
                                          ? Row(
                                              children: [
                                                CustomTextWidget(
                                                  state.nextPrayer!.dateTime
                                                              .hour >
                                                          12
                                                      ? "PM"
                                                      : "AM",
                                                  fontColor: state.nextPrayer!
                                                              .prayer ==
                                                          Prayers.fajr
                                                      ? AppColor.white
                                                      : state.nextPrayer!
                                                                  .prayer ==
                                                              Prayers.dhuhr
                                                          ? AppColor
                                                              .primary900Light
                                                          : state.nextPrayer!
                                                                      .prayer ==
                                                                  Prayers.asr
                                                              ? AppColor
                                                                  .primary900Light
                                                              : state.nextPrayer!
                                                                          .prayer ==
                                                                      Prayers
                                                                          .maghrib
                                                                  ? AppColor
                                                                      .brown2
                                                                  : AppColor
                                                                      .white,
                                                  fontWeight:
                                                      AppFontWeight.semiBold,
                                                  fontSize: 14,
                                                ),
                                                const SizedBox(width: 4),
                                                CustomTextWidget(
                                                  DateFormat("hh:mm").format(
                                                      state.nextPrayer!
                                                          .dateTime),
                                                  fontColor: state.nextPrayer!
                                                              .prayer ==
                                                          Prayers.fajr
                                                      ? AppColor.white
                                                      : state.nextPrayer!
                                                                  .prayer ==
                                                              Prayers.dhuhr
                                                          ? AppColor
                                                              .primary900Light
                                                          : state.nextPrayer!
                                                                      .prayer ==
                                                                  Prayers.asr
                                                              ? AppColor
                                                                  .primary900Light
                                                              : state.nextPrayer!
                                                                          .prayer ==
                                                                      Prayers
                                                                          .maghrib
                                                                  ? AppColor
                                                                      .brown2
                                                                  : AppColor
                                                                      .white,
                                                  fontWeight:
                                                      AppFontWeight.bold,
                                                  fontSize: 28,
                                                ),
                                              ],
                                            )
                                          : const ShimmerEffectWidget(
                                              width: 80,
                                              height: 40,
                                              borderRadius: 4,
                                            ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: state.nextPrayer!.prayer ==
                                              Prayers.fajr
                                          ? AppColor.white.withOpacity(0.1)
                                          : state.nextPrayer!.prayer ==
                                                  Prayers.dhuhr
                                              ? AppColor.white9
                                                  .withOpacity(0.65)
                                              : state.nextPrayer!.prayer ==
                                                      Prayers.asr
                                                  ? AppColor.white9
                                                      .withOpacity(0.65)
                                                  : state.nextPrayer!.prayer ==
                                                          Prayers.maghrib
                                                      ? AppColor.brownLight
                                                      : AppColor.white
                                                          .withOpacity(0.1),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        Provider.of<PrayerTimesCubit>(context,
                                                listen: false)
                                            .prayerSettingsOnOff();
                                      },
                                      child: BlocBuilder<PrayerTimesCubit,
                                              PrayerTimesState>(
                                          builder: (context, state) {
                                        bool isNotificationDisabled =
                                            state.isNotificationDisable;
                                        return CustomSvgIconWidget(
                                          isNotificationDisabled
                                              ? IconPath.notificationIc2
                                              : IconPath.notificationFilled,
                                          iconColor: state.nextPrayer!.prayer ==
                                                  Prayers.fajr
                                              ? AppColor.white
                                              : state.nextPrayer!.prayer ==
                                                      Prayers.dhuhr
                                                  ? AppColor.primary900Light
                                                  : state.nextPrayer!.prayer ==
                                                          Prayers.asr
                                                      ? AppColor.primary900Light
                                                      : state.nextPrayer!
                                                                  .prayer ==
                                                              Prayers.maghrib
                                                          ? AppColor
                                                              .primary900Light
                                                          : AppColor.white,
                                          iconSize: 24,
                                        );
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Container(
                              margin: const EdgeInsets.all(14),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                color: state.isAM
                                    ? AppColor.white.withOpacity(0.2)
                                    : AppColor.primary900Light.withOpacity(0.2),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (state.nextPrayer != null)
                                          CustomTextWidget(
                                            "remain_to_azan".tr().replaceAll(
                                                "{}",
                                                state.nextPrayer!.prayer.label
                                                    .tr()),
                                            fontColor: AppColor.white,
                                            fontWeight: AppFontWeight.bold,
                                            maxLines: 2,
                                            height: 1.3,
                                            fontSize: 13,
                                          ),
                                        const SizedBox(height: 8),
                                        state.nextPrayer != null
                                            ? NextPrayerHome(
                                                prayer:
                                                    state.nextPrayer!.prayer,
                                                time:
                                                    state.nextPrayer!.dateTime,
                                              )
                                            : const ShimmerEffectWidget(
                                                width: 160,
                                                height: 40,
                                                borderRadius: 4,
                                              ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                          start: 20),
                                      child: CustomElevatedButtonWidget(
                                        btnColor: state.isAM
                                            ? AppColor.primary900Light
                                            : AppColor.secondary900Light,
                                        textStyle: AppStyle.elevatedButtonStyle
                                            .copyWith(
                                          color: AppColor.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                        ),
                                        btnHeight: 40,
                                        btnPadding: const EdgeInsets.all(11),
                                        text: 'prayer_timings'.tr(),
                                        onPressed: () {
                                          context.pushNamedRoute(
                                            RouteName.prayerTimes,
                                            arguments: context
                                                .read<PrayerTimesCubit>(),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: CustomShimmerWidget(
                      childHeight: 234,
                      childWidth: MediaQuery.sizeOf(context).width,
                    ),
                  ));
      },
    );
  }
}
