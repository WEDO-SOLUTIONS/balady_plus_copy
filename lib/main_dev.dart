import 'package:flutter/material.dart' show runApp;
import 'package:flutter_bloc/flutter_bloc.dart' show Bloc;
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

  runApp(LocalizedApp(child: const App()));
}
