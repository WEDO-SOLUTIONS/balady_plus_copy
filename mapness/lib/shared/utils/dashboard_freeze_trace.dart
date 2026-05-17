import 'package:flutter/foundation.dart';

const _tag = '[DASH_FREEZE_TRACE]';

void dashboardFreezeTrace(String message) {
  final time = DateTime.now().toIso8601String();
  debugPrintSynchronously('$_tag $time $message');
}
