// ignore_for_file: prefer_expression_function_bodies

import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:balady_plus/mini_apps_engine/data/models/mini_app_model.dart';
import 'package:balady_plus/mini_apps_engine/presentation/bloc/home_mini_apps_list_bloc/home_mini_apps_list_cubit.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colors/app_static_colors_theme.dart';
import 'package:balady_uikit/core/colorsV2/app_theme.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
// ignore: depend_on_referenced_packages
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dgis_map/library.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_insider/enum/InsiderCallbackAction.dart';
import 'package:flutter_insider/flutter_insider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/_features/common/widgets/eager_init_widget.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/app/auto_route/others/routes_observer.dart';
import 'package:mapness/app/auto_route/poi_card_ext.dart';
import 'package:mapness/entities/quick_filters/quick_filter.dart';
import 'package:mapness/entities/search/models/search_history.dart';
import 'package:mapness/features/advert_metrics/advert_metrics.dart';
import 'package:mapness/features/app_analytics/app_analytics.dart';
import 'package:mapness/features/car/car_enable_free_roam.dart';
import 'package:mapness/features/cityscape/cityscape.dart';
import 'package:mapness/features/favourites/data/models/favorite_cache_item.dart';
import 'package:mapness/features/favourites/mappers/favourite_item_mapper.dart';
import 'package:mapness/features/favourites/providers/favourite_cache.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/features/parking_spot/parking_manage.dart';
import 'package:mapness/features/path_nav/lib/extensions.dart';
import 'package:mapness/features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/features/search/providers/search_region.dart' show initializeSearchRegionServiceProvider;
import 'package:mapness/features/share_eta/helpers/utils.dart';
import 'package:mapness/features/stories/models/story_types.dart';
import 'package:mapness/features/stories/providers/stories_open_state.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/l10n/generated/app_localizations_ar.dart';
import 'package:mapness/l10n/generated/app_localizations_en.dart';
import 'package:mapness/pages/debug_overlay/debug_overlay.dart';
import 'package:mapness/pages/path_nav/path_nav_page.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/deeplink_functions.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/lib/urbi_metrics_utils.dart';
import 'package:mapness/shared/providers/analytic/bss_common.dart';
import 'package:mapness/shared/providers/analytic/bss_dio.dart';
import 'package:mapness/shared/providers/analytic/bss_service.dart';
import 'package:mapness/shared/providers/analytic/models/bss_request.dart';
import 'package:mapness/shared/providers/analytic/models/payload/bss_payload.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/base_dio.dart';
import 'package:mapness/shared/providers/debug_state.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/hive.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/rubric_marker_type_mapper.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';
import 'package:mapness/shared/providers/media_query.dart';
import 'package:mapness/shared/providers/urbi_analytics.dart';
import 'package:mapness/shared/providers/vendor_config.dart';
import 'package:mapness/shared/ui/loading/loading_overlay.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';
import 'package:mapness/shared/utils/app_config_loader.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:mapness/widgets/scopes/global_scopes.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:provider/provider.dart' as provider;
import 'package:sheetify/sheetify.dart';

import 'features/saudi_national_day/saudi_national_day.dart';
import 'features/search/providers/search.dart';
import 'features/search/ui/search_scope.dart';

Mixpanel? mixpanel;

class MapnessRouteObserver extends RouteObserver<ModalRoute<void>> {
  static final MapnessRouteObserver _instance = MapnessRouteObserver._internal();

  factory MapnessRouteObserver() => _instance;

  MapnessRouteObserver._internal();
}

