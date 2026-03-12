import 'package:flutter/material.dart' show WidgetsFlutterBinding, runApp;
import 'package:localize_and_translate/localize_and_translate.dart' show LocalizedApp;
import 'package:mapness/entry_point.dart';
import 'package:mapness/shared/lib/metrics/load_time.dart';
import 'package:mapness/shared/lib/urbi_metrics_utils.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import './app/core/utils/utils_exports.dart' show EnvType;
import './app/app.dart';
import './env.dart';

void main() async {
  await runMapnessApp(EnvType.urbiPre, () async {
    AdvancedMetrics.instance.startMeasureStartup(LoadType.cold);
    await AppEnv.setupEnv(EnvType.urbiPre);
    await setupMapness(EnvType.urbiPre);

    await SentryFlutter.init(
      (options) {
        options.dsn = 'https://c848141ab84678437eab2cc271b99a6f@sentry.momah.gov.sa/4';
        // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
        // We recommend adjusting this value in production.
        options.tracesSampleRate = 1.0;
        // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
        // We recommend adjusting this value in production.
        options.profilesSampleRate = 1.0;
        // options.attachScreenshot = true;
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
        // options.captureFailedRequests = true;
        options.environment = EnvType.urbiPre.name;
        // Auto Performance Instrumentation
        options.enableAutoPerformanceTracing = true;
        options.enableUserInteractionTracing = true;
        options.enableAppHangTracking = true;

        // Session Tracking
        options.enableAutoSessionTracking = true;
        // Breadcrumbs
        options.maxBreadcrumbs = 100;

        // Screenshots and Attachments
        options.attachScreenshot = true;
        options.screenshotQuality = SentryScreenshotQuality.high;
        options.attachViewHierarchy = true;

        // Debug Options
        options.diagnosticLevel = SentryLevel.debug;

        // Additional Performance Settings
        options.enableTimeToFullDisplayTracing = true;
      },
      appRunner: () => runApp(const MapnessProviderScope(child: LocalizedApp(child: App()))),
    );
  });
}
