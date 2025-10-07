import 'package:localize_and_translate/localize_and_translate.dart'
    show LocalizedApp;
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:localize_and_translate/localize_and_translate.dart' show LocalizedApp;
import 'package:mapness/entry_point.dart';
import 'package:mapness/shared/lib/metrics/load_time.dart';
import 'package:mapness/shared/lib/urbi_metrics_utils.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import './app/core/utils/utils_exports.dart' show EnvType;
import './app/app.dart';
import './env.dart';
import 'package:flutter/material.dart';

import 'app/events_logs/balady_logs.dart';

void main() async {
  unhandledExceptionBaladyLogs(() async {
    await runMapnessApp(EnvType.stg, () async {

      AdvancedMetrics.instance.startMeasureStartup(LoadType.cold);
      await AppEnv.setupEnv(EnvType.stg);
      await setupMapness(EnvType.stg);
      await SentryFlutter.init(
        (options) {
          options.dsn = 'https://c848141ab84678437eab2cc271b99a6f@sentry.momah.gov.sa/4';
          // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
          // We recommend adjusting this value in production.
          options.tracesSampleRate = 1.0;
          // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
          // We recommend adjusting this value in production.
          options.profilesSampleRate = 1.0;
          options.attachScreenshot = true;
          options.enableUserInteractionTracing = true;
          options.reportSilentFlutterErrors = true;
          options.enableAppHangTracking = true;
          options.enableAutoPerformanceTracing = true;
          options.enableAutoNativeBreadcrumbs = true;
          options.enableNativeCrashHandling = true;
          options.enableTimeToFullDisplayTracing = true;
          options.enableAppHangTracking = true;
          options.enableAppLifecycleBreadcrumbs = true;
          options.enableFramesTracking = true;
          options.captureFailedRequests = true;
          options.environment = EnvType.stg.name;
          options.replay.onErrorSampleRate = 1.0;
          options.replay.sessionSampleRate = 1.0;

          // Screenshots and Attachments
          options.attachScreenshot = true;
          options.screenshotQuality = SentryScreenshotQuality.medium;
          options.attachViewHierarchy = true;

          // Debug Options
          options.diagnosticLevel = SentryLevel.debug;
        },
        appRunner: () => runApp(
          SentryWidget(
            child: const MapnessProviderScope(
              child: LocalizedApp(
                child: App(),
              ),
            ),
          ),
        ),
      );
    });
  });
}
