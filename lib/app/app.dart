import 'dart:io';

import 'package:balady_authorization/auth_package.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/remote_config.dart';

import 'package:balady_plus/app/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/cubit/new_mini_app_logic_cubit.dart';
import 'package:balady_plus/mini_apps_engine/presentation/bloc/home_mini_apps_list_bloc/home_mini_apps_list_cubit.dart';
import 'package:bot_toast/bot_toast.dart'
    show BotToastInit, BotToastNavigatorObserver;
import 'package:country_picker/country_picker.dart' show CountryLocalizations;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocProvider;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation, translator;
import 'package:mapness/entry_point.dart';
import 'package:provider/provider.dart';

import './core/dependency_injection/dependency_injection_exports.dart' show sl;
import './core/services/services_exports.dart' show NavigationService;
import './core/utils/utils_exports.dart' show AppColor, AppConfig, RouteName;
import 'core/utils/routes.dart';
import 'features/entry_point/presentation/cubit/auth_cubit.dart';
import 'features/location/presentation/bloc/location_bloc.dart';

import 'package:sentry_flutter/sentry_flutter.dart';

final GlobalKey<AppWidgetState> materialAppKey = GlobalKey();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    if (RemoteConfig.uxCamKey.isNotEmpty) {
      FlutterUxConfig config = FlutterUxConfig(
          enableAdvancedGestureRecognition: true,
          enableCrashHandling: true,
          enableMultiSessionRecord: true,
          enableNetworkLogging: true,
          userAppKey: RemoteConfig.uxCamKey,
          enableAutomaticScreenNameTagging: false);
      FlutterUxcam.optIntoSchematicRecordings();
      FlutterUxcam.startWithConfiguration(config);
    }
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(
        //   create: (BuildContext context) =>
        //       MapViewModel(layersRepositories: sl()),
        // ),
        // BlocProvider.value(value: sl<EtmamEntryPointCubit>()),
        // BlocProvider.value(value: sl<ForceUpdateCubit>()),
        BlocProvider.value(value: sl<LocationCubit>()),
        BlocProvider.value(value: sl<SplashCubit>()),
        BlocProvider.value(value: sl<HomeMiniAppsListCubit>()),
        BlocProvider<NewMiniAppLogicCubit>.value(
          value: sl<NewMiniAppLogicCubit>(),
        )
        // BlocProvider<DashboardBloc>(
        //   create: (_) => sl<DashboardBloc>()..add(DashboardEventInitial()),
        // ),
      ],
      child: BlocProvider<EntryPointCubit>.value(
        value: sl<EntryPointCubit>(),
        child: BaladyAuthorizationBloc(
          child: AppWidget(
            key: materialAppKey,
          ),
        ),
      ),
    );
  }
}

class AppWidget extends StatefulWidget {
  const AppWidget({
    super.key,
  });

  @override
  State<AppWidget> createState() => AppWidgetState();
}

class AppWidgetState extends State<AppWidget> {
  @override
  void initState() {
    super.initState();
  }

  void callback() {}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // When running in iOS, dismiss the keyboard when any Tap happens outside a TextField
        if (Platform.isIOS) hideKeyboard(context);
      },
      child: Directionality(
        textDirection: translator.activeLanguageCode == "ar"
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: MaterialApp(
            title: 'appNameWord'.tr(),
            debugShowCheckedModeBanner: false,
            navigatorKey: NavigationService.navigatorKey,
            theme: ThemeData(
              primaryColor: CommonFunctions.isTodayInRanges
                  ? AppColor.primary900LightEvent
                  : AppColor.primary900Light,
              scaffoldBackgroundColor: AppColor.scaffoldBackground,
              fontFamily: AppConfig.appFontType,
              useMaterial3: false,
              appBarTheme: const AppBarTheme(
                backgroundColor: AppColor.primary900Light,
                centerTitle: true,
              ),
              dropdownMenuTheme: const DropdownMenuThemeData(
                inputDecorationTheme: InputDecorationTheme(),
                menuStyle: MenuStyle(),
              ),
              inputDecorationTheme: InputDecorationTheme(
                counterStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                hintStyle: const TextStyle(
                  fontSize: 16,
                  color: Color(0xff71717A),
                  fontWeight: FontWeight.normal,
                ),
                errorStyle: const TextStyle(color: AppColor.error),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0xffD4D4D8),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: AppColor.primary800Light,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: AppColor.error,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: AppColor.error,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primary800Light,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  minimumSize: const Size(double.infinity, 34),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: AppColor.primary900Light,
                ),
              ),
              outlinedButtonTheme: OutlinedButtonThemeData(
                style: OutlinedButton.styleFrom(
                    foregroundColor: AppColor.primary900Light,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    minimumSize: const Size(double.infinity, 34),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: const BorderSide(
                      width: .8,
                      color: AppColor.primary900Light,
                    )),
              ),
            ),
            builder: EasyLoading.init(builder: BotToastInit()),
            navigatorObservers: [
              SentryNavigatorObserver(),
              BotToastNavigatorObserver(),
              FlutterUxcamNavigatorObserver(),
              MapnessRouteObserver(),
            ],
            localizationsDelegates: translator.delegates.toList()
              ..add(CountryLocalizations.delegate),
            // Android + iOS Delegates
            locale: translator.activeLocale,
            // Active locale
            supportedLocales: translator.locals(),
            // Locals list
            initialRoute: RouteName.bottomNavigation,
            routes: Routes.routes(),
          ),
        ),
      ),
    );
  }

  void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}
