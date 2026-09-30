import 'dart:async';

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

/// How long after the first rasterized frame start-up work (map, sheets, dashboard requests) is given to finish.
const kAppSettleDelay = Duration(seconds: 5);

/// Longest wait for an idle scheduler slot. Idle tasks never run while any ticker is active, and the landing can
/// animate indefinitely (loading shimmers, city-event logos, the national flag), so waiting for true idleness alone
/// could postpone the work forever.
const kAppIdleTimeout = Duration(seconds: 3);

Future<void>? _startupSettled;

/// Completes once the app is past its start-up work, for best-effort work that must not compete with it
/// (secondary requests, cache warm-ups).
///
/// Waits for the first rasterized frame, then [kAppSettleDelay] (once per app run), then for an idle slot of the
/// scheduler — [Priority.idle] tasks are not run while animations are in flight (sheet snapping, route transitions) —
/// but no longer than [kAppIdleTimeout].
///
/// Never completes if the app never draws a frame (e.g. the engine runs only for CarPlay / Android Auto).
Future<void> whenAppSettled() async {
  await (_startupSettled ??= _waitForStartup());
  await Future.any([
    SchedulerBinding.instance.scheduleTask<void>(() {}, Priority.idle),
    Future<void>.delayed(kAppIdleTimeout),
  ]);
}

Future<void> _waitForStartup() async {
  await WidgetsBinding.instance.waitUntilFirstFrameRasterized;
  await Future<void>.delayed(kAppSettleDelay);
}
