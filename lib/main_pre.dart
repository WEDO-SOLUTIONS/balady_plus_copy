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
    await runMapnessApp(EnvType.pre, () async {
      AdvancedMetrics.instance.startMeasureStartup(LoadType.cold);
      await AppEnv.setupEnv(EnvType.pre);
      await setupMapness(EnvType.pre);
      runApp(
        MultiProvider(
          providers: [ChangeNotifierProvider(create: (_) => themeNotifier)],
          child: MapnessProviderScope(child: LocalizedApp(child: App())),
        ),
      );
      // await SentryFlutter.init(
      //   (options) {
      //     options.dsn = 'https://c848141ab84678437eab2cc271b99a6f@sentry.momah.gov.sa/4';
      //     // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      //     // We recommend adjusting this value in production.
      //     options.tracesSampleRate = 1.0;
      //     // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      //     // We recommend adjusting this value in production.
      //     options.profilesSampleRate = 1.0;
      //     options.enableUserInteractionTracing = true;
      //     options.reportSilentFlutterErrors = true;
      //     options.enableAppHangTracking = true;
      //     options.enableAutoPerformanceTracing = true;
      //     options.enableAutoNativeBreadcrumbs = true;
      //     options.enableNativeCrashHandling = true;
      //     options.enableTimeToFullDisplayTracing = true;
      //     options.enableAppLifecycleBreadcrumbs = true;
      //     options.enableFramesTracking = true;
      //     // options.captureFailedRequests = true;
      //     options.environment = EnvType.pre.name;
      //
      //     // Session Tracking
      //     options.enableAutoSessionTracking = true;
      //     // Breadcrumbs
      //     options.maxBreadcrumbs = 100;
      //
      //     // Screenshots and Attachments
      //     options.attachScreenshot = true;
      //     options.screenshotQuality = SentryScreenshotQuality.medium;
      //     options.attachViewHierarchy = true;
      //
      //     // Debug Options
      //     options.diagnosticLevel = SentryLevel.debug;
      //   },
      //   appRunner: () => ,
      // );
    });
  });
}
