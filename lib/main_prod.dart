import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:balady_plus/app/features/accecipilities/balady_theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart' show LocalizedApp;
import 'package:mapness/entry_point.dart';
import 'package:mapness/shared/lib/metrics/load_time.dart';
import 'package:mapness/shared/lib/urbi_metrics_utils.dart';
import 'package:provider/provider.dart';

import './app/app.dart';
import './app/core/utils/utils_exports.dart' show EnvType;
import './env.dart';

void main() async {
  await unhandledExceptionBaladyLogs(() async {
    WidgetsFlutterBinding.ensureInitialized();

    final themeNotifier = BaladyThemeNotifier();

    await themeNotifier.init();
    await runMapnessApp(EnvType.prod, () async {
      AdvancedMetrics.instance.startMeasureStartup(LoadType.cold);
      await AppEnv.setupEnv(EnvType.prod);
      await setupMapness(EnvType.prod);

      runApp(
        MultiProvider(
          providers: [ChangeNotifierProvider(create: (_) => themeNotifier)],
          child: const MapnessProviderScope(child: LocalizedApp(child: App())),
        ),
      );
      // await SentryFlutter.init(
      //       (options) {
      //         options.dsn =
      //         'https://c848141ab84678437eab2cc271b99a6f@sentry.momah.gov.sa/4';
      //         // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      //         // We recommend adjusting this value in production.
      //         options.tracesSampleRate = 0.3;
      //         // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      //         // We recommend adjusting this value in production.
      //         options.profilesSampleRate = 0.3;
      //         // options.attachScreenshot = true;
      //         options.enableUserInteractionTracing = true;
      //         options.reportSilentFlutterErrors = true;
      //         options.enableAppHangTracking = true;
      //         options.enableAutoPerformanceTracing = true;
      //         options.enableAutoNativeBreadcrumbs = true;
      //         options.enableNativeCrashHandling = true;
      //         options.enableTimeToFullDisplayTracing = true;
      //         options.enableAppHangTracking = true;
      //         options.enableAppLifecycleBreadcrumbs = true;
      //         options.enableFramesTracking = true;
      //         // options.captureFailedRequests = true;
      //         options.environment = EnvType.prod.name;
      //
      //         // Auto Performance Instrumentation
      //         options.enableAutoPerformanceTracing = true;
      //         options.enableUserInteractionTracing = true;
      //         options.enableAppHangTracking = true;
      //
      //         // Session Tracking
      //         options.enableAutoSessionTracking = true;
      //         // Breadcrumbs
      //         options.maxBreadcrumbs = 100;
      //
      //         // Screenshots and Attachments
      //         options.attachScreenshot = true;
      //         options.screenshotQuality = SentryScreenshotQuality.medium;
      //         options.attachViewHierarchy = true;
      //
      //         // Debug Options
      //         options.diagnosticLevel = SentryLevel.warning;
      //
      //         // Additional Performance Settings
      //         options.enableTimeToFullDisplayTracing = true;
      //   },
      //   appRunner: () => runApp(MapnessProviderScope(child: LocalizedApp(child: App()))),
      // );
    });
  });
}
