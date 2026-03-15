import 'dart:async';

import 'package:balady_uikit/core/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/utils/utils_exports.dart' show Prayers;

class NextPrayerHome extends StatefulWidget {
  final Prayers prayer;
  final DateTime time;

  const NextPrayerHome({super.key, required this.prayer, required this.time});

  @override
  State<NextPrayerHome> createState() => _NextPrayerState();
}

class _NextPrayerState extends State<NextPrayerHome> {
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
      prayerTime = prayerTime.add(Duration(days: 1));
    }
    final remainingTime = prayerTime.difference(now);

    return StreamBuilder<Duration>(
      stream: _countDownStream.stream,
      builder: (context, snapshot) {
        final time = snapshot.data ?? remainingTime;
        final hours = time.inHours.toString().padLeft(2, '0');
        final minutes = (time.inMinutes % 60).toString().padLeft(2, '0');
        final seconds = (time.inSeconds % 60).toString().padLeft(2, '0');

        return hours != "00"
            ? Text(
                "$hours:$minutes:$seconds",
                style: Theme.of(context).extension<ThemeTextStyles>()!.accent.copyWith(color: Colors.white),
              )
            : Text(
                "$minutes:$seconds",
                style: Theme.of(context).extension<ThemeTextStyles>()!.accent.copyWith(color: Colors.white),
              );
      },
    );
  }
}
