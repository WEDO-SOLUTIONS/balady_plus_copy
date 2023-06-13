import 'package:bot_toast/bot_toast.dart'
    show BotToastInit, BotToastNavigatorObserver;
import 'package:country_picker/country_picker.dart' show CountryLocalizations;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocProvider;
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation, translator;

import './core/services/services_exports.dart' show NavigationService;
import './core/utils/utils_exports.dart'
    show AppColor, AppConfig, AppRouter, RouteName;
import './features/entry_point/entry_point_exports.dart' show EntryPointCubit;
import './core/dependency_injection/dependency_injection_exports.dart' show sl;

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EntryPointCubit>(
      create: (context) => EntryPointCubit(
        clearAuth: sl(),
        fetchAuth: sl(),
        persistAuth: sl(),
        updateAuth: sl(),
      )..onLoadingApp(),
      child: MaterialApp(
        title: 'appNameWord'.tr(),
        debugShowCheckedModeBanner: false,
        navigatorKey: NavigationService.navigatorKey,
        theme: ThemeData(
          primaryColor: AppColor.blue,
          scaffoldBackgroundColor: AppColor.scaffoldBackground,
          fontFamily: AppConfig.appFontType,
          appBarTheme: const AppBarTheme(backgroundColor: AppColor.blue),
          
        ),
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
        localizationsDelegates: translator.delegates.toList()
          ..add(CountryLocalizations.delegate), // Android + iOS Delegates
        locale: translator.activeLocale, // Active locale
        supportedLocales: translator.locals(), // Locals list
        initialRoute: RouteName.splash,
        onGenerateRoute: AppRouter.allRoutes,
      ),
    );
  }
}
