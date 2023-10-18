import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart' show runApp;
import 'package:flutter_bloc/flutter_bloc.dart' show Bloc;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localize_and_translate/localize_and_translate.dart'
    show LocalizedApp;

import './app/core/services/services_exports.dart' show SimpleBlocObserver;
import './app/core/utils/utils_exports.dart' show EnvType;
import './app/app.dart';
import './env.dart';

void main() async {
  await AppEnv.setupEnv(EnvType.dev);

  // to observe all blocs movements
  Bloc.observer = SimpleBlocObserver();

  await initialiseDGis(
    logOptions: LogOptionsMessage(
      systemLevel: LogLevelMessage.verbose,
      customLevel: LogLevelMessage.verbose,
      customSink: "BaladyDGis",
    ),
  );

  runApp(LocalizedApp(child: const App()));
}
