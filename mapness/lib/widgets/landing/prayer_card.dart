import 'dart:async';
import 'dart:ui';

import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_shimmer_list_widget.dart';
import 'package:balady_plus/app/features/public_services_features/prayer_times/presentation/cubit/prayer_times_cubit.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mapness/_features/common/providers/network_status.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/utils/text_utils/arabic_numerals.dart';
import 'package:provider/provider.dart' as provider;

class PrayerCard extends ConsumerWidget {
  const PrayerCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bloc = sl<PrayerTimesCubit>();

    ref.listen(networkStatusProvider, (prev, next) {
      final wasNotConnected = !(prev ?? false);
      final nowIsConnected = next;

      if (wasNotConnected && nowIsConnected) {
        bloc
          ..getPrayerTime()
          ..getPrayerSettings()
          ..getPrayerTimeRange();
      }
    });

    return BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
      bloc: bloc,
      builder: (context, state) {
        final nextPrayer = state.nextPrayer;

        if (state.status == BlocRequestStatus.submissionGetFailure) {
          return const SizedBox();
        }

        final isLoading = nextPrayer == null || state.status == BlocRequestStatus.submissionGetCanceled;

        return Padding(
          padding: const EdgeInsets.only(
            left: Spacing.$4x,
            right: Spacing.$4x,
            bottom: Spacing.$8x,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(RadiusBorder.xl),
            child: SizedBox(
              height: 347,
              child: isLoading
                  ? const Padding(
                      padding: EdgeInsets.only(bottom: Spacing.$8x),
                      child: CustomShimmerWidget(),
                    )
                  : Material(
                      child: Ink.image(
                        alignment: Alignment.topCenter,
                        fit: BoxFit.cover,
                        image: AssetImage(
                          Assets.images.ishanSeefromtheskyUnsplash.keyName,
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
                              arguments: bloc,
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
                                  style: context.textStyles.bodyLargeRegular.copyWith(
                                    color: context.color.textAndIconsBaseInversePrimary,
                                  ),
                                ),
                                _NextPrayerTimer(
                                  key: Key(nextPrayer.prayer.name),
                                  onTimerEnd: () => bloc.updateNextPrayer(),
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
                                          style: context.textStyles.bodySmallRegular.copyWith(
                                            color: context.color.textAndIconsBaseInversePrimary,
                                          ),
                                        ),
                                        RichText(
                                          textDirection: TextDirection.ltr,
                                          text: TextSpan(
                                            style: context.textStyles.h2Medium.copyWith(
                                              color: context.colors.staticWhite,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: context.digits(
                                                  DateFormat('hh:mm').format(state.nextPrayer!.dateTime),
                                                ),
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
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        );
      },
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
      provider.Provider.of<PrayerTimesCubit>(context, listen: false).prayerSettingsOnOff();
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
                  color: isPressed ? context.colors.foregroundMuted : Colors.white,
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
  final Function() onTimerEnd;

  const _NextPrayerTimer({
    required this.prayer,
    required this.time,
    required this.onTimerEnd,
    super.key,
  });

  @override
  State<_NextPrayerTimer> createState() => _NextPrayerTimerState();
}

class _NextPrayerTimerState extends State<_NextPrayerTimer> {
  late final StreamController<Duration> _countDownStream;
  late final Timer _timer;

  @override
  void initState() {
    super.initState();

    _countDownStream = StreamController<Duration>();

    DateTime prayerTime = widget.time;
    final DateTime now = DateTime.now();
    if (widget.prayer == Prayers.fajr && now.isAfter(prayerTime)) {
      prayerTime = prayerTime.add(const Duration(days: 1));
    }
    final remainingTime = prayerTime.difference(now);

    _countDownStream.sink.add(remainingTime);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_countDownStream.isClosed) {
        final newRemainingTime = prayerTime.difference(DateTime.now());
        if (newRemainingTime.inSeconds >= 0) {
          _countDownStream.sink.add(newRemainingTime);
        } else {
          widget.onTimerEnd();
        }
      }
    });
  }

  @override
  void dispose() {
    _countDownStream.close();
    _timer.cancel();
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
          context.digits('$hours:$minutes:$seconds'),
          style: context.textStyles.h1Medium.copyWith(color: context.colors.staticWhite),
          textDirection: TextDirection.ltr,
        );
      },
    );
  }
}
