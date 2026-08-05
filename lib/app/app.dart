import 'package:balady_authorization/auth_package.dart';
import 'package:balady_design_system/theme/app_theme.dart';
import 'package:balady_plus/app/core/utils/constants/remote_config.dart';
import 'package:balady_plus/app/features/accecipilities/accessibility_controller.dart';
import 'package:balady_plus/app/features/accecipilities/balady_theme_controller.dart';
import 'package:balady_plus/app/features/delegators/presentation/delegators_cubit/delegators_cubit.dart';
import 'package:balady_plus/app/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/cubit/new_mini_app_logic_cubit.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:country_picker/country_picker.dart' show CountryLocalizations;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocProvider;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:localize_and_translate/localize_and_translate.dart' show Translation, translator;
import 'package:mapness/entry_point.dart';
import 'package:mapness/features/balady_analytics/balady_analytics.dart';
import 'package:mapness/features/stream_audio/ui/pages/stream_audio_screen.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import './core/dependency_injection/dependency_injection_exports.dart' show sl;
import './core/services/services_exports.dart' show NavigationService;
import './core/utils/utils_exports.dart' show RouteName;
import 'core/utils/routes.dart';
import 'features/entry_point/presentation/cubit/auth_cubit.dart';
import 'features/location/presentation/bloc/location_bloc.dart';

final GlobalKey<AppWidgetState> materialAppKey = GlobalKey();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Color(0x00000000),
        systemNavigationBarDividerColor: Color(0x00000000),
      ),
    );

    // Idempotent: mapness `entry_point` calls configure too, first one wins.
    BaladyAnalytics.instance.configure(mode: BaladyAnalyticsMode.parse(RemoteConfig.baladyAnalyticsMode));

    return MultiProvider(
      providers: [
        BlocProvider.value(value: sl<LocationCubit>()),
        BlocProvider.value(value: sl<SplashCubit>()),
        BlocProvider<NewMiniAppLogicCubit>.value(value: sl<NewMiniAppLogicCubit>()),
        // Add AccessibilityController to providers
        ChangeNotifierProvider(create: (_) => AccessibilityController()),
        BlocProvider<DelegatorsCubit>.value(value: sl<DelegatorsCubit>()),
      ],
      child: BlocProvider<EntryPointCubit>.value(
        value: sl<EntryPointCubit>(),
        child: BaladyAuthorizationBloc(child: AppWidget(key: materialAppKey)),
      ),
    );
  }
}

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

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
    return Consumer<AccessibilityController>(
      builder: (context, controller, child) {
        final grayscaleFilter = controller.grayscale
            ? const ColorFilter.matrix([
                0.2126,
                0.7152,
                0.0722,
                0,
                0,
                0.2126,
                0.7152,
                0.0722,
                0,
                0,
                0.2126,
                0.7152,
                0.0722,
                0,
                0,
                0,
                0,
                0,
                1,
                0,
              ])
            : null;

        return Consumer<BaladyThemeNotifier>(
          builder: (context, themeController, child) {
            return Directionality(
              textDirection: translator.activeLanguageCode == "ar" ? TextDirection.rtl : TextDirection.ltr,
              child: Consumer<BaladyThemeNotifier>(
                builder: (context, themeController, child) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(controller.textScale)),
                    child: MaterialApp(
                      title: 'appNameWord'.tr(),
                      debugShowCheckedModeBanner: false,
                      navigatorKey: NavigationService.navigatorKey,
                      theme: myLightTheme,
                      darkTheme: myDarkTheme,
                      themeMode: themeController.isDarkMode ? ThemeMode.dark : ThemeMode.light,
                      builder: (context, child) {
                        final botToastBuilder = BotToastInit();
                        final easyLoadingBuilder = EasyLoading.init(builder: botToastBuilder);
                        final builtChild = easyLoadingBuilder(context, child);

                        // [BUG FIX]: The old code accidentally excluded the StreamAudio wrapper when grayscale was disabled:
                        // if (grayscaleFilter == null) return builtChild;
                        // return ColorFiltered(
                        //   colorFilter: grayscaleFilter,
                        //   child: StreamAudio(child: builtChild),
                        // );

                        // [NEW CODE]: We first wrap builtChild with StreamAudio so the floating audio player
                        // is always present in the widget tree, regardless of the grayscale filter.
                        final streamAudioChild = Material(
                          type: MaterialType.transparency,
                          child: StreamAudio(child: builtChild),
                        );

                        if (grayscaleFilter == null) return streamAudioChild;

                        return ColorFiltered(colorFilter: grayscaleFilter, child: streamAudioChild);
                      },
                      navigatorObservers: [
                        SentryNavigatorObserver(),
                        BotToastNavigatorObserver(),
                        BaladyAnalyticsNavigatorObserver(),
                        MapnessRouteObserver(),
                      ],
                      localizationsDelegates: translator.delegates.toList()..add(CountryLocalizations.delegate),
                      locale: translator.activeLocale,
                      supportedLocales: translator.locals(),
                      initialRoute: RouteName.bottomNavigation,
                      routes: Routes.routes(),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}
