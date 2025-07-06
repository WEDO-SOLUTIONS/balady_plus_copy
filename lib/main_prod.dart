import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart' ;
import 'package:localize_and_translate/localize_and_translate.dart'
    show LocalizedApp;
import 'package:mapness/entry_point.dart';
import 'package:mapness/shared/lib/metrics/load_time.dart';
import 'package:mapness/shared/lib/urbi_metrics_utils.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import './app/core/utils/utils_exports.dart' show EnvType;
import './app/app.dart';
import './env.dart';
import 'app/core/dependency_injection/injection_container.dart';

import 'package:balady_plus/app/events_logs/balady_logs.dart';


void main() async {
  unhandledExceptionBaladyLogs( () async {
    await runMapnessApp(() async {
    AdvancedMetrics.instance.startMeasureStartup(LoadType.cold);
    await AppEnv.setupEnv(EnvType.prod);
    await setupMapness(EnvType.prod);
    await SentryFlutter.init(
      (options) {
        options.dsn =
            'https://c9e9c70957e4433e99fb6be6fc1cafc8@sentry.42.solutions/24';
        // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
        // We recommend adjusting this value in production.
        options.tracesSampleRate = 0.1;
        // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
        // We recommend adjusting this value in production.
        options.profilesSampleRate = 0.1;
        options.attachScreenshot = true;
        options.enableUserInteractionTracing = true;
        options.captureFailedRequests = true;
        options.environment = sl<EnvType>().name;
      },
      appRunner: () =>
          runApp( MapnessProviderScope(child: LocalizedApp(child: App()))),
    );
  });
  });
}
