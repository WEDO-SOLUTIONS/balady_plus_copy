import 'dart:io';

import 'package:balady_authorization/auth_package.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/remote_config.dart';

import 'package:balady_plus/app/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:balady_uikit/core/colors/app_colors_theme.dart';
import 'package:balady_uikit/core/colors/app_static_colors_theme.dart';
import 'package:balady_uikit/core/colors/colors_v2/app_colors_theme_v2.dart';
import 'package:balady_uikit/core/colorsV2/app_theme.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/typography/text_theme_styles.dart';
import 'package:balady_uikit/core/typography/text_theme_styles_v3.dart';
import 'package:bot_toast/bot_toast.dart'
    show BotToastInit, BotToastNavigatorObserver;
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/cubit/new_mini_app_logic_cubit.dart';
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
            // theme: ThemeData(
            //   primaryColor: CommonFunctions.isTodayInRanges ? AppColor.primary900LightEvent : AppColor.primary900Light,
            //   scaffoldBackgroundColor: AppColor.scaffoldBackground,
            //   fontFamily: AppConfig.appFontType,
            //   useMaterial3: false,
            //   appBarTheme: const AppBarTheme(
            //     backgroundColor: AppColor.primary900Light,
            //     centerTitle: true,
            //   ),
            //   dropdownMenuTheme: const DropdownMenuThemeData(
            //     inputDecorationTheme: InputDecorationTheme(),
            //     menuStyle: MenuStyle(),
            //   ),
            //   inputDecorationTheme: InputDecorationTheme(
            //     counterStyle: const TextStyle(
            //       fontSize: 16,
            //       color: Colors.black,
            //     ),
            //     hintStyle: const TextStyle(
            //       fontSize: 16,
            //       color: Color(0xff71717A),
            //       fontWeight: FontWeight.normal,
            //     ),
            //     errorStyle: const TextStyle(color: AppColor.error),
            //     contentPadding: const EdgeInsets.symmetric(
            //       vertical: 12,
            //       horizontal: 16,
            //     ),
            //     enabledBorder: OutlineInputBorder(
            //       borderSide: const BorderSide(
            //         color: Color(0xffD4D4D8),
            //         width: 1.5,
            //       ),
            //       borderRadius: BorderRadius.circular(6),
            //     ),
            //     focusedBorder: OutlineInputBorder(
            //       borderSide: const BorderSide(
            //         color: AppColor.primary800Light,
            //         width: 1.5,
            //       ),
            //       borderRadius: BorderRadius.circular(6),
            //     ),
            //     errorBorder: OutlineInputBorder(
            //       borderSide: const BorderSide(
            //         color: AppColor.error,
            //         width: 1.5,
            //       ),
            //       borderRadius: BorderRadius.circular(6),
            //     ),
            //     focusedErrorBorder: OutlineInputBorder(
            //       borderSide: const BorderSide(
            //         color: AppColor.error,
            //         width: 1.5,
            //       ),
            //       borderRadius: BorderRadius.circular(6),
            //     ),
            //   ),
            //   elevatedButtonTheme: ElevatedButtonThemeData(
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: AppColor.primary800Light,
            //       padding: const EdgeInsets.symmetric(
            //         horizontal: 16,
            //         vertical: 8,
            //       ),
            //       minimumSize: const Size(double.infinity, 34),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(8),
            //       ),
            //     ),
            //   ),
            //   textButtonTheme: TextButtonThemeData(
            //     style: TextButton.styleFrom(
            //       foregroundColor: AppColor.primary900Light,
            //     ),
            //   ),
            //   outlinedButtonTheme: OutlinedButtonThemeData(
            //     style: OutlinedButton.styleFrom(
            //         foregroundColor: AppColor.primary900Light,
            //         padding: const EdgeInsets.symmetric(
            //           horizontal: 16,
            //           vertical: 8,
            //         ),
            //         minimumSize: const Size(double.infinity, 34),
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(8),
            //         ),
            //         side: const BorderSide(
            //           width: .8,
            //           color: AppColor.primary900Light,
            //         )),
            //   ),
            // ),
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

class AppThemeColors {
  static const primary = AppColor.baladyDarkGreen2;

  // Light
  static const lightBackground = Color(0xFFF5F7FA);
  static const lightSurface = Color(0xFFF5F7FA);

  // Dark
  static const darkBackground = Color(0xFF00141C);
  static const darkSurface = Color(0xFF0B2733);