class MapnessProviderScope extends StatelessWidget {
  const MapnessProviderScope({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) => ProviderScope(
        child: EagerInitWidget(
          child: Consumer(
            builder: (context, ref, child) {
              final language = ref.watch(appLanguageProvider);
              final localizations = language == Language.arabic ? AppLocalizationsAr() : AppLocalizationsEn();
              // Initialize Saudi National Day provider to start the timer
              ref
                ..watch(saudiNationalDayProvider)
                // Initialize Cityscape provider to listen remote config
                ..watch(cityscapeProvider);

              return provider.MultiProvider(
                providers: [
                  provider.Provider<AppLocalizations>.value(
                    value: localizations,
                  ),
                ],
                child: child,
              );
            },
            child: child,
          ),
        ),
      );
}

class MapnessEntryPoint extends ConsumerStatefulWidget {
  const MapnessEntryPoint({
    required this.mapCreated,
    super.key,
  });

  final void Function(DgisMapController) mapCreated;

  @override
  ConsumerState<MapnessEntryPoint> createState() => _MapnessEntryPointState();
}

class _MapnessEntryPointState extends ConsumerState<MapnessEntryPoint> {
  late OverlayEntry? _debugOverlay;
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  ProviderSubscription? _locationListener;
  StreamSubscription? _navigationEventsListener;

  @override
  void initState() {
    super.initState();
    logger.init();
    initMixpanel();
    initDeepLinks();
    listenNavigationEvents();
    checkConnection();
    if (!Platform.isIOS) {
      PersistentSafeAreaBottom.startObserving();
    }
    ref.read(appAnalyticsProvider).deviceTypeDetected();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Update MediaQueryInfoProvider with the initial MediaQuery
      ref.read(mediaQueryInfoProvider.notifier).update(MediaQuery.of(context));
      // Init camera position point
      await initCameraPositionPoint();
      // TODO(Scroollocker): Disable this feature. Because need to research fail restore cases
      // restoreState();
      await clearCache();
      // TODO(wultriel): Disable this feature. Because need to research fail restore cases
      // checkNavigationState();
      // Initialization of BSS and Search Region singleton services
      await _initBssService();
      await ref.read(initializeSearchRegionServiceProvider.future);
      final track = ref.read(urbiAnalyticsProvider).track;
      await AdvancedMetrics.instance.stopMeasureStartup(track: track);
      await AdvancedMetrics.instance.sendPreviousSessionBatteryUsage(track: track);
      await AdvancedMetrics.instance.startMeasureBattery();
      await ref.read(cityscapeProvider.notifier).initializeGlobalMarker();
    });

    // call the openAppLink when user click on notification have deep link
    FirebaseMessaging.instance.getInitialMessage().then(
      (RemoteMessage? message) {
        if (message != null && message.data.containsKey('url')) {
          final url = message.data['url'];
          openAppLink(url);
          return;
        }
      },
    );

