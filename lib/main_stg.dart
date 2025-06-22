import 'package:app_tracking_transparency/app_tracking_transparency.dart';
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
import 'package:flutter/material.dart';

import 'app/events_logs/balady_logs.dart';

void main() async {
  AdvancedMetrics.instance.startMeasureStartup(LoadType.cold);
  unhandledExceptionBaladyLogs(() async {
    await runMapnessApp(() async {
      await AppEnv.setupEnv(EnvType.stg);
      await setupMapness(EnvType.stg);
      await SentryFlutter.init(
        (options) {
          options.dsn =
              'https://9aa759b78c44294405004545d91488a6@sentry.momah.gov.sa/85';
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
        appRunner: () => runApp(
          const MapnessProviderScope(
            child: LocalizedApp(
              child: App(),
            ),
          ),
        ),
      );
    });
  });
}
