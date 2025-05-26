import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:balady_authorization/auth_package.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/remote_config.dart';
import 'package:balady_plus/app/features/force_update/presentation/core/force_update_cubit.dart';
import 'package:balady_plus/app/features/ekram/domain/entities/deceased_transport_requests/verify_deceased_params.dart';
import 'package:balady_plus/app/features/ekram/presentation/blocs/ekram_request_transportation_bloc/ekram_request_transportation_bloc.dart';
import 'package:balady_plus/app/features/map_page/presentation/mvvm/map_view_model.dart';
import 'package:balady_plus/app/features/splash/data/splash_remote_data_source.dart';
import 'package:balady_plus/app/features/splash/presentation/cubit/splash_cubit.dart';
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
import '../etmam_app/features/etmam_entry_point/presentation/cubit/etmam_entry_point_cubit.dart';
import 'core/utils/routes.dart';
import 'features/entry_point/presentation/cubit/auth_cubit.dart';
import 'features/location/presentation/bloc/location_bloc.dart';
import 'features/profile_features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../app/core/utils/utils_exports.dart' show EnvType;
import 'package:flutter_insider/flutter_insider.dart';
import 'package:flutter_insider/enum/InsiderCallbackAction.dart';
// import 'baldy';

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
        ChangeNotifierProvider(
          create: (BuildContext context) =>
              MapViewModel(layersRepositories: sl()),
        ),
        BlocProvider.value(value: sl<EtmamEntryPointCubit>()),
        BlocProvider.value(value: sl<LocationCubit>()),
        BlocProvider.value(value: sl<SplashCubit>()),
        BlocProvider.value(value: sl<ForceUpdateCubit>()),
        BlocProvider<DashboardBloc>(
          create: (_) => sl<DashboardBloc>()..add(DashboardEventInitial()),
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
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  @override
  void initState() {
    super.initState();
    initInsider();
    initDeepLinks();
  }

  Future initInsider() async {
    if (!mounted) return;

    // Call in async method.


            await FlutterInsider.Instance.init(
        "baladyapp", "group.movingViolations",
        (int type, dynamic data) {
      switch (type) {
            case InsiderCallbackAction.NOTIFICATION_OPEN:
              print('[INSIDER][NOTIFICATION_OPEN]: $data');
              break;
            case InsiderCallbackAction.TEMP_STORE_CUSTOM_ACTION:
              print('[INSIDER][TEMP_STORE_CUSTOM_ACTION]: $data');
              break;
            default:
              print("[INSIDER][InsiderCallbackAction]: Unregistered Action!");
              break;
          }
        });


    // This is an utility method, if you want to handle the push permission in iOS own your own you can omit the following method.
    FlutterInsider.Instance.registerWithQuietPermission(false);
  }

  void callback() {}

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();
    final appLink = await _appLinks.getInitialLink();

    _linkSubscription = _appLinks.uriLinkStream.listen((uri) async {
      try {

        /// TODO: Need Move this lojec after the aap get the profile data
        /// TODO: need chick if the user not login in make this action
        Future.delayed(const Duration(seconds: 2)).then((test){
          // String url = uri.toString();
          final decodeFull = Uri.decodeFull(uri.toString());
          final parse = Uri.parse(decodeFull);
          final url = Uri.parse(parse.fragment);

          if(url.path.contains("ekram/mobile/transport")) {
            if(CommonProperties.userInfo != null) {
              Map data = url.queryParameters;
              var bloc = EkramRequestTransportationBloc(
                getCities: sl(),
                getRequestDetails: sl(),
                getHospitals: sl(),
                getNationalities: sl(),
                applyDeceasedTransport: sl(),
                getCemeteryTypesLookUp: sl(),
              );
              bloc.add(
                VerifyDeceasedEvent(
                  params: VerifyDeceasedParams(
                    identityNumber: data['identityNumber'] ?? '',
                    identityType: int.tryParse(data['identityType']) ?? 0 ,
                    birthDate: data['birthDate'] ?? '',
                    submitterBirthDate: CommonProperties.userInfo!.getHijriBirthDate(),
                    submitterMobile: CommonProperties.userInfo!.getPhone(),
                  ),
                  fromDeepLink:  true,
                ),
              );
            }
          }

        });
        print('_linkSubscription $uri');
      } catch (e) {
        print(e);
      }
    });
  }

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
              primaryColor: AppColor.primary900Light,
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
