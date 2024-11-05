library smart_advisor;

import 'package:flutter/material.dart';
import 'package:smart_advisor/app/app.dart';
import 'package:smart_advisor/app/core/services/services_exports.dart';

import 'app/core/dependency_injection/injection_container.dart';
import 'app/features/onboarding/pages/onbordingPage.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart' show EnvType;
import 'app/core/utils/utils_exports.dart' as utils;

class SmartAdvisor {
  static late BuildContext ctx;
  static late utils.EnvType env;
  static void navigateToSmartAdvisorApp(
      {required BuildContext context, required EnvType envType}) {
    try {
      ctx = context;
      env = envType == EnvType.prod ? utils.EnvType.prod : utils.EnvType.stg;

      initialize(env);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SmartAdvisorApp()),
      );
    } catch (ex) {
      print(ex);
    }
  }
}
