import 'dart:io';

import 'package:balady_plus/app/core/utils/constants/remote_config.dart';
import 'package:balady_plus/app/features/_shared_features/notifications_count/cubit_notification_count/notifications_item_cubit.dart';
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
import 'package:mapness/entry_point.dart';
import 'package:provider/provider.dart';

import './core/dependency_injection/dependency_injection_exports.dart' show sl;
import './core/services/services_exports.dart' show NavigationService;
import './core/utils/utils_exports.dart'
    show
        AppColor,
        AppConfig,
        AppRouter,
        CommonFunctions,
        EtmamRoutesNames,
        RouteName;
import '../etmam_app/features/etmam_entry_point/presentation/cubit/etmam_entry_point_cubit.dart';
import 'core/utils/routes.dart';
import 'features/entry_point/presentation/cubit/auth_cubit.dart';
import 'features/location/presentation/bloc/location_bloc.dart';
import 'features/profile_features/dashboard/presentation/bloc/dashboard_bloc.dart';

final GlobalKey<_AppWidgetState> materialAppKey = GlobalKey();

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
        ChangeNotifierProvider(
          create: (BuildContext context) =>
              MapViewModel(layersRepositories: sl()),
        ),
        BlocProvider.value(value: sl<EtmamEntryPointCubit>()),
        BlocProvider.value(value: sl<LocationCubit>()),
        BlocProvider<DashboardBloc>(
          create: (_) => sl<DashboardBloc>()..add(DashboardEventInitial()),
        ),
      ],
      child: BlocProvider<EntryPointCubit>.value(
          value: sl<EntryPointCubit>()..onLoadingApp(),
          child: AppWidget(
            key: materialAppKey,
          )),
    );
  }
}

class AppWidget extends StatefulWidget {
  const AppWidget({
    super.key,
  });

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
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
            MapnessRouteObserver(),
          ],
          localizationsDelegates: translator.delegates.toList()
            ..add(CountryLocalizations.delegate), // Android + iOS Delegates
          locale: translator.activeLocale, // Active locale
          supportedLocales: translator.locals(), // Locals list
          initialRoute: RouteName.splash,
          routes: Routes.routes(),
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
