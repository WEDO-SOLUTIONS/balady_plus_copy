import 'dart:io';

import 'package:balady_authorization/auth_package.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/remote_config.dart';

import 'package:balady_plus/app/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/cubit/new_mini_app_logic_cubit.dart';
import 'package:bot_toast/bot_toast.dart'
    show BotToastInit, BotToastNavigatorObserver;
import 'package:country_picker/country_picker.dart' show CountryLocalizations;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocProvider;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation, translator;
import 'package:mapness/entry_point.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import './core/dependency_injection/dependency_injection_exports.dart' show sl;
import './core/services/services_exports.dart' show NavigationService;
import './core/utils/utils_exports.dart'
    show AppColor, AppConfig, RouteName, BaladyRouteObserver;
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
        ChangeNotifierProvider(create: (_) => ThemeController()),

        BlocProvider.value(value: sl<LocationCubit>()),
        BlocProvider.value(value: sl<SplashCubit>()),
        // BlocProvider.value(value: sl<HomeMiniAppsListCubit>()),
        BlocProvider<NewMiniAppLogicCubit>.value(
          value: sl<NewMiniAppLogicCubit>(),
        )
        ),
        ChangeNotifierProvider(
          create: (_) => AccessibilityController(),
        ),
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

        return ColorFiltered(
          colorFilter: grayscaleFilter ??
              const ColorFilter.mode(Colors.transparent, BlendMode.srcOver),
          child: GestureDetector(
            onTap: () {
              if (Platform.isIOS) hideKeyboard(context);
            },
            child: Directionality(
              textDirection: translator.activeLanguageCode == "ar"
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(controller.textScale),
                ),
                child: MaterialApp(

                  title: 'appNameWord'.tr(),
                  debugShowCheckedModeBanner: false,
                  navigatorKey: NavigationService.navigatorKey,
                  theme: _buildLightTheme(controller),
                  darkTheme: _buildDarkTheme(controller),
                  themeMode:
                      controller.darkMode ? ThemeMode.dark : ThemeMode.light,
                  builder: (context, child) {
                    final botToastBuilder = BotToastInit();
                    final easyLoadingBuilder =
                        EasyLoading.init(builder: botToastBuilder);
                    return easyLoadingBuilder(context, child);
                  },
                  navigatorObservers: [
                    SentryNavigatorObserver(),
                    BotToastNavigatorObserver(),
                    FlutterUxcamNavigatorObserver(),
                    MapnessRouteObserver(),
                  ],
                  localizationsDelegates: translator.delegates.toList()
                    ..add(CountryLocalizations.delegate),
                  locale: translator.activeLocale,
                  supportedLocales: translator.locals(),
                  initialRoute: RouteName.bottomNavigation,
                  routes: Routes.routes(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  ThemeData _buildLightTheme(AccessibilityController controller) {
    final primaryColor = CommonFunctions.isTodayInRanges
        ? AppColor.primary900LightEvent
        : AppColor.primary900Light;

    final scaffoldColor =
        controller.highContrast ? Colors.black : AppColor.scaffoldBackground;

    final textColor = controller.highContrast ? Colors.white : Colors.black;

    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: scaffoldColor,
      fontFamily: AppConfig.appFontType,
      useMaterial3: false,
      appBarTheme: AppBarTheme(
        backgroundColor: controller.highContrast ? Colors.black : primaryColor,
        centerTitle: true,
      ),
      dropdownMenuTheme: const DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(),
        menuStyle: MenuStyle(),
      ),
      inputDecorationTheme:
          _buildInputDecorationTheme(controller, primaryColor),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              controller.highContrast ? Colors.white : AppColor.primary800Light,
          foregroundColor:
              controller.highContrast ? Colors.black : Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 16 * 1.0, // Apply tap target scaling
            vertical: 8 * 1.0,
          ),
          minimumSize: Size(
            double.infinity,
            34 * controller.tapTargetSize, // Apply tap target scaling
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor:
              controller.highContrast ? Colors.white : primaryColor,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor:
              controller.highContrast ? Colors.white : primaryColor,
          padding: const EdgeInsets.symmetric(
            horizontal: 16 * 1.0,
            vertical: 8 * 1.0,
          ),
          minimumSize: Size(
            double.infinity,
            34 * controller.tapTargetSize,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: BorderSide(
            width: .8,
            color: controller.highContrast ? Colors.white : primaryColor,
          ),
        ),
      ),
      textTheme: TextTheme(
        // Apply text scaling through getModifiedTextStyle
        bodyLarge: controller.getModifiedTextStyle(
          TextStyle(
            fontSize: 16,
            color: textColor,
          ),
        ),
        bodyMedium: controller.getModifiedTextStyle(
          TextStyle(
            fontSize: 14,
            color: textColor,
          ),
        ),
        titleLarge: controller.getModifiedTextStyle(
          TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        titleMedium: controller.getModifiedTextStyle(
          TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        // Add more text styles as needed
      ),
    );
  }

  ThemeData _buildDarkTheme(AccessibilityController controller) {
    final primaryColor = CommonFunctions.isTodayInRanges
        ? AppColor.primary900LightEvent
        : AppColor.primary900Light;

    final scaffoldColor =
        controller.highContrast ? Colors.black : Colors.grey.shade900;

    final textColor =
        controller.highContrast ? Colors.white : Colors.grey.shade200;

    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: scaffoldColor,
      fontFamily: AppConfig.appFontType,
      useMaterial3: false,
      appBarTheme: AppBarTheme(
        backgroundColor: controller.highContrast ? Colors.black : primaryColor,
        centerTitle: true,
      ),
      dropdownMenuTheme: const DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(),
        menuStyle: MenuStyle(),
      ),
      inputDecorationTheme:
          _buildInputDecorationTheme(controller, primaryColor),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              controller.highContrast ? Colors.white : AppColor.primary800Light,
          foregroundColor:
              controller.highContrast ? Colors.black : Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 16 * 1.0,
            vertical: 8 * 1.0,
          ),
          minimumSize: Size(
            double.infinity,
            34 * controller.tapTargetSize,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor:
              controller.highContrast ? Colors.white : primaryColor,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor:
              controller.highContrast ? Colors.white : primaryColor,
          padding: const EdgeInsets.symmetric(
            horizontal: 16 * 1.0,
            vertical: 8 * 1.0,
          ),
          minimumSize: Size(
            double.infinity,
            34 * controller.tapTargetSize,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: BorderSide(
            width: .8,
            color: controller.highContrast ? Colors.white : primaryColor,
          ),
        ),
      ),
      textTheme: TextTheme(
        bodyLarge: controller.getModifiedTextStyle(
          TextStyle(
            fontSize: 16,
            color: textColor,
          ),
        ),
        bodyMedium: controller.getModifiedTextStyle(
          TextStyle(
            fontSize: 14,
            color: textColor,
          ),
        ),
        titleLarge: controller.getModifiedTextStyle(
          TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        titleMedium: controller.getModifiedTextStyle(
          TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }

  InputDecorationTheme _buildInputDecorationTheme(
    AccessibilityController controller,
    Color primaryColor,
  ) {
    final borderColor =
        controller.highContrast ? Colors.white : const Color(0xffD4D4D8);

    final errorColor =
        controller.highContrast ? Colors.redAccent : AppColor.error;

    final focusedBorderColor =
        controller.highContrast ? Colors.blueAccent : AppColor.primary800Light;

    return InputDecorationTheme(
      counterStyle: controller.getModifiedTextStyle(
        const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
      hintStyle: controller.getModifiedTextStyle(
        const TextStyle(
          fontSize: 16,
          color: Color(0xff71717A),
          fontWeight: FontWeight.normal,
        ),
      ),
      errorStyle: controller.getModifiedTextStyle(
        TextStyle(color: errorColor),
      ),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 16,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: borderColor,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: focusedBorderColor,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: errorColor,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: errorColor,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
    final themeController = context.watch<ThemeController>();

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
            theme:
                AppThemeColors.buildLightTheme(translator.activeLanguageCode),

            darkTheme:
                AppThemeColors.buildDarkTheme(translator.activeLanguageCode),

            themeMode: themeController.themeMode,

            builder: EasyLoading.init(builder: BotToastInit()),
            navigatorObservers: [
              SentryNavigatorObserver(),
              BotToastNavigatorObserver(),
              FlutterUxcamNavigatorObserver(),
              MapnessRouteObserver(),
              BaladyRouteObserver(),
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

class AppTheme {
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    useMaterial3: false,
    fontFamily: AppConfig.appFontType,
    primaryColor: CommonFunctions.isTodayInRanges
        ? AppColor.primary900LightEvent
        : AppColor.primary900Light,
    scaffoldBackgroundColor: AppColor.scaffoldBackground,
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
        ),
      ),
    ),
  );

  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: false,
    fontFamily: AppConfig.appFontType,
    scaffoldBackgroundColor: const Color(0xFF0F172A),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF020617),
      centerTitle: true,
    ),
    colorScheme: const ColorScheme.dark(
      primary: AppColor.primary800Light,
      error: AppColor.error,
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: const TextStyle(
        fontSize: 16,
        color: Color(0xffA1A1AA),
      ),
      errorStyle: const TextStyle(color: AppColor.error),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Color(0xff3F3F46),
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
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primary800Light,
      ),
    ),
  );
}

class ThemeController extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isDark => _themeMode == ThemeMode.dark;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
