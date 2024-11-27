import 'package:bot_toast/bot_toast.dart'
    show BotToastInit, BotToastNavigatorObserver;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocProvider;
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation, translator;
import 'package:smart_advisor/app/features/onboarding/pages/onbordingPage.dart';
//import 'package:mapness/entry_point.dart';

import './core/services/services_exports.dart' show NavigationService;
import './core/utils/utils_exports.dart'
    show AppColor, AppConfig, AppRouter, CommonFunctions, RouteName;
import 'core/utils/constants/language.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart' show EnvType;

class SmartAdvisorApp extends StatelessWidget {
  const SmartAdvisorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Navigator(
          // Initial route

          key: NavigationService.navigatorKey,

          initialRoute: RouteName.onbording,
          // Route generation from package
          onGenerateRoute: AppRouter.allRoutes,
        ),
      ),
    );

    return MaterialApp(
      title: Language.appName,
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationService.navigatorKey,
      theme: ThemeData(
          primaryColor: AppColor.blue,
          scaffoldBackgroundColor: AppColor.white,
          fontFamily: AppConfig.appFontType,
          appBarTheme: const AppBarTheme(backgroundColor: AppColor.white)),
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      localizationsDelegates: translator.delegates,
      locale: translator.activeLocale,
      supportedLocales: translator.locals(),
      home: Onbordingpage(),
      onGenerateRoute: AppRouter.allRoutes,
    );
  }
}
