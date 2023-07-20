import 'package:flutter/material.dart' show runApp;
import 'package:localize_and_translate/localize_and_translate.dart'
    show LocalizedApp;

import './app/core/utils/utils_exports.dart' show EnvType;
import './app/app.dart';
import './env.dart';

void main() async {
  await AppEnv.setupEnv(EnvType.prod);

  runApp(LocalizedApp(child: const App()));
}