    initInsider();
  }

  Future<void> checkConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      ref.read(appAnalyticsProvider).networkConnectionType(type: ConnectivityResult.mobile.name);
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      ref.read(appAnalyticsProvider).networkConnectionType(type: ConnectivityResult.wifi.name);
    }
  }

  @override
  void dispose() {
    if (!Platform.isIOS) {
      PersistentSafeAreaBottom.stopObserving();
    }
    _linkSubscription?.cancel();
    _locationListener?.close();
    _navigationEventsListener?.cancel();

    super.dispose();
  }

  Future<void> _initBssService() async {
    // Initialize BSS service with required dependencies
    final dio = await ref.read(bssDioProvider.future);
    final common = await ref.read(bssCommonProvider.future);
    final dgisControllerNotifier = ref.read(dgisControllerProvider.notifier);

    BssService.instance.init(
      dio: dio,
      common: common,
      visibleRectStream: dgisControllerNotifier.visibleRectSubject,
    );
  }

  Future<void> restoreState() async {
    final state = ref.read(sharedPrefsProvider).getString(MapnessConstants.navigatorStateKey);
    final type = ref.read(sharedPrefsProvider).getString(MapnessConstants.navigatorStateTypeKey);
    if (state != null) {
      final routeSearchOptions = RouteSearchOptionsMessageExt.fromString(type!);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final location = ref.read(locationProvider);
        if (location != null) {
          ref.read(appRouterProvider).push(
                PathNavRoute(
                  navType: routeSearchOptions,
                  initAction: PathNavPageInitAction.restoreFromState,
                ),
              );
        } else {
          _locationListener = ref.listenManual<Position?>(locationProvider, (_, next) {
            if (next != null) {
              _locationListener?.close();
              ref.read(appRouterProvider).push(
                    PathNavRoute(
                      navType: RouteSearchOptionsMessageExt.fromString(type),
                      initAction: null,
                    ),
                  );
            }
          });
        }
      });
    }
  }

  Future<void> _updateGlobalMarker(WidgetRef ref) async {
    final cityscapeEnabled = ref.read(cityscapeProvider);
    final selectedMarker = ref.read(selectedMarkerProvider);
    final notifier = ref.read(cityscapeProvider.notifier);

    if (cityscapeEnabled && selectedMarker == null) {
      await notifier.showGlobalMarker();
    } else {
      await notifier.hideGlobalMarker();
    }
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(appLanguageProvider);
    final direction = ref.watch(uiDirectionProvider);
    final isNationalDay = ref.watch(saudiNationalDayProvider);
    ref.listen<bool>(cityscapeProvider, (prev, next) {
      _updateGlobalMarker(ref);
    });

    ref.listen<dynamic>(selectedMarkerProvider, (prev, next) {
      _updateGlobalMarker(ref);
    });

    ref
      // listen for changes in car connection state. But do not rebuild widget
      ..listen(carEnableFreeRoamProvider, (previous, next) {})
      // listen for changes in debug state provider to show/hide the debug overlay
      ..listen(debugStateProvider, (previous, next) {
        if (!next || (previous ?? false)) {
          return;
        }

        _debugOverlay = OverlayEntry(
          builder: (context) => Theme(
            data: Theme.of(context),
            child: const ProviderScope(
              child: DebugOverlay(),
            ),
          ),
        );
        Overlay.of(context, rootOverlay: true).insert(_debugOverlay!);
      });

    return DefaultTextHeightBehavior(
      textHeightBehavior: const TextHeightBehavior(leadingDistribution: TextLeadingDistribution.even),
      child: Directionality(
        textDirection: direction,
        child: Consumer(
          builder: (context, ref, child) {
            return MaterialApp.router(
              routerConfig: ref.read(appRouterProvider).config(
                    navigatorObservers: () => [
                      RoutesObserver(ref: ref),
                    ],
                  ),
              theme: ThemeData(
                scaffoldBackgroundColor: Colors.transparent,
                dividerColor: Colors.grey[400],
                useMaterial3: false,
                extensions: <ThemeExtension<dynamic>>[
                  if (language == Language.arabic) ThemeTextStyles.arabic() else ThemeTextStyles.english(),
                  if (language == Language.arabic) ThemeTextStylesV3.frutiger() else ThemeTextStylesV3.golos(),
                  AppColorsThemeExt.palette(isDark: false),
                  AppColorsThemeV2.palette(isDark: false),
                  AppColorsThemeV3.palette(
                    themes: isNationalDay ? BaladyAppThemes.saudiDay : BaladyAppThemes.light,
                  ),
                  AppStaticColorsThemeExt.palette(),
                ],
              ),
              builder: (context, child) => child != null
                  ? LoadingOverlay(
                      child: ToastOverlay(
                        child: GlobalScopes(
                          child: child,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              locale: language.locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              debugShowCheckedModeBanner: false,
            );
          },
        ),
      ),
    );
  }

  Future<void> initCameraPositionPoint() async {
    final controller = await ref.read(dgisControllerProvider.future);

    try {
      await controller.setCameraPositionPoint(CameraPositionPointMessage(x: 0.5, y: 0.5));
    } catch (ex) {
      logger.log('Error setting camera position point: $ex', logLevel: MapnessLogLevel.error);
    }
  }

  Future<void> clearCache() async {
    final controller = await ref.read(dgisControllerProvider.future);
    await controller.stopNavigation();
    await ref.read(selectedMarkerProvider.notifier).removeAllMarkers();
    ref.read(layersControlsProvider.notifier).updateLayerInfo();
    final poiBox = await ref.read(hiveProvider(MapnessConstants.poiDataBoxName).future);
    await poiBox.clear();
  }

  Future<void> initMixpanel() async {
    logger.log('Initializing Mixpanel...');
    mixpanel = await Mixpanel.init(
      '2d045d85e25087812e92c62b84d6fbc3',
      trackAutomaticEvents: true,
    );
    mixpanel?.setLoggingEnabled(true);
    logger.log('Mixpanel initialized successfully');

    final config = FlutterUxConfig(
      enableAdvancedGestureRecognition: true,
      enableCrashHandling: true,
      enableMultiSessionRecord: true,
      enableNetworkLogging: true,
      userAppKey: '2w1otnta9bvvhzo',
      enableAutomaticScreenNameTagging: false,
    );
    await FlutterUxcam.startWithConfiguration(config);
    logger.log('UXCam started with configuration');
  }

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();

    final appLink = await _appLinks.getInitialLink();

    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      if (kDebugMode) {
        logger.log('Deep link received: $uri');
      }
      openAppLink(uri, isFirstRun: appLink != null);
    });
  }

  Future<void> listenNavigationEvents() async {
    final dgisController = await ref.read(dgisControllerProvider.future);
    _navigationEventsListener = dgisController.navigationEvents.listen((event) async {
      final segments = ref.read(appRouterProvider).currentSegments;

      final currentRouteName = segments.isEmpty ? null : segments.last.name;

      final isNavPage = currentRouteName == PathNavRoute.name;
      final navigation = event == NavigationEvent.navigation || event == NavigationEvent.routeSearch;
      final routeSearchOptions = (await dgisController.getCurrentNavigationState()).routeSearchOptions;
      final isFreeroam = navigation && routeSearchOptions == null;
      if (navigation && !isFreeroam && !isNavPage) {
        await ref.read(appRouterProvider).pushAndPopUntil(
              PathNavRoute(
                navType: routeSearchOptions ?? RouteSearchOptionsMessage.car,
                initAction: null,
              ),
              predicate: (route) => route.settings.name == BottomMenuRoute.name,
            );
      }
    });
  }

  Future<void> _delayIfFirstRun(
      {required bool isFirstRun, Duration duration = const Duration(milliseconds: 300)}) async {
    // TODO(ilyasov): Remove this delay after implementing the new poi bottom sheet
    if (isFirstRun) {
      await Future.delayed(duration);
    }
  }

  // implement insider deep link for ios

  Future initInsider() async {
    if (!mounted) return;
    // FIXME-INSIDER: Please change with your partner name and app group.
    await FlutterInsider.Instance.init("baladyapp", "group.movingViolations", (int type, dynamic data) {
      switch (type) {
        case InsiderCallbackAction.NOTIFICATION_OPEN:
          // if(Platform.isIOS) {
          if (data != null && data.containsKey('url')) {
            final url = Uri.parse(data['url']);
            openAppLink(url);
            return;
          }

          //  }
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
    await FlutterInsider.Instance.setActiveForegroundPushView();
    await FlutterInsider.Instance.registerWithQuietPermission(false);
  }

  Future<void> openAppLink(Uri uri, {bool isFirstRun = false}) async {
    await initCameraPositionPoint();
    final decodeFull = Uri.decodeFull(uri.toString());
    final parse = Uri.parse(decodeFull);
    final url = parse.fragment.isNotEmpty ? Uri.parse(parse.fragment) : parse;

    final momrahId = url.queryParameters[BaldayDeeplink.momrahIdKey];
    final latString = url.queryParameters[BaldayDeeplink.latitudeKey];
    final lonString = url.queryParameters[BaldayDeeplink.longitudeKey];
    final type = url.queryParameters[BaldayDeeplink.typeKey];
    final objectId = url.queryParameters[BaldayDeeplink.dgisObjectIdKey];
    final streamId = url.queryParameters[BaldayDeeplink.streamId];
    final tokenId = url.queryParameters[BaldayDeeplink.tokenId];
    final homeWidget = url.queryParameters[BaldayDeeplink.homeWidget];
    final serviceKey = url.path; //queryParameters[BaldayDeeplink.serviceKey];
    final path = url.queryParameters[BaldayDeeplink.miniAppPath];
    final dtId = url.queryParameters[BaldayDeeplink.miniAppItemId];

    double? latitude;
    double? longitude;

    if (latString != null && lonString != null) {
      latitude = double.tryParse(latString);
      longitude = double.tryParse(lonString);

      // So that we can process locations from social networks if we share a location there
    } else if (url.queryParameters['q'] != null) {
      final coordinates = url.queryParameters['q']?.split(',');
      if (coordinates != null && coordinates.length == 2) {
        latitude = double.tryParse(coordinates[0]);
        longitude = double.tryParse(coordinates[1]);
      }
    }

    if (tokenId != null && streamId != null) {
      if (await EtaUtils.processShareLink(
        ref,
        tokenId: tokenId,
        streamId: streamId,
        type: type,
        latitude: latitude,
        longitude: longitude,
      )) {
        return;
      }
    }

    if (objectId != null) {
      final id = int.tryParse(objectId);
      if (id != null) {
        final location =
            (latitude == null || longitude == null) ? null : LatLng(latitude: latitude, longitude: longitude);
        await _delayIfFirstRun(isFirstRun: isFirstRun);

        await _poiDeeplinkById(id, location);
      }
    } else if (latitude != null && longitude != null) {
      if (type != null && type == BaldayDeeplink.typeValueMyLocation) {
        _myLocationDeepLinkHandler(latitude, longitude);
      } else {
        await _delayIfFirstRun(isFirstRun: isFirstRun);
        await _poiDeepLinkByCoords(latitude, longitude);
      }
    } else if (momrahId != null) {
      await _momrahDeepLinkHandler(momrahId);
    } else if (homeWidget != null) {
      await _delayIfFirstRun(isFirstRun: isFirstRun, duration: const Duration(seconds: 8));
      CommonFunctions.openMovingViolations(uri);
    } else if (serviceKey.isNotEmpty && serviceKey != '/poi-map' && serviceKey.startsWith('/app')) {
      MiniAppModel app = MiniAppModel();
      var subPath;
      if (dtId != null && path != null) {
        subPath = '#$path/$dtId';
      } else if (path != null) {
        subPath = '#$path';
      }

      app = app.copyWith(serviceKey: serviceKey.replaceAll('/app/', ''), path: subPath);

      CommonFunctions.openMiniApp(app);
    } else if (url.toString().isNotEmpty && !url.toString().contains('insiderbaladyapp')) {
      final AppRouter router = await ref.watch(appRouterProvider);

      final params = url.queryParameters;
      if (url.path == '/stories' && params['id'] != null) {
        final id = params['id'];
        await _openStories(id!);
      } else if (url.path == '/search' && params['filter'] != null) {
        final filter = params['filter'];
        await _openQuickFilter(filter!);
      } else if (url.path == '/quickFeedback') {
        await router.push(QuickFeedbackRoute());
      } else if (url.path == '/freeRoam') {
        await _freeRoam();
      } else if (url.path == '/qibla') {
        await _openQibla();
      } else if (url.path == '/shareMyLocation') {
        await _shareMyLocation();
      } else if (url.path == '/athkar') {
        await _openAthkar();
      } else if (url.path == '/quran') {
        await _openQuran();
      } else if (url.path == '/snapSend') {
        await _openSnapSend();
      } else if (url.path == '/parking') {
        _openParking();
      } else {
        await router.pushNamed(url.toString());
      }
    }
  }

  void _openParking() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(appAnalyticsProvider).quickActionSelected('parking');
      await ref.read(layersControlsProvider.notifier).enableParking(isFromDeepLink: true);
    });
  }

  Future<void> _freeRoam() async {
    final AppRouter router = await ref.watch(appRouterProvider);
    ref.read(appAnalyticsProvider).quickActionSelected('free_roam');
    await router.push(const FreeRoamRoute());
  }

  Future<void> _shareMyLocation() async {
    final AppRouter router = await ref.watch(appRouterProvider);
    await router.push(ShareMyLocationRoute());
  }

  Future<void> _openQibla() async {
    final AppRouter router = await ref.watch(appRouterProvider);
    ref.read(appAnalyticsProvider).quickActionSelected('qibla');
    Metrics.logEventAdvanced(
      MetricsConstants.exploreKeys.qibla,
      action: MetricAction.tap.name,
      group: MetricsConstants.exploreTag,
    );
    final location = ref.read(locationProvider.notifier);

    await location.checkLocationPermission().then((allowed) async {
      if (allowed) {
        await router.push(const KiblahRoute());
      }
    });
  }

  Future<void> _openQuran() async {
    ref.read(appAnalyticsProvider).quickActionSelected('quran');
    // await NavigationService.navigatorKey.currentState?.pushNamed(RouteName.menuQuranPage);

    await sl<HomeMiniAppsListCubit>().openMiniApp(
      serviceKey: "islamicservice",
      path: "#Quran_Show_All_Surahs_Page",
    );
  }

  Future<void> _openAthkar() async {
    ref.read(appAnalyticsProvider).quickActionSelected('athkar');
    // await NavigationService.navigatorKey.currentState?.pushNamed(RouteName.mainAthkarPage);

    await sl<HomeMiniAppsListCubit>().openMiniApp(
      serviceKey: "islamicservice",
      path: "#Athkar_Page",
    );
  }

  Future<void> _openSnapSend() async {
    CommonFunctions.sendUXCamEvent(UXCamEvents.SnapAndSend_Open_From_Home_Event);
    await sl<HomeMiniAppsListCubit>().openMiniApp(
      serviceKey: "snapandsend",
    );

    // await NavigationService.navigatorKey.currentState!.pushNamed(
    //   RouteName.vDAllTypesScreen,
    // );
  }

  Future<void> _openQuickFilter(String filter) async {
    final AppRouter router = await ref.watch(appRouterProvider);
    final quickFilter = QuickFilter.values.firstWhere(
      (element) => element.name == filter,
    );
    unawaited(ref.read(urbiAnalyticsProvider).track(
      'quickFilterSearch',
      properties: {
        'filter': quickFilter.name,
      },
    ));
    ref.read(appAnalyticsProvider).categorySelected(quickFilter.name);
    ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetricsKeys.exploreSearch);

    final language = ref.read(appLanguageProvider);

    final query = quickFilter.query[language];
    if (query != null) {
      unawaited(
        BssService.instance.sendEvent(
          BssRequest(
            eventType: BSSEventType.action,
            actionType: BSSActionType.deeplink,
            uiElement: const BssUIElement(
              name: BssUIElementNames.searchStart,
              ownerName: BssUIElementNames.searchBar,
            ),
            payload: BssPayload(searchRequest: BssSearchRequest(text: query)),
          ),
        ),
      );
    }
    unawaited(router.push(SearchRoute(requestFocus: false)));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(searchProvider(SearchScopeEnum.map.value).notifier).quickSearch(quickFilter);
    });
  }

  Future<void> _openStories(String id) async {
    final AppRouter router = await ref.watch(appRouterProvider);

    Metrics.logEventAdvanced(
      MetricsConstants.exploreKeys.storyBanner,
      group: MetricsConstants.exploreTag,
      action: MetricAction.tap.name,
      props: {'id': id},
    );

    ref.read(storiesOpenStateProvider.notifier).open();

    await router.push(StoriesRoute(
      type: StoryTypes.network,
      initialStoryId: id,
      onClose: ref.read(storiesOpenStateProvider.notifier).close,
    ));
  }

  Future<void> _poiDeeplinkById(int dgisObjectId, [LatLng? location]) async {
    final appRouter = ref.watch(appRouterProvider);
    final storeParkingData = await ref.read(parkingManageProvider.future);
    final isParkingPoi = dgisObjectId == parkingObjectId;

    if (isParkingPoi && storeParkingData == null) {
      if (location != null) {
        await _poiDeepLinkByCoords(location.latitude, location.longitude);
      }
      return;
    }

    await appRouter.replaceOrPush(
      route: PoiCardWidgetRoute(
        objectId: DgisObjectIdMessage(
          objectId: dgisObjectId,
          entranceId: 0,
        ),
        closestPoint: location,
        cameraConfig: const PoiCameraConfig(zoom: 17),
      ),
      toCompareRoutes: [PoiCardWidgetRoute.page],
    );
  }

  Future<void> _poiDeepLinkByCoords(double latitude, double longitude) async {
    final vendorConfig = await ref.read(vendorConfigProvider.future);
    final dio = ref.read(baseDioProvider);

    final catalogApi = vendorConfig[BaldayDeeplink.catalogKey];
    final key = vendorConfig[BaldayDeeplink.vendorConfigKey];

    final geocodeUrl = BaldayDeeplink.geocodeUrl(catalogApi);

    final geocoderResponse = await dio.get(
      geocodeUrl,
      queryParameters: {
        BaldayDeeplink.longitudeKey: longitude,
        BaldayDeeplink.latitudeKey: latitude,
        BaldayDeeplink.fieldsKey: BaldayDeeplink.fieldsValuePoints,
        BaldayDeeplink.keyKey: key,
      },
    );
    final data = geocoderResponse.data as Map<String, dynamic>;

    // In case of 404 error, open map with the provided coordinates
    if (data.containsKey('meta') &&
        data['meta'] is Map<String, dynamic> &&
        (data['meta'] as Map<String, dynamic>).containsKey('code') &&
        (data['meta'] as Map<String, dynamic>)['code'] == 404) {
      // Dgis object id -2 is used to open map with provided coordinates not with poi id
      final appRouter = ref.watch(appRouterProvider);
      await appRouter.push(DeeplinkRoute(
        closestPoint: LatLng(latitude: latitude, longitude: longitude),
        cameraConfig: const PoiCameraConfig(zoom: 17),
      ));
    }

    if (!data.containsKey('result')) {
      return;
    }

    final result = data['result'] as Map<String, dynamic>;
    if (!result.containsKey('items')) {
      return;
    }

    final items = result['items'] as List<dynamic>;
    if (items.isEmpty) {
      return;
    }

    final geocoderBest = items.first as Map<String, dynamic>;
    if (!geocoderBest.containsKey('id')) {
      return;
    }

    final dgisId = int.tryParse(geocoderBest['id']);
    if (dgisId == null) {
      return;
    }

    await ref.watch(appRouterProvider).replaceOrPush(
      route: PoiCardWidgetRoute(
        objectId: DgisObjectIdMessage(
          objectId: dgisId,
          entranceId: 0,
        ),
        cameraConfig: const PoiCameraConfig(zoom: 17),
      ),
      toCompareRoutes: [PoiCardWidgetRoute.page],
    );
  }

  void _myLocationDeepLinkHandler(double latitude, double longitude) {
    final latLng = LatLng(latitude: latitude, longitude: longitude);
    ref
        .watch(appRouterProvider)
        .push(DeeplinkRoute(closestPoint: latLng, cameraConfig: const PoiCameraConfig(zoom: 17)));
  }

  Future<void> _momrahDeepLinkHandler(String momrahId) async {
    final env = await ref.read(dgisEnvironmentProvider.future);
    final dio = ref.read(baseDioProvider);

    final twinsUrl = BaldayDeeplink.twinsUrl(env.twinsApi);

    final twinsResponse = await dio.get(twinsUrl, queryParameters: {
      BaldayDeeplink.keyKey: BaldayDeeplink.momrahTwinsKey,
      BaldayDeeplink.momrahPartnerCodeKey: BaldayDeeplink.momrahPartnerCodeValue,
      BaldayDeeplink.momrahPartnerCodeId: momrahId,
    });
    final data = twinsResponse.data as Map<String, dynamic>;

    if (!data.containsKey('result')) {
      return;
    }

    final result = data['result'] as Map<String, dynamic>;
    if (!result.containsKey('items')) {
      return;
    }

    final items = result['items'] as List<dynamic>;
    if (items.isEmpty) {
      return;
    }

    final item = items.first as Map<String, dynamic>;
    if (!item.containsKey('twins')) {
      return;
    }

    final twins = item['twins'] as List<dynamic>;
    if (twins.isEmpty) {
      return;
    }

    final twin = twins.first as Map<String, dynamic>;
    if (!twin.containsKey('dgis_id')) {
      return;
    }

    final dgisId = int.tryParse(twin['dgis_id']);
    if (dgisId == null) {
      return;
    }

    final appRouter = ref.watch(appRouterProvider);
    await appRouter.push(PoiCardWidgetRoute(
      objectId: DgisObjectIdMessage(
        objectId: dgisId,
        entranceId: 0,
      ),
      cameraConfig: const PoiCameraConfig(zoom: 17),
    ));
  }
}

