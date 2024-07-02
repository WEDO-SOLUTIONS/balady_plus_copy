import 'dart:async';
import 'dart:ui';

import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_shimmer_list_widget.dart';
import 'package:balady_plus/app/features/public_services_features/prayer_times/presentation/cubit/prayer_times_cubit.dart';
import 'package:balady_plus/etmam_app/core/dependency_injection/injection_container.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Provider;
import 'package:intl/intl.dart' hide TextDirection;
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mapness/_features/common/providers/network_status.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:provider/provider.dart';

class PrayerCard extends ConsumerWidget {
  const PrayerCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(networkStatusProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(RadiusBorder.xl),
        child: SizedBox(
          height: 347,
          child: BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
              bloc: sl<PrayerTimesCubit>(),
              builder: (context, state) {
                final nextPrayer = state.nextPrayer;

                if (nextPrayer == null || state.status == BlocRequestStatus.submissionGetCanceled) {
                  return const CustomShimmerWidget();
                }

                return Material(
                  child: Ink.image(
                    alignment: Alignment.topCenter,
                    fit: BoxFit.cover,
                    image: const AssetImage(
                      'assets/images/ishan-seefromthesky-unsplash.jpg',
                      package: PackageConfig.packageName,
                    ),
                    child: InkWell(
                      onTap: () {
                        Metrics.logEventAdvanced(
                          MetricsConstants.exploreKeys.prayerTimesBannerButton,
                          action: MetricAction.tap.name,
                          group: MetricsConstants.exploreTag,
                        );
                        NavigationService.navigatorKey.currentState!.pushNamed(
                          RouteName.prayerTimes,
                          arguments: context.read<PrayerTimesCubit>(),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: Spacing.$5x,
                          horizontal: Spacing.$6x,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'remain_to_azan'.tr().replaceAll('{}', state.nextPrayer!.prayer.label.tr()),
                              style: context.textStyleV3.bodyLargeRegular.copyWith(
                                color: context.color.textAndIconsBaseInversePrimary,
                              ),
                            ),
                            _NextPrayerTimer(
                              prayer: nextPrayer.prayer,
                              time: nextPrayer.dateTime,
                            ),
                            const Spacer(),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${'pray'.tr()} ${state.nextPrayer!.prayer.label.tr()}',
                                      style: context.textStyleV3.bodySmallRegular.copyWith(
                                        color: context.color.textAndIconsBaseInversePrimary,
                                      ),
                                    ),
                                    RichText(
                                      textDirection: TextDirection.ltr,
                                      text: TextSpan(
                                        style: context.textStyleV3.h2Medium.copyWith(
                                          color: context.colorsV2.staticWhite,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: DateFormat('hh:mm').format(state.nextPrayer!.dateTime),
                                          ),
                                          TextSpan(
                                            text: state.nextPrayer!.dateTime.hour > 12 ? ' pm' : ' am',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: _NotificationIconSwitch(),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}

class _NotificationIconSwitch extends StatefulWidget {
  const _NotificationIconSwitch();

  @override
  State<_NotificationIconSwitch> createState() => _NotificationIconSwitchState();
}

class _NotificationIconSwitchState extends State<_NotificationIconSwitch> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Metrics.logEventAdvanced(
            MetricsConstants.exploreKeys.prayerTimesBannerBellIcon,
            action: MetricAction.tap.name,
            group: MetricsConstants.exploreTag,
          );
          Provider.of<PrayerTimesCubit>(context, listen: false).prayerSettingsOnOff();
        },
        onTapDown: (_) {
          setState(() {
            isPressed = true;
          });
        },
        onTapUp: (_) {
          setState(() {
            isPressed = false;
          });
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(RadiusBorder.m),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: ColoredBox(
              color: Colors.white.withOpacity(0.25),
              child: Center(
                child: BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
                  builder: (context, state) {
                    final isNotificationDisabled = state.isNotificationDisable;
                    return Icon(
                      isNotificationDisabled ? SystemIcons.notification : SystemIcons.notificationFill,
                      color: isPressed ? context.colorsV2.foregroundMuted : Colors.white,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
}

class _NextPrayerTimer extends StatefulWidget {
  final Prayers prayer;
  final DateTime time;

  const _NextPrayerTimer({
    required this.prayer,
    required this.time,
  });

  @override
  State<_NextPrayerTimer> createState() => _NextPrayerTimerState();
}

class _NextPrayerTimerState extends State<_NextPrayerTimer> {
  final _countDownStream = StreamController<Duration>();

  @override
  void initState() {
    super.initState();

    DateTime prayerTime = widget.time;
    final DateTime now = DateTime.now();
    if (widget.prayer == Prayers.fajr && now.isAfter(prayerTime)) {
      prayerTime = prayerTime.add(const Duration(days: 1));
    }
    final remainingTime = prayerTime.difference(now);

    _countDownStream.sink.add(remainingTime);
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_countDownStream.isClosed) {
        final newRemainingTime = prayerTime.difference(DateTime.now());
        if (newRemainingTime.inSeconds >= 0) {
          _countDownStream.sink.add(newRemainingTime);
        } else {
          timer.cancel();
          _countDownStream.close();
        }
      }
    });
  }

  @override
  void dispose() {
    _countDownStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime prayerTime = widget.time;
    final DateTime now = DateTime.now();
    if (widget.prayer == Prayers.fajr) {
      prayerTime = prayerTime.add(const Duration(days: 1));
    }
    final remainingTime = prayerTime.difference(now);

    return StreamBuilder<Duration>(
      stream: _countDownStream.stream,
      builder: (context, snapshot) {
        final time = snapshot.data ?? remainingTime;
        final hours = time.inHours.toString().padLeft(2, '0');
        final minutes = (time.inMinutes % 60).toString().padLeft(2, '0');
        final seconds = (time.inSeconds % 60).toString().padLeft(2, '0');

        return Text(
          '$hours : $minutes : $seconds',
          style: context.textStyleV3.h1Medium.copyWith(color: context.colorsV2.staticWhite),
          textDirection: TextDirection.ltr,
        );
      },
    );
  }
}
