import 'dart:async';

import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart' show AppColor, AppStyle, Prayers;
import '../../../../_shared_feature_/shared_feature_exports.dart' show CustomTextWidget, DrawIconBasedTypeWidget;

class NextPrayer extends StatefulWidget {
  final Prayers prayer;
  final DateTime time;

  const NextPrayer({
    super.key,
    required this.prayer,
    required this.time,
  });

  @override
  State<NextPrayer> createState() => _NextPrayerState();
}

class _NextPrayerState extends State<NextPrayer> {
  final _countDownStream = StreamController<Duration>();

  @override
  void initState() {
    super.initState();
    DateTime prayerTime = widget.time;
    final DateTime now = DateTime.now();
    if (widget.prayer == Prayers.fajr && now.isAfter(prayerTime)) {
      prayerTime = prayerTime.add(Duration(days: 1));
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
      prayerTime = prayerTime.add(Duration(days: 1));
    }
    final remainingTime = prayerTime.difference(now);

    return Column(
      children: [
        DrawIconBasedTypeWidget(
          icon: widget.prayer.icon,
          iconColor: AppColor.blackModern50Light,
          iconSize: 35,
        ),
        const SizedBox(height: 8),
        CustomTextWidget(
          "${widget.prayer.name.tr()} ${'after'.tr()}",
          textStyle: AppStyle.prayerTimeCityTextStyle,
        ),
        const SizedBox(height: 16),
        StreamBuilder<Duration>(
          stream: _countDownStream.stream,
          builder: (context, snapshot) {
            final time = snapshot.data ?? remainingTime;
            final hours = time.inHours.toString().padLeft(2, '0');
            final minutes = (time.inMinutes % 60).toString().padLeft(2, '0');
            final seconds = (time.inSeconds % 60).toString().padLeft(2, '0');

            return Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PrayerCountDownContainer(
                    count: seconds,
                  ),
                  const SizedBox(width: 16),
                  PrayerCountDownContainer(
                    count: minutes,
                  ),
                  const SizedBox(width: 16),
                  PrayerCountDownContainer(
                    count: hours,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class PrayerCountDownContainer extends StatelessWidget {
  final String count;
  const PrayerCountDownContainer({
    super.key,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      padding: const EdgeInsets.all(10),
      decoration: ShapeDecoration(
        color: AppColor.blackModern50Light20,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: Center(
        child: CustomTextWidget(
          count,
          textStyle: AppStyle.prayerTimeCityTextStyle.copyWith(
            color: AppColor.secondary100Light,
          ),
        ),
      ),
    );
  }
}
