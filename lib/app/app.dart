import 'package:balady_plus/app/features/map_page/presentation/mvvm/map_view_model.dart';
import 'package:bot_toast/bot_toast.dart'
    show BotToastInit, BotToastNavigatorObserver;
import 'package:country_picker/country_picker.dart' show CountryLocalizations;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocProvider;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation, translator;

import '../etmam_app/features/etmam_entry_point/presentation/cubit/etmam_entry_point_cubit.dart';
import '../etmam_app/features/my_orders/presentation/pages/orders_page.dart';
import './core/dependency_injection/dependency_injection_exports.dart' show sl;
import './core/services/services_exports.dart' show NavigationService;
import './core/utils/utils_exports.dart'
    show AppColor, AppConfig, AppRouter, EtmamRoutesNames, RouteName;
import './core/dependency_injection/dependency_injection_exports.dart' show sl;
import 'core/utils/routes.dart';
import 'features/appointments/presentation/pages/appointments_list_screen.dart';
import 'features/bottom_navigation/presentation/pages/bottom_navigation_page.dart';
import 'features/calendar/presentation/bloc/calendar_bloc.dart';
import 'features/calendar/presentation/bloc/calendar_event.dart';
import 'features/entry_point/presentation/cubit/auth_cubit.dart';

import 'package:provider/provider.dart';

import 'features/location/presentation/bloc/location_bloc.dart';
import 'features/weather/presentation/bloc/weather_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterUxConfig config = FlutterUxConfig(
        enableAdvancedGestureRecognition: true,
        enableCrashHandling: true,
        enableMultiSessionRecord: true,
        enableNetworkLogging: true,
        userAppKey: "2w1otnta9bvvhzo",
        enableAutomaticScreenNameTagging: false);
    FlutterUxcam.startWithConfiguration(config);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) =>
              MapViewModel(layersRepositories: sl()),
        ),
        BlocProvider.value(value: sl<EtmamEntryPointCubit>()),
        BlocProvider.value(value: sl<LocationCubit>()),
      ],
      child: BlocProvider<EntryPointCubit>.value(
          value: sl<EntryPointCubit>()..onLoadingApp(),
          child: MaterialApp(
            title: 'appNameWord'.tr(),
            debugShowCheckedModeBanner: false,
            navigatorKey: NavigationService.navigatorKey,
            theme: ThemeData(
              primaryColor: AppColor.blue,
              scaffoldBackgroundColor: AppColor.scaffoldBackground,
              fontFamily: AppConfig.appFontType,
              useMaterial3: false,
              appBarTheme: const AppBarTheme(backgroundColor: AppColor.blue),
            ),
            builder: EasyLoading.init(builder: BotToastInit()),
            navigatorObservers: [
              BotToastNavigatorObserver(),
              FlutterUxcamNavigatorObserver(),
            ],
            localizationsDelegates: translator.delegates.toList()
              ..add(CountryLocalizations.delegate), // Android + iOS Delegates
            locale: translator.activeLocale, // Active locale
            supportedLocales: translator.locals(), // Locals list
            initialRoute: RouteName.splash,
            routes: Routes.routes(),
          )),
    );
  }
}
