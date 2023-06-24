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
            BlocConsumer<PrayerTimesCubit, PrayerTimesState>(
              listenWhen: (previous, current) =>
                  previous.error != current.error,
              listener: (context, state) {
                MessageDialog.showErrorNotification(msg: state.error);
              },
              builder: (context, state) {
                if (state.status == BlocRequestStatus.submissionGetLoading) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        5,
                        (index) => const ShimmerEffectWidget(
                          height: 60,
                          width: 60,
                          borderRadius: 50,
                        ),
                      ));
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
                        isNextPrayer:
                            Prayers.values[index] == state.nextPrayer?.prayer,
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
  }
}