Future<void> setupMapness(EnvType envType) async {
  final vendorConfigLocal = await AppConfigLoader.getAppConfig();
  final vendorConfigContentMessage = VendorConfigContentMessage(content: vendorConfigLocal);

  await initialiseDGis(
    logOptions: LogOptionsMessage(
      systemLevel: LogLevelMessage.fatal,
      customLevel: LogLevelMessage.fatal,
    ),
    configContent: vendorConfigContentMessage,
  );
}

Future<void> runMapnessApp(EnvType envType, FutureOr<void> Function() main) async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHive();

  final hostFlutterApi = _HostFlutterApi();
  HostFlutterApi.setUp(hostFlutterApi);

  await AppConfigLoader.init(envType);
  await hostFlutterApi.appRunCompleter.future;

  await main();
}

Future<void> initHive() async {
  await Hive.initFlutter();
  Hive
    ..registerAdapter(SearchHistoryItemAdapter())
    ..registerAdapter(FavoriteCacheItemAdapter())
    ..registerAdapter(HiveCoordinatesAdapter())
    ..registerAdapter(HiveFavouriteItemEntityAdapter())
    ..registerAdapter(FavoriteCacheStateAdapter());
}

class _HostFlutterApi extends HostFlutterApi {
  final appRunCompleter = Completer();

  _HostFlutterApi();

  bool isAppRun = false;

  @override
  void analyticsTrack(String event) {
    analyticsClient.track(event, properties: {"app_run": isAppRun});
  }

  @override
  void runMain() {
    isAppRun = true;
    appRunCompleter.complete();
  }

  @override
  Future<MapMarkersType?> getMarkerType(List<int> rubricIds) async {
    return RubricTypeMapper.getMarkerType(rubricIds.toSet());
  }

  @override
  Future<VendorConfigContentMessage> getAppConfig() async {
    final vendorConfigLocal = await AppConfigLoader.getAppConfig();
    return VendorConfigContentMessage(content: vendorConfigLocal);
  }

  @override
  Future<FavouritesStateMessage> getFavourites() async {
    final favouritesState = await getFavouritesStateFromHive();
    return FavouritesStateMessage(
      home: favouritesState.home?.message,
      work: favouritesState.work?.message,
      items: favouritesState.items.map((item) => item.message).toList(),
    );
  }

  @override
  Future<bool> isAuthorized() async {
    try {
      return sl<EntryPointCubit>().state.token != null;
    } catch (e) {
      logger.log('Cant get isAuthorized, $e');
      return false;
    }
  }
}
