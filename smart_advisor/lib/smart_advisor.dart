library smart_advisor;

import 'package:flutter/material.dart';
import 'package:smart_advisor/app/app.dart';
import 'package:smart_advisor/app/core/services/services_exports.dart';

import 'app/core/dependency_injection/injection_container.dart';
import 'app/features/onboarding/pages/onbordingPage.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart' show EnvType;

class SmartAdvisor {
  static late BuildContext ctx;
  static void navigateToSmartAdvisorApp(
      {required BuildContext context, required EnvType envType}) {
    try {
      initialize();
      ctx = context;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SmartAdvisorApp()),
      );
    } catch (ex) {
      print(ex);
    }
  }
}