  static const error = Colors.red;

  static ThemeData buildLightTheme(String language) {
    final base = ThemeData.light(useMaterial3: false);

    const baseTextColor = Colors.black;
    final mutedTextColor = Colors.grey.shade600;

    return base.copyWith(
      brightness: Brightness.light,
      primaryColor: AppThemeColors.primary,
      scaffoldBackgroundColor: AppThemeColors.lightBackground,
      dividerColor: Colors.grey.shade300,

      // ------------------------------------------------------------
      // TEXT
      // ------------------------------------------------------------
      textTheme: base.textTheme.copyWith(
        bodyLarge: const TextStyle(color: baseTextColor),
        bodyMedium: const TextStyle(color: baseTextColor),
        bodySmall: TextStyle(color: mutedTextColor),
        titleLarge: const TextStyle(
          color: baseTextColor,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: const TextStyle(color: baseTextColor),
        labelLarge: const TextStyle(color: baseTextColor),
      ),

      iconTheme: const IconThemeData(color: baseTextColor),

      // ------------------------------------------------------------
      // APP BAR
      // ------------------------------------------------------------
      appBarTheme: const AppBarTheme(
        backgroundColor: AppThemeColors.lightSurface,
        foregroundColor: baseTextColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: baseTextColor,
        ),
      ),

      // ------------------------------------------------------------
      // BUTTONS
      // ------------------------------------------------------------
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppThemeColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppThemeColors.primary,
          side: const BorderSide(color: AppThemeColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppThemeColors.primary,
        ),
      ),

      // ------------------------------------------------------------
      // INPUTS
      // ------------------------------------------------------------
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: TextStyle(color: mutedTextColor),
        labelStyle: const TextStyle(color: baseTextColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: AppThemeColors.primary, width: 1.5),
        ),
      ),

      // ------------------------------------------------------------
      // NAVIGATION
      // ------------------------------------------------------------
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppThemeColors.lightSurface,
        selectedItemColor: AppThemeColors.primary,
        unselectedItemColor: mutedTextColor,
        showUnselectedLabels: true,
      ),

      tabBarTheme: TabBarTheme(
        labelColor: AppThemeColors.primary,
        unselectedLabelColor: mutedTextColor,
        indicatorColor: AppThemeColors.primary,
      ),

      // ------------------------------------------------------------
      // FEEDBACK
      // ------------------------------------------------------------
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),

      // ------------------------------------------------------------
      // EXTENSIONS
      // ------------------------------------------------------------
      extensions: [
        language == "ar" ? ThemeTextStyles.arabic() : ThemeTextStyles.english(),
        language == "ar"
            ? ThemeTextStylesV3.frutiger()
            : ThemeTextStylesV3.golos(),
        AppColorsThemeExt.palette(isDark: false),
        AppColorsThemeV2.palette(isDark: false),
        AppColorsThemeV3.palette(themes: BaladyAppThemes.light),
        AppStaticColorsThemeExt.palette(),
      ],
    );
  }

  static ThemeData buildDarkTheme(String language) {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppThemeColors.primary,
      onPrimary: Colors.white,
      secondary: AppThemeColors.primary,
      onSecondary: Colors.white,
      error: AppThemeColors.error,
      onError: Colors.white,
      surface: AppThemeColors.darkSurface,
      onSurface: Colors.white,
    );

    final base = ThemeData.dark(useMaterial3: false);

    return base.copyWith(
      colorScheme: colorScheme,
      primaryColor: colorScheme.primary,
      scaffoldBackgroundColor: AppThemeColors.darkBackground,
      dividerColor: Colors.grey.shade700,
      textTheme: base.textTheme.apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF0F2E3B),
        labelStyle: TextStyle(color: colorScheme.onSurface),
        hintStyle: TextStyle(color: Colors.grey.shade400),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: Colors.grey.shade400,
      ),
      extensions: [
        language == "ar" ? ThemeTextStyles.arabic() : ThemeTextStyles.english(),
        language == "ar"
            ? ThemeTextStylesV3.frutiger()
            : ThemeTextStylesV3.golos(),
        AppColorsThemeExt.palette(isDark: true),
        AppColorsThemeV2.palette(isDark: true),
        AppColorsThemeV3.palette(themes: BaladyAppThemes.dark),
        AppStaticColorsThemeExt.palette(),
      ],
    );
  }
}
