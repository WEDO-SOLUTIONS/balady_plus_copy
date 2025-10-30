import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_shimmer_list_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, BlocRequestStatus, ContextConversion, Prayers, RouteName;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show ElevatedButtonWidget, MessageDialog, ShimmerEffectWidget;
import '../../../../public_services_features/prayer_times/prayer_times_exports.dart'
    show PrayerTimesCubit, PrayerTimesState;
import '../../../home_exports.dart' show HomeSection, PrayerIcon;

class PrayerTimesCard extends StatelessWidget {
  const PrayerTimesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
      builder: (context, state) {
        if (state.status == BlocRequestStatus.submissionGetLoading)
          return CustomShimmerWidget(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          );
        return HomeSection(
          title: "prayerTimes".tr(),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
                    builder: (context, state) {
                      return CustomTextWidget(
                        "${"prayerTimesIn".tr()} ${state.gisResponse?.adminMunicipalityName}",
                        fontWeight: AppFontWeight.bold,
                        fontSize: 14,
                        textAlign: TextAlign.start,
                        fontColor: AppColor.blackModern700Light,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                BlocConsumer<PrayerTimesCubit, PrayerTimesState>(
                  listenWhen: (previous, current) =>
                      previous.error != current.error,
                  listener: (context, state) {
                    MessageDialog.showErrorNotification(msg: state.error);
                  },
                  builder: (context, state) {
                    if (state.status ==
                        BlocRequestStatus.submissionGetLoading) {
                      return Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(
                                5,
                                (index) => const ShimmerEffectWidget(
                                  height: 60,
                                  width: 60,
                                  borderRadius: 50,
                                ),
                              )),
                        ],
                      );
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        Prayers.values.length,
                        (index) => Expanded(
                          child: PrayerIcon(
                            prayer: Prayers.values[index],
                            time: state.prayerTimesResponse?.fotmattedTimeFor(
                                  Prayers.values[index],
                                ) ??
                                "00:00",
                            isNextPrayer: Prayers.values[index] ==
                                state.nextPrayer?.prayer,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButtonWidget.allPrayerTimes(
                  onPressed: () {
                    context.pushNamedRoute(
                      RouteName.prayerTimes,
                      arguments: context.read<PrayerTimesCubit>(),
                    );
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
