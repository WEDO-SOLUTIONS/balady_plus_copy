import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show Bloc;
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
  WidgetsFlutterBinding.ensureInitialized();

  unhandledExceptionBaladyLogs(() async {
    AdvancedMetrics.instance.startMeasureStartup(LoadType.cold);
    final status = await AppTrackingTransparency.requestTrackingAuthorization();
    
    await runMapnessApp(() async {
      await AppEnv.setupEnv(EnvType.dev);

      // to observe all blocs movements
      // Bloc.observer = SimpleBlocObserver();

      await setupMapness(EnvType.dev);

      await SentryFlutter.init(
        (options) {
          options.dsn =
              'https://c9e9c70957e4433e99fb6be6fc1cafc8@sentry.42.solutions/24';
          options.tracesSampleRate = 0.1;
          options.profilesSampleRate = 0.1;
          options.attachScreenshot = true;
          options.enableUserInteractionTracing = true;
          options.captureFailedRequests = true;
          options.environment = sl<EnvType>().name;
        },
        appRunner: () => runApp(MapnessProviderScope(
            child: LocalizedApp(child: App(status: status)))),
      );
    });
  });
}
