import 'package:flutter/material.dart' show runApp;
import 'package:flutter_bloc/flutter_bloc.dart' show Bloc;
import 'package:localize_and_translate/localize_and_translate.dart'
    show LocalizedApp;
import 'package:mapness/entry_point.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import './app/core/services/services_exports.dart' show SimpleBlocObserver;
import './app/core/utils/utils_exports.dart' show EnvType;
import './app/app.dart';
import './env.dart';

void main() async {
  await AppEnv.setupEnv(EnvType.dev);

  // to observe all blocs movements
  Bloc.observer = SimpleBlocObserver();

  await setupMapness();

  await SentryFlutter.init(
    (options) {
      options.dsn =
          'http://f230d269670f3ea9c5280e22d3ce29ed@84.252.137.67:9000/2';
      options.tracesSampleRate = 1.0;
      options.enableTracing = true;
      options.attachViewHierarchy = true;
      options.attachScreenshot = true;
    },
    appRunner: () => runApp(
      const MapnessProviderScope(
        child: LocalizedApp(
          child: App(),
        ),
      ),
    ),
  );
}
