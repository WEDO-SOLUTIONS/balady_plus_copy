import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

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
    return Container(
      height: 234,
      width: MediaQuery.sizeOf(context).width,
      margin: const EdgeInsets.only(left: 16, right: 16, top: 12),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        image: DecorationImage(
          image: AssetImage(ImagePath.prayerBg),
          fit: BoxFit.fitHeight,
        ),
      ),
      child: BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
        builder: (context, state) {
          return Column(
            children: [
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        state.nextPrayer != null
                            ? CustomTextWidget(
                                "صلاه ${state.nextPrayer!.prayer.label.tr()}",
                                fontColor: AppColor.primary900Light,
                                fontWeight: AppFontWeight.bold,
                                fontSize: 11,
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
                                    state.nextPrayer!.dateTime.hour > 12
                                        ? "PM"
                                        : "AM",
                                    fontColor: AppColor.white,
                                    fontWeight: AppFontWeight.semiBold,
                                    fontSize: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  CustomTextWidget(
                                    DateFormat("hh:mm")
                                        .format(state.nextPrayer!.dateTime),
                                    fontColor: AppColor.white,
                                    fontWeight: AppFontWeight.bold,
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
                        color: AppColor.white.withOpacity(0.1),
                      ),
                      child: const CustomSvgIconWidget(
                        IconPath.notificationIc2,
                        iconSize: 24,
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
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  color: AppColor.primary900Light.withOpacity(0.2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (state.nextPrayer != null)
                            CustomTextWidget(
                              "متبقي على وقت اذان ${state.nextPrayer!.prayer.label.tr()}",
                              fontColor: AppColor.white,
                              fontWeight: AppFontWeight.bold,
                              fontSize: 12,
                            ),
                          const SizedBox(height: 8),
                          state.nextPrayer != null
                              ? NextPrayerHome(
                                  prayer: state.nextPrayer!.prayer,
                                  time: state.nextPrayer!.dateTime,
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
                        padding: const EdgeInsetsDirectional.only(start: 20),
                        child: CustomElevatedButtonWidget(
                          btnColor: AppColor.secondary400Light,
                          textStyle: AppStyle.elevatedButtonStyle.copyWith(
                            color: AppColor.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                          btnHeight: 40,
                          btnPadding: const EdgeInsets.all(11),
                          text: "عرض اوقات الصلوات",
                          onPressed: () {
                            context.pushNamedRoute(
                              RouteName.prayerTimes,
                              arguments: context.read<PrayerTimesCubit>(),
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
    );
  }
}
