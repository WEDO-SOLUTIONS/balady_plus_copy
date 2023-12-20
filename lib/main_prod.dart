import 'package:flutter/material.dart' show runApp;
import 'package:localize_and_translate/localize_and_translate.dart'
    show LocalizedApp;
import 'package:mapness/entry_point.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import './app/core/utils/utils_exports.dart' show EnvType;
import './app/app.dart';
import './env.dart';
import 'app/core/dependency_injection/injection_container.dart';

void main() async {
  await AppEnv.setupEnv(EnvType.prod);

  await setupMapness(EnvType.prod);

  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://50b0a8db4073d7769253664cf62c123f@o4506314696163329.ingest.sentry.io/4506351858417664';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.profilesSampleRate = 1.0;
      options.attachScreenshot = true;
      options.enableUserInteractionTracing = true;
      options.captureFailedRequests = true;
      options.environment = sl<EnvType>().name;
    },
    appRunner: () =>
        runApp(const MapnessProviderScope(child: LocalizedApp(child: App()))),
  );
}
