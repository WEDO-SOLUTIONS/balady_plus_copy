import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_shimmer_list_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/shimmer_effect_widget.dart';
import 'package:balady_plus/app/features/home_page/presentation/widgets/home_bottom_sheet/prayer_next_home.dart';
import 'package:balady_plus/app/features/public_services_features/prayer_times/prayer_times_exports.dart';
import 'package:balady_uikit/core/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:provider/provider.dart';

class PrayerHomeCard extends StatelessWidget {
  final VoidCallback? onShowTimesTap;
  final VoidCallback? onNotificationTap;

  const PrayerHomeCard({
    super.key,
    this.onShowTimesTap,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 16,
                end: 16,
              ),
              child: Text(
                "prayerTimes".tr(),
                style: Theme.of(context).extension<ThemeTextStyles>()?.heading2.copyWith(
                      color: const Color(0xFF1E2A36),
                    ),
              ),
            ),
            state.nextPrayer != null && state.status != BlocRequestStatus.submissionGetLoading
                ? Container(
                    height: 200,
                    margin: const EdgeInsets.only(left: 16, right: 16, top: 12),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      image: DecorationImage(
                        image: AssetImage(
                          state.nextPrayer!.prayer == Prayers.fajr
                              ? Assets.images.sunrisePray.keyName
                              : state.nextPrayer!.prayer == Prayers.dhuhr
                                  ? Assets.images.sunrisePray.keyName // day
                                  : state.nextPrayer!.prayer == Prayers.asr
                                      ? Assets.images.sunrisePray.keyName // day
                                      : state.nextPrayer!.prayer == Prayers.maghrib
                                          ? Assets.images.sunrisePray.keyName // sunset
                                          : Assets.images.sunrisePray.keyName, // night
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
                      builder: (context, state) {
                        return Column(
                          children: [
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (state.nextPrayer != null)
                                            Text(
                                              "remain_to_azan"
                                                  .tr()
                                                  .replaceAll("{}", state.nextPrayer!.prayer.label.tr()),
                                              style: Theme.of(context).extension<ThemeTextStyles>()!.caption.copyWith(
                                                    color: Colors.white,
                                                  ),
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
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0x40FFFFFF),
                                        ),
                                        child: GestureDetector(
                                          onTap: () {
                                            onNotificationTap?.call();
                                            Provider.of<PrayerTimesCubit>(context, listen: false).prayerSettingsOnOff();
                                          },
                                          child: BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
                                            builder: (context, state) {
                                              bool isNotificationDisabled = state.isNotificationDisable;
                                              return SvgPicture.asset(
                                                Assets.icons.svg.icNotification.keyName,
                                                colorFilter: ColorFilter.mode(
                                                  isNotificationDisabled ? const Color(0x99FFFFFF) : Colors.white,
                                                  BlendMode.srcIn,
                                                ),
                                                width: 24,
                                                height: 24,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  state.nextPrayer != null
                                      ? Text(
                                          "${"pray".tr()} ${state.nextPrayer!.prayer.label.tr()}",
                                          style: Theme.of(context).extension<ThemeTextStyles>()!.caption.copyWith(
                                                color: Colors.white,
                                              ),
                                        )
                                      : const ShimmerEffectWidget(
                                          width: 80,
                                          height: 20,
                                          borderRadius: 4,
                                        ),
                                  state.nextPrayer != null
                                      ? Row(
                                          children: [
                                            Text(
                                              state.nextPrayer!.dateTime.hour > 12 ? "PM" : "AM",
                                              style: Theme.of(context).extension<ThemeTextStyles>()!.callout.copyWith(
                                                    color: Colors.white,
                                                  ),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              DateFormat("hh:mm").format(state.nextPrayer!.dateTime),
                                              style: Theme.of(context).extension<ThemeTextStyles>()!.callout.copyWith(
                                                    color: Colors.white,
                                                  ),
                                            ),
                                          ],
                                        )
                                      : const ShimmerEffectWidget(
                                          width: 80,
                                          height: 40,
                                          borderRadius: 4,
                                        ),
                                  const SizedBox(height: 16),
                                  Material(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    child: InkWell(
                                      onTap: () {
                                        onShowTimesTap?.call();
                                        NavigationService.navigatorKey.currentState!.pushNamed(
                                          RouteName.prayerTimes,
                                          arguments: context.read<PrayerTimesCubit>(),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        child: Text(
                                          'prayer_timings'.tr(),
                                          style: Theme.of(context).extension<ThemeTextStyles>()!.callout.copyWith(
                                                color: Colors.black,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: CustomShimmerWidget(
                      childHeight: 234,
                      childWidth: MediaQuery.sizeOf(context).width,
                    ),
                  )
          ],
        );
      },
    );
  }
}
