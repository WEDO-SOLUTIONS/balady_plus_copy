import 'package:balady_plus/etmam_app/features/etmam_entry_point/presentation/cubit/etmam_entry_point_cubit.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:balady_plus/etmam_app/features/bottom_navigation/bottom_navigation_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocProvider, MultiBlocProvider, BlocConsumer;
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation, translator;
import 'package:balady_plus/app/core/utils/etmam_route_exports.dart';

import '../app/core/utils/constants/route_names.dart';
import './core/dependency_injection/dependency_injection_exports.dart' show sl;
import './core/services/services_exports.dart' show NavigationService;
import './core/utils/utils_exports.dart'
    show AppColor, AppConfig, AppRouter, RouteName;

class EtmamApp extends StatefulWidget {
  const EtmamApp({Key? key}) : super(key: key);

  @override
  State<EtmamApp> createState() => _EtmamAppState();
}

class _EtmamAppState extends State<EtmamApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sl<EtmamEntryPointCubit>().onLogin();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarBrightness: Brightness.light));

    return MaterialApp(
      title: 'appNameWord'.tr(),
      debugShowCheckedModeBanner: false,
      // navigatorKey: NavigationService.navigatorKey,
      theme: ThemeData(
        primaryColor: AppColor.blue700,
        scaffoldBackgroundColor: AppColor.appBackground,
        fontFamily: AppConfig.appFontType,
        appBarTheme: const AppBarTheme(backgroundColor: AppColor.blue),
      ),
      localizationsDelegates: translator.delegates,
      // Android + iOS Delegates
      locale: translator.activeLocale,
      // Active locale
      supportedLocales: translator.locals(),
      // Locals list
      //initialRoute: RouteName.splash,
      // onGenerateRoute: AppRouter.allRoutes,

      routes: {
        //   RouteName.bottomNavigation: (context) => BottomNavigationPage(),

        EtmamRoutesNames.myOrdersPage: (context) => const OrdersPage()
      },
      //builder: BotToastInit(),
    );
  }
}
