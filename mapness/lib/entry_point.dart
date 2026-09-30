// ignore_for_file: prefer_expression_function_bodies

import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/constants/analytics_events.dart';
import 'package:balady_plus/app/core/utils/constants/remote_config.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/accecipilities/balady_theme_controller.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:balady_uikit/core/colors/app_colors_theme.dart';
import 'package:balady_uikit/core/colors/app_static_colors_theme.dart';
import 'package:balady_uikit/core/colors/colors_v2/app_colors_theme_v2.dart';
import 'package:balady_uikit/core/colorsV2/app_theme.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/typography/text_theme_styles.dart';
import 'package:balady_uikit/core/typography/text_theme_styles_v3.dart';
import 'package:collection/collection.dart';
// ignore: depend_on_referenced_packages
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dgis_map/library.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_insider/enum/InsiderCallbackAction.dart';
import 'package:flutter_insider/flutter_insider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:mapness/_features/common/providers/shared_prefs.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/_features/common/widgets/eager_init_widget.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/app/auto_route/others/routes_observer.dart';
import 'package:mapness/app/auto_route/poi_card_ext.dart';
import 'package:mapness/entities/city_event/city_event.dart';
import 'package:mapness/entities/quick_filters/quick_filter.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/entities/search/models/search_history.dart';
import 'package:mapness/features/advert_metrics/advert_metrics.dart';
import 'package:mapness/features/app_analytics/app_analytics.dart';
import 'package:mapness/features/app_analytics/insider_custom_action_handler.dart';
import 'package:mapness/features/app_icon_quick_actions/providers/app_icon_quick_actions_initializer.dart';
import 'package:mapness/features/app_icon_quick_actions/providers/app_icon_quick_actions_manager.dart';
import 'package:mapness/features/app_icon_quick_actions/providers/pending_app_icon_quick_action.dart';
import 'package:mapness/features/app_icon_quick_actions/services/app_icon_quick_action_handler.dart';
import 'package:mapness/features/app_icon_quick_actions/services/app_icon_quick_actions_platform.dart';
import 'package:mapness/features/balady_analytics/balady_analytics.dart';
import 'package:mapness/features/balady_analytics/events/service_events.dart';
import 'package:mapness/features/car/car_enable_free_roam.dart';
import 'package:mapness/features/city_event/active_city_event.dart';
import 'package:mapness/features/cityscape/cityscape.dart';
import 'package:mapness/features/dynamic_poi/dynamic_poi_layer_provider.dart';
import 'package:mapness/features/favourites/data/models/favorite_cache_item.dart';
import 'package:mapness/features/favourites/mappers/favourite_item_mapper.dart';
import 'package:mapness/features/favourites/providers/favourite_cache.dart';
import 'package:mapness/features/founding_day/founding_day.dart';
import 'package:mapness/features/leap/leap.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/features/makkah_places/makkah_places_layer_provider.dart';
import 'package:mapness/features/parking_spot/parking_manage.dart';
import 'package:mapness/features/path_nav/lib/extensions.dart';
import 'package:mapness/features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/features/search/providers/search_region.dart' show initializeSearchRegionServiceProvider;
import 'package:mapness/features/share_eta/helpers/utils.dart';
import 'package:mapness/features/share_eta/providers/share_my_location_launch_intent.dart';
import 'package:mapness/features/special_themes/modes/saudi_national_day/saudi_national_day_app_icon.dart';
import 'package:mapness/features/special_themes/modes/saudi_national_day/saudi_national_day_resolved_config.dart';
import 'package:mapness/features/stories/models/story_types.dart';
import 'package:mapness/features/stories/providers/stories_open_state.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/l10n/generated/app_localizations_ar.dart';
import 'package:mapness/l10n/generated/app_localizations_en.dart';
import 'package:mapness/pages/debug_overlay/debug_overlay.dart';
import 'package:mapness/pages/landing/landing_page.dart';
import 'package:mapness/pages/path_nav/path_nav_page.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/lib/auth/auth_methods.dart';
import 'package:mapness/shared/lib/deeplink_functions.dart';
import 'package:mapness/shared/lib/urbi_metrics_utils.dart';
import 'package:mapness/shared/providers/analytic/bss_common.dart';
import 'package:mapness/shared/providers/analytic/bss_dio.dart';
import 'package:mapness/shared/providers/analytic/bss_service.dart';
import 'package:mapness/shared/providers/analytic/models/bss_request.dart';
import 'package:mapness/shared/providers/analytic/models/payload/bss_payload.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/base_dio.dart';
import 'package:mapness/shared/providers/car_connection.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/providers/debug_state.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/hive.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/rubric_marker_type_mapper.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';
import 'package:mapness/shared/providers/media_query.dart';
import 'package:mapness/shared/providers/short_link_repository.dart';
import 'package:mapness/shared/providers/urbi_analytics.dart';
import 'package:mapness/shared/providers/vendor_config.dart';
import 'package:mapness/shared/ui/loading/loading_overlay.dart';
import 'package:mapness/shared/ui/toast/app_locale.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';
import 'package:mapness/shared/utils/app_config_loader.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:mapness/widgets/scopes/global_scopes.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:provider/provider.dart' as p;
import 'package:provider/provider.dart' as provider;
import 'package:rangers_applog_flutter_plugin/rangers_applog_flutter_plugin.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sheetify/sheetify.dart';

import 'features/search/providers/search.dart';
import 'features/search/ui/search_scope.dart';
import 'features/special_themes/core/special_theme_mode.dart';
import 'features/special_themes/modes/saudi_national_day/saudi_national_day.dart';
import 'features/wrc/wrc.dart';

Mixpanel? mixpanel;

class MapnessRouteObserver extends RouteObserver<ModalRoute<void>> {
  static final MapnessRouteObserver _instance = MapnessRouteObserver._internal();

  factory MapnessRouteObserver() => _instance;

  MapnessRouteObserver._internal();
}

// NOTE: The RangersAppLog auto-track navigation observer
// (`RangersApplogNavigationObserver`) is intentionally NOT registered. Its
// `didPush`/`didReplace` walk the element tree (`visitChildElements`) on every
// route change, which corrupts Flutter's element tree under auto_route's nested
// tab navigators (`_elements.contains(element)` assertion → red screen). We
// don't need automatic `page_view` tracking — all DataFinder events are fired
// explicitly from the search/POI flows.

class MapnessProviderScope extends StatelessWidget {
  const MapnessProviderScope({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => ProviderScope(
    child: Consumer(
      builder: (context, ref, child) {
        // Must run before [EagerInitWidget] — eager init shows a spinner instead of [child].
        ref.watch(appIconQuickActionsInitializerProvider);
        return EagerInitWidget(child: child!);
      },
      child: Consumer(
        builder: (context, ref, child) {
          final language = ref.watch(appLanguageProvider);
          final localizations = language == Language.arabic ? AppLocalizationsAr() : AppLocalizationsEn();
          // Initialize Saudi National Day provider to start the timer
          ref
            ..watch(saudiNationalDayProvider)
            // Initialize Cityscape provider to listen remote config
            ..watch(cityscapeProvider)
            ..watch(foundingDayUrbiProvider)
            ..watch(activeCityEventProvider)
            // Initialize Makkah places layer provider
            ..watch(makkahPlacesLayerProvider)
            // Initialize Dynamic POI layer (Momrah dynamic-markers backend)
            ..watch(dynamicPoiLayerProvider)
            // Sync home-screen app icon quick actions from remote config
            ..watch(appIconQuickActionsManagerProvider)
            // Initialize WRC provider to listen remote config
            ..watch(wRCProvider);

          return provider.MultiProvider(
            providers: [
              provider.ChangeNotifierProvider(create: (_) => ThemeController()),
              provider.Provider<AppLocalizations>.value(value: localizations),
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
  const MapnessEntryPoint({required this.mapCreated, super.key});

  final void Function(DgisMapController) mapCreated;

  @override
  ConsumerState<MapnessEntryPoint> createState() => _MapnessEntryPointState();
}

class _MapnessEntryPointState extends ConsumerState<MapnessEntryPoint> with WidgetsBindingObserver {
  /// Latches once the launcher icon has been evaluated this session, so a
  /// rebuild cannot swap the launcher entry while the user is in the app.
  ///
  /// Only set once the resolved config is backed by real environment data —
  /// see [_maybeApplyNationalDayIcon]. Latching on the first build instead
  /// would freeze the bundled-default window, which is what made a fresh
  /// install keep the default icon until the next cold start.
  bool _nationalDayIconApplied = false;

  late OverlayEntry? _debugOverlay;
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  ProviderSubscription? _locationListener;
  StreamSubscription? _navigationEventsListener;

  String _fontFamily() {
    final language = ref.watch(appLanguageProvider);
    return language == Language.arabic
        ? 'packages/balady_design_system/IBMPlexSansArabic'
        : 'packages/balady_uikit/Golos';
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    logger.init();
    initMixpanel();
    initDeepLinks();
    initAppIconQuickActionsPending();
    listenNavigationEvents();
    checkConnection();
    PersistentSafeAreaBottom.startObserving();
    ref.read(appAnalyticsProvider).deviceTypeDetected();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) {
        return;
      }
      // Update MediaQueryInfoProvider with the initial MediaQuery
      ref.read(mediaQueryInfoProvider.notifier).update(MediaQuery.of(context));
      // Init camera position point
      await initCameraPositionPoint();
      if (!mounted) {
        return;
      }
      // TODO(Scroollocker): Disable this feature. Because need to research fail restore cases
      // restoreState();
      await clearCache();
      if (!mounted) {
        return;
      }
      // TODO(wultriel): Disable this feature. Because need to research fail restore cases
      // checkNavigationState();
      // Initialization of BSS and Search Region singleton services
      await _initBssService();
      if (!mounted) {
        return;
      }
      await ref.read(initializeSearchRegionServiceProvider.future);
      if (!mounted) {
        return;
      }
      await ref.read(appIconQuickActionsManagerProvider.future);
      await ref.read(appIconQuickActionHandlerProvider.notifier).deliverColdStartShortcut();
      unawaited(checkNavigationState());
      final track = ref.read(urbiAnalyticsProvider).track;
      await AdvancedMetrics.instance.stopMeasureStartup(track: track);
      await AdvancedMetrics.instance.sendPreviousSessionBatteryUsage(
        track: track,
      );
      await AdvancedMetrics.instance.startMeasureBattery();
      if (!mounted) {
        return;
      }
      await ref.read(cityscapeProvider.notifier).initializeGlobalMarker();
      if (!mounted) {
        return;
      }
      await ref.read(foundingDayUrbiProvider.notifier).initializeGlobalMarker();
      if (!mounted) {
        return;
      }
      await ref.read(leapProvider.notifier).initializeGlobalMarker();
      if (!mounted) {
        return;
      }
      final mapStyle = ref.read(activeCityEventProvider)?.stylePath;

      if (mapStyle != null) {
        _updateMapStyle(mapStyle);
      }

      await _updateGlobalMarkerLeap(ref);
      if (!mounted) {
        return;
      }

      // Sync BaladyThemeNotifier with the persisted darkModeProvider state
      // so the outer Apps/Profile shells follow the same toggle as Mapness.
      final initialDark = (await ref.read(darkModeProvider.future)).isDark;
      if (mounted) {
        _themeChanged(isDark: initialDark);
      }
    });

    // call the openAppLink when user click on notification have deep link
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (!mounted) {
        return;
      }
      if (message != null && message.data.containsKey('url')) {
        final url = message.data['url'];
        openAppLink(url);
        return;
      }
    });

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
    WidgetsBinding.instance.removeObserver(this);
    PersistentSafeAreaBottom.stopObserving();
    _linkSubscription?.cancel();
    _locationListener?.close();
    _navigationEventsListener?.cancel();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Warm-start shortcuts are stored natively; the plugin callback may not fire.
      unawaited(deliverNativeShortcutIfPresent());
      unawaited(ref.read(appIconQuickActionsManagerProvider.notifier).syncPublishedShortcuts());
      if (ref.read(pendingAppIconQuickActionProvider.notifier).hasPending) {
        unawaited(ref.read(appIconQuickActionHandlerProvider.notifier).deliverColdStartShortcut());
      }
    }
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    // Home-screen shortcuts must follow the device locale, not in-app language.
    unawaited(ref.read(appIconQuickActionsManagerProvider.notifier).syncPublishedShortcuts());
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
          ref
              .read(appRouterProvider)
              .push(
                PathNavRoute(
                  navType: routeSearchOptions,
                  initAction: PathNavPageInitAction.restoreFromState,
                ),
              );
        } else {
          _locationListener = ref.listenManual<Position?>(locationProvider, (_, next) {
            if (next != null) {
              _locationListener?.close();
              ref
                  .read(appRouterProvider)
                  .push(
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

  Future<void> checkNavigationState() async {
    final controller = await ref.read(dgisControllerProvider.future);
    final navStateMessage = await controller.getCurrentNavigationState();
    final isCarConnected = await ref.read(carConnectionProvider.future);

    if (navStateMessage.state == NavigationState.navigation &&
        navStateMessage.routeSearchOptions != null &&
        isCarConnected) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final location = ref.read(locationProvider);
        if (location != null) {
          ref
              .read(appRouterProvider)
              .push(
                PathNavRoute(
                  navType: navStateMessage.routeSearchOptions ?? RouteSearchOptionsMessage.car,
                  initAction: null,
                ),
              );
        } else {
          _locationListener = ref.listenManual<Position?>(locationProvider, (
            _,
            next,
          ) {
            if (next != null) {
              _locationListener?.close();
              ref
                  .read(appRouterProvider)
                  .push(
                    PathNavRoute(
                      navType: navStateMessage.routeSearchOptions ?? RouteSearchOptionsMessage.car,
                      initAction: null,
                    ),
                  );
            }
          });
        }
      });
    }
  }

  Future<void> _updateGlobalMarkerCityscape(WidgetRef ref) async {
    if (!mounted) {
      return;
    }
    final cityscapeEnabled = ref.read(cityscapeProvider);
    final selectedMarker = ref.read(selectedMarkerProvider);
    final notifier = ref.read(cityscapeProvider.notifier);

    if (cityscapeEnabled && selectedMarker == null) {
      await notifier.showGlobalMarker();
    } else {
      await notifier.hideGlobalMarker();
    }
  }

  Future<void> _updateMapStyle(String mapStyle) async {
    final dgisController = ref.read(dgisControllerProvider);
    final dgisControllerValue = dgisController.value;
    dgisControllerValue?.loadStyles(mapStyle);
  }

  Future<void> _updateGlobalMarkerFoundingDay(WidgetRef ref) async {
    if (!mounted) {
      return;
    }
    final isFoundingDayToday = ref.read(foundingDayUrbiProvider);
    final selectedMarker = ref.read(selectedMarkerProvider);
    final notifier = ref.read(foundingDayUrbiProvider.notifier);

    if (isFoundingDayToday && selectedMarker == null) {
      await notifier.showGlobalMarker();
    } else {
      await notifier.hideGlobalMarker();
    }
  }

  Future<void> _updateGlobalMarkerLeap(WidgetRef ref) async {
    if (!mounted) {
      return;
    }
    final isLeapNow = ref.read(leapProvider);
    final selectedMarker = ref.read(selectedMarkerProvider);
    final notifier = ref.read(leapProvider.notifier);

    if (isLeapNow && selectedMarker == null) {
      await notifier.showGlobalMarker();
    } else {
      await notifier.hideGlobalMarker();
    }
  }

  Future<void> _updateAllMarkersWRC(WidgetRef ref, bool wrcEnabled) async {
    final notifier = ref.read(wRCProvider.notifier);
    if (wrcEnabled) {
      await notifier.showAllMarkers();
    } else {
      await notifier.hideAllMarkers();
    }
  }

  Future<void> _updateSpecificMarkerWRC(
    WidgetRef ref,
    Marker? previousMarker,
    Marker? marker,
  ) async {
    final notifier = ref.read(wRCProvider.notifier);
    // hide previous marker if there was one
    if (previousMarker != null) {
      await notifier.showSpecificMarker(previousMarker);
    }

    // show new marker if there is one
    if (marker != null) {
      await notifier.hideSpecificMarker(marker);
    }
  }

  Future<void> _themeChanged({bool isDark = false}) async {
    if (!mounted) {
      return;
    }

    final themeController = context.read<ThemeController>();
    final baladyTheme = context.read<BaladyThemeNotifier>();
    final specialThemeMode = ref.read(specialThemeModeProvider);
    if (kDebugMode) {
      debugPrint('[DarkThemeDebug] _themeChanged isDark=$isDark mode=$specialThemeMode');
    }

    // Both `ThemeController.setTheme` and `BaladyThemeNotifier` notify listeners (and `setTheme` writes
    // SharedPreferences) unconditionally / on every call, so only touch them when the effective value changed.
    final targetTheme = isDark
        ? BaladyAppThemes.darkDGA
        : switch (specialThemeMode) {
            SpecialThemeMode.nationalDay => BaladyAppThemes.saudiDay,
            SpecialThemeMode.mekkahBase || SpecialThemeMode.ramadan => BaladyAppThemes.mekkah,
            SpecialThemeMode.foundationDay => BaladyAppThemes.foundationDay,
            _ => BaladyAppThemes.lightDGA,
          };
    // `null` (provider still loading) or `autoSunDependent` follow the resolved brightness.
    final targetMode = switch (ref.read(darkModeProvider).value?.currentMapMode) {
      DarkMapStateEnum.asInASystem => ThemeMode.system,
      DarkMapStateEnum.alwaysEnabled => ThemeMode.dark,
      DarkMapStateEnum.off => ThemeMode.light,
      _ => isDark ? ThemeMode.dark : ThemeMode.light,
    };

    // Both notifiers change synchronously (before the first await) so the two theme sources flip in the same frame.
    if (baladyTheme.themeMode != targetMode) {
      unawaited(baladyTheme.updateThemeMode(targetMode));
    }

    if (themeController.currentTheme != targetTheme) {
      await themeController.setTheme(targetTheme);
    }
  }

  /// Applies the National Day launcher icon once per cold start, but only
  /// after the environment config has actually resolved.
  ///
  /// [dgisEnvironmentProvider] is an async notifier that awaits Hive, so on
  /// the first frame it is still `AsyncLoading` and
  /// [saudiNationalDayResolvedConfigProvider] falls back to
  /// [SaudiNationalDayRemoteConfig.bundledDefault]. Latching on that first
  /// build pinned the decision to the bundled window and ignored the window
  /// configured in Firebase — on a fresh install the icon stayed default
  /// until the user killed and relaunched the app (by which point Hive was
  /// warm enough to resolve synchronously).
  ///
  /// Waiting for the env provider costs nothing on a normal start: the fetch
  /// is already awaited in `runMapnessApp()` before `main()`, so this
  /// resolves within the first few frames. If it errors we still apply, so a
  /// broken config degrades to the bundled window rather than to no icon
  /// swap at all.
  ///
  /// Still applied at most once per session — the launcher entry must not
  /// change under a user who is mid-session.
  void _maybeApplyNationalDayIcon() {
    if (_nationalDayIconApplied) {
      return;
    }

    final env = ref.watch(dgisEnvironmentProvider);
    if (env.isLoading) {
      // Not resolved yet — this method re-runs on the rebuild that lands the
      // value, so the decision is simply deferred rather than dropped.
      return;
    }

    _nationalDayIconApplied = true;

    final isActive = ref.read(saudiNationalDayResolvedConfigProvider).isAppIconActiveAt(DateTime.now());

    // Not awaited — a launcher-icon failure must never affect the UI.
    unawaited(SaudiNationalDayAppIcon.apply(shouldUseNationalDay: isActive));
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(darkModeProvider, (prev, next) {
      // Ignore the transient loading state (initial load / `invalidateSelf` rebuild): it carries no resolved value and
      // would apply a bogus light theme. `_themeChanged` is a no-op when the resolved theme did not change.
      if (next.isLoading || !next.hasValue) {
        return;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _themeChanged(isDark: next.value?.isDark == true);
      });
    });

    final language = ref.watch(appLanguageProvider);
    final direction = ref.watch(uiDirectionProvider);
    final activeEvent = ref.watch(activeCityEventProvider);
    final isNationalDay = activeEvent?.isSaudiNationalDay ?? false;
    final specialThemeMode = ref.watch(specialThemeModeProvider);
    final baladyTheme = context.watch<BaladyThemeNotifier>();

    // Launcher-icon swap. Watched here rather than in runMapnessApp() because
    // the window comes from `saudiNationalDayDateRange` in app_env_config,
    // which is only available once the env provider has resolved.
    _maybeApplyNationalDayIcon();

    // Track theme changes for analytics
    ref
      ..listen<SpecialThemeMode>(specialThemeModeProvider, (prev, next) {
        if (kDebugMode) {
          debugPrint('[DarkThemeDebug] specialThemeMode transition prev=$prev next=$next');
        }

        if (prev == next) {
          return;
        }

        final isDark = ref.read(darkModeProvider).value?.isDark ?? false;
        _themeChanged(isDark: isDark);
      })
      ..listen<CameraPositionMessage?>(cameraPositionProvider, (prev, next) {
        if (next == null || prev?.zoom == next.zoom) {
          return;
        }
        _updateGlobalMarkerCityscape(ref);
        _updateGlobalMarkerFoundingDay(ref);
        _updateGlobalMarkerLeap(ref);
      })
      ..listen<CityEventType?>(activeCityEventProvider, (prev, next) {
        if (prev == next) {
          return;
        }
        final prevStyle = prev?.stylePath;
        final nextStyle = next.stylePath;
        if (prevStyle != nextStyle) {
          _updateMapStyle(nextStyle);
        }
      })
      // listen cityscapeProvider and selectedMarkerProvider for other updates
      ..listen<bool>(cityscapeProvider, (prev, next) {
        _updateGlobalMarkerCityscape(ref);
      })
      ..listen<bool>(foundingDayUrbiProvider, (prev, next) {
        _updateGlobalMarkerFoundingDay(ref);
      })
      ..listen<bool>(leapProvider, (prev, next) {
        _updateGlobalMarkerLeap(ref);
      })
      ..listen<bool>(wRCProvider, (prev, next) {
        _updateAllMarkersWRC(ref, next);
      })
      ..listen<Marker?>(selectedMarkerProvider, (prev, next) {
        _updateGlobalMarkerCityscape(ref);
        _updateGlobalMarkerFoundingDay(ref);
        _updateGlobalMarkerLeap(ref);
        _updateSpecificMarkerWRC(ref, prev, next);
      })
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
            child: const ProviderScope(child: DebugOverlay()),
          ),
        );
        Overlay.of(context, rootOverlay: true).insert(_debugOverlay!);
      });

    return DefaultTextHeightBehavior(
      textHeightBehavior: const TextHeightBehavior(
        leadingDistribution: TextLeadingDistribution.even,
      ),
      child: Directionality(
        textDirection: direction,
        child: Consumer(
          builder: (context, ref, child) {
            return MaterialApp.router(
              routerConfig: ref.read(appRouterProvider).config(navigatorObservers: () => [RoutesObserver(ref: ref)]),
              theme: ThemeData(
                fontFamily: _fontFamily(),
                scaffoldBackgroundColor: Colors.transparent,
                dividerColor: Colors.grey[400],
                useMaterial3: false,
                extensions: <ThemeExtension<dynamic>>[
                  if (language == Language.arabic) ThemeTextStyles.arabic() else ThemeTextStyles.english(),
                  if (language == Language.arabic) ThemeTextStylesV3.frutiger() else ThemeTextStylesV3.golos(),
                  AppColorsThemeExt.palette(isDark: false),
                  AppColorsThemeV2.palette(isDark: false),
                  AppColorsThemeV3.palette(
                    themes: switch (specialThemeMode) {
                      SpecialThemeMode.nationalDay => BaladyAppThemes.saudiDay,
                      SpecialThemeMode.mekkahBase || SpecialThemeMode.ramadan => BaladyAppThemes.mekkah,
                      SpecialThemeMode.foundationDay => BaladyAppThemes.foundationDay,
                      _ => BaladyAppThemes.lightDGA,
                    },
                  ),
                  AppStaticColorsThemeExt.palette(),
                ],
              ),
              builder: (context, child) => child != null
                  ? LoadingOverlay(
                      child: ToastOverlay(
                        child: GlobalScopes(
                          child: Column(
                            children: [
                              Expanded(
                                child: child,
                              ),
                            ],
                          ),
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
      await controller.setCameraPositionPoint(
        CameraPositionPointMessage(x: 0.5, y: 0.5),
      );
    } catch (ex) {
      logger.log(
        'Error setting camera position point: $ex',
        logLevel: MapnessLogLevel.error,
      );
    }
  }

  Future<void> clearCache() async {
    await ref.read(selectedMarkerProvider.notifier).removeAllMarkers();
    ref.read(layersControlsProvider.notifier).updateLayerInfo();
    final poiBox = await ref.read(
      hiveProvider(MapnessConstants.poiDataBoxName).future,
    );
    await poiBox.clear();
  }

  Future<void> initMixpanel() async {
    try {
      logger.log('Initializing Mixpanel...');
      mixpanel = await Mixpanel.init(
        '2d045d85e25087812e92c62b84d6fbc3',
        trackAutomaticEvents: true,
      );
      mixpanel?.setLoggingEnabled(kDebugMode);
      logger.log('Mixpanel initialized successfully');
    } catch (e, stackTrace) {
      logger
        ..log('Error initializing Mixpanel: $e', logLevel: MapnessLogLevel.error)
        ..log('StackTrace: $stackTrace', logLevel: MapnessLogLevel.error);
    }

    // Idempotent: the host shell may have configured the facade already.
    BaladyAnalytics.instance.configure(
      mode: BaladyAnalyticsMode.parse(RemoteConfig.baladyAnalyticsMode),
      sink: PosthogBaladyAnalyticsSink.tryCreate(
        host: RemoteConfig.baladyAnalyticsUrl,
        apiKey: RemoteConfig.baladyAnalyticsKey,
      ),
    );
    // First legacy stream under the facade umbrella: events tracked with
    // channels: {..., urbi} keep flowing to balady-metrics.urbi.ae.
    BaladyAnalytics.instance.registerChannel(
      BaladyAnalyticsChannel.urbi,
      UrbiBaladyAnalyticsSink(analyticsClient),
    );
    logger.log('BaladyAnalytics mode: ${BaladyAnalytics.instance.mode.name}');
  }

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();

    final appLink = await _appLinks.getInitialLink();

    // the opened link might trigger duplicate events in uriLinkStream, so we throttle such values
    _linkSubscription = _appLinks.uriLinkStream.throttleTime(const Duration(milliseconds: 500)).listen((
      uri,
    ) {
      if (kDebugMode) {
        logger.log('Deep link received: $uri');
      }
      openAppLink(uri, isFirstRun: appLink != null);
    });
  }

  void initAppIconQuickActionsPending() {
    _scheduleColdStartDelivery(attempt: 0);
  }

  void _scheduleColdStartDelivery({required int attempt}) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) {
        return;
      }
      await ref.read(appIconQuickActionHandlerProvider.notifier).deliverColdStartShortcut();
      if (!mounted) {
        return;
      }
      final stillPending = ref.read(pendingAppIconQuickActionProvider.notifier).hasPending;
      if (stillPending && attempt < 90) {
        _scheduleColdStartDelivery(attempt: attempt + 1);
      }
    });
  }

  Future<void> listenNavigationEvents() async {
    final dgisController = await ref.read(dgisControllerProvider.future);
    if (!mounted) {
      return;
    }
    _navigationEventsListener = dgisController.navigationEvents.listen((
      event,
    ) async {
      if (!mounted) {
        return;
      }
      final segments = ref.read(appRouterProvider).currentSegments;

      final currentRouteName = segments.isEmpty ? null : segments.last.name;

      final isNavPage = currentRouteName == PathNavRoute.name;
      final navigation = event == NavigationEvent.navigation || event == NavigationEvent.routeSearch;
      final routeSearchOptions = (await dgisController.getCurrentNavigationState()).routeSearchOptions;
      if (!mounted) {
        return;
      }
      final isFreeroam = navigation && routeSearchOptions == null;
      if (navigation && !isFreeroam && !isNavPage) {
        await ref
            .read(appRouterProvider)
            .pushAndPopUntil(
              PathNavRoute(
                navType: routeSearchOptions ?? RouteSearchOptionsMessage.car,
                initAction: null,
              ),
              predicate: (route) => route.settings.name == BottomMenuRoute.name,
            );
      }
    });
  }

  Future<void> _delayIfFirstRun({
    required bool isFirstRun,
    Duration duration = const Duration(milliseconds: 300),
  }) async {
    // TODO(ilyasov): Remove this delay after implementing the new poi bottom sheet
    if (isFirstRun) {
      await Future.delayed(duration);
    }
  }

  // implement insider deep link for ios

  Future initInsider() async {
    if (!mounted) {
      return;
    }
    // FIXME-INSIDER: Please change with your partner name and app group.
    await FlutterInsider.Instance.init('baladyapp', 'group.movingViolations', (
      int type,
      data,
    ) {
      switch (type) {
        case InsiderCallbackAction.NOTIFICATION_OPEN:
          // if(Platform.isIOS) {
          final payload = data is Map ? data : null;
          final rawUrl = payload?['url'];
          if (rawUrl is String) {
            final url = Uri.parse(rawUrl);
            openAppLink(url);
            return;
          }

          //  }
          break;
        case InsiderCallbackAction.TEMP_STORE_CUSTOM_ACTION:
          _startupLog('[INSIDER][TEMP_STORE_CUSTOM_ACTION]: $data');
          InsiderCustomActionHandler.handleCustomAction(data);
          break;
        default:
          _startupLog('[INSIDER][InsiderCallbackAction]: Unregistered Action!');
          break;
      }
    });

    // This is an utility method, if you want to handle the push permission in iOS own your own you can omit the following method.
    await FlutterInsider.Instance.setActiveForegroundPushView();
    await FlutterInsider.Instance.registerWithQuietPermission(false);
  }

  // returns null if throws
  Future<bool?> _handleShortLink(Uri uri) async {
    final pathSegments = uri.pathSegments;
    if (pathSegments.length != 1) {
      return false;
    }

    try {
      final code = pathSegments.first;
      final response = await ref
          .read(shortLinkRepositoryProvider)
          .getLinkDetails(code)
          .timeout(const Duration(seconds: 10));
      switch (response) {
        case ShortLinkResponsePoi(:final payload):
          final poiId = int.tryParse(payload.poiId);
          if (poiId != null) {
            final lat = payload.lat;
            final lon = payload.lon;
            final latLon = lat != null && lon != null ? LatLng(latitude: lat, longitude: lon) : null;
            _poiDeeplinkById(poiId, latLon);
          }

        case ShortLinkResponsePoint(:final payload):
          final l10n = ref.read(appLocaleProvider);
          final location = await ref.read(getLocationSyncProvider().future);
          final startPoint = RouteParamsPointWithLabel(
            label: l10n.myLocation,
            value: RouteParamsPoint(latitude: location.latitude, longitude: location.longitude),
          );
          final finishPoint = RouteParamsPointWithLabel(
            label: 'B',
            value: RouteParamsPoint(latitude: payload.lat, longitude: payload.lon),
          );
          ref
              .read(appRouterProvider)
              .replaceOrPush(
                route: RoutingRoutesRoute(points: [startPoint, finishPoint]),
                shouldPopAndPush: true,
                toCompareRoutes: [RoutingRoutesRoute.page, PoiCardWidgetRoute.page],
              );

        case ShortLinkResponseTrip(:final payload):
          ref
              .read(appRouterProvider)
              .replaceOrPush(
                route: RoutingRoutesRoute(
                  points: payload.route.toRouteParamsPointWithLabels(),
                  navType: payload.route.type.toMessage(),
                ),
                shouldPopAndPush: true,
                toCompareRoutes: [RoutingRoutesRoute.page, PoiCardWidgetRoute.page],
              );
      }
      return true;
    } catch (e) {
      logger.log('failed to get short link details: $e', logLevel: MapnessLogLevel.error);
      return null;
    }
  }

  Future<void> openAppLink(Uri uri, {bool isFirstRun = false, bool fromQuickAction = false}) async {
    await initCameraPositionPoint();

    final shortLinkHandled = await _handleShortLink(uri);
    if (shortLinkHandled == null) {
      final ctx = rootNavigatorKey.currentContext;
      if (ctx != null) {
        ToastOverlay.of(ctx).showNoInternet(onRetry: () => openAppLink(uri, isFirstRun: isFirstRun));
      }
      return;
    } else if (shortLinkHandled) {
      return;
    }

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
    final shouldNavigate = BaldayDeeplink.isNavigateEnabled(
      url.queryParameters[BaldayDeeplink.navigateKey],
    );
    final searchText = url.queryParameters[BaldayDeeplink.searchTextKey]?.trim();

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
        final location = (latitude == null || longitude == null)
            ? null
            : LatLng(latitude: latitude, longitude: longitude);
        await _delayIfFirstRun(isFirstRun: isFirstRun);

        await _poiDeeplinkById(id, location);
      }
    } else if (latitude != null && longitude != null) {
      await _delayIfFirstRun(isFirstRun: isFirstRun);
      if (shouldNavigate) {
        // `?q=<lat>,<lon>&navigate=yes` - build a route from the current location to the point
        await _routeToPointDeepLinkHandler(latitude, longitude);
      } else {
        // we agreed to treat absence of objectId as it is My location and open the point immediately
        _myLocationDeepLinkHandler(latitude, longitude);
      }
    } else if (searchText != null && searchText.isNotEmpty) {
      // `?s=<text>` - addresses coming from other apps (e.g. a contact's address)
      await _delayIfFirstRun(isFirstRun: isFirstRun);
      await _searchTextDeepLinkHandler(searchText);
    } else if (momrahId != null) {
      await _momrahDeepLinkHandler(momrahId);
    } else if (homeWidget != null) {
      await _delayIfFirstRun(
        isFirstRun: isFirstRun,
        duration: const Duration(seconds: 8),
      );
      CommonFunctions.openMovingViolations(uri);
    } else if (serviceKey.isNotEmpty && serviceKey != '/poi-map' && serviceKey.startsWith('/app')) {
      String? subPath;
      if (dtId != null && path != null) {
        subPath = '#$path/$dtId';
      } else if (path != null) {
        subPath = '#$path';
      }

      CommonFunctions.openMiniApp(
        serviceKey: serviceKey.replaceAll('/app/', ''),
        path: subPath,
      );
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
      } else if (url.path == '/search') {
        if (fromQuickAction) {
          await _delayIfFirstRun(isFirstRun: isFirstRun);
        }
        await router.push(SearchRoute(requestFocus: fromQuickAction));
      } else if (url.path == '/freeRoam') {
        await _freeRoam();
      } else if (url.path == '/qibla') {
        await _openQibla();
      } else if (url.path == '/shareMyLocation') {
        if (fromQuickAction) {
          await _delayIfFirstRun(isFirstRun: isFirstRun);
        }
        await _shareMyLocation(fromQuickAction: fromQuickAction);
      } else if (url.path == '/shareLiveLocation') {
        if (fromQuickAction) {
          await _delayIfFirstRun(isFirstRun: isFirstRun);
        }
        await _shareLiveLocation(fromQuickAction: fromQuickAction);
      } else if (url.path == '/favourites') {
        if (fromQuickAction) {
          await _delayIfFirstRun(isFirstRun: isFirstRun);
        }
        await _openFavourites(fromQuickAction: fromQuickAction);
      } else if (url.path == '/directions') {
        if (fromQuickAction) {
          await _delayIfFirstRun(isFirstRun: isFirstRun);
        }
        await _openDirections(fromQuickAction: fromQuickAction);
      } else if (url.path == '/contribute') {
        if (fromQuickAction) {
          await _delayIfFirstRun(isFirstRun: isFirstRun);
        }
        await _openContribute(fromQuickAction: fromQuickAction);
      } else if (url.path == '/athkar') {
        await _openAthkar();
      } else if (url.path == '/quran') {
        await _openQuran();
      } else if (url.path == '/snapSend') {
        if (fromQuickAction) {
          await _delayIfFirstRun(isFirstRun: isFirstRun);
        }
        await _openSnapSend(fromQuickAction: fromQuickAction);
      } else if (url.path == '/miniApps') {
        if (params['groupId'] != null) {
          CommonFunctions.openMiniAppGroupId(
            groupId: params['groupId'].toString(),
          );
        } else if (params['key'] != null) {
          CommonFunctions.openMiniApp(serviceKey: params['key'].toString());
        }
        await router.push(MapnessServicesRoute());
      } else if (url.path == '/parking') {
        _openParking();
      } else if (url.path == '/media') {
        _openMediaCatelog();
      } else {
        await router.pushPath(url.toString());
      }
    }
  }

  Future<void> _handleCityEvent(String cityEventName) async {
    var eventHandled = true;
    // check here for other city events if they come up in the future
    switch (cityEventName) {
      case WRC.deeplinkEventValue:
        await ref.read(wRCProvider.notifier).moveCameraToEventArea();
      default:
        eventHandled = false;
    }

    final AppRouter router = await ref.read(appRouterProvider);
    final areStoriesOpen = ref.read(storiesOpenStateProvider);
    // if we come from stories we must close them for nice user experience
    if (eventHandled && areStoriesOpen && router.canPop()) {
      await router.topMostRouter().maybePop();
      ref.read(bottomSheetControllerProvider.notifier).state.controller?.setState(ThreeStateSheet.hidden);
    }
  }

  Future<void> _openRegisterPage() async {
    await CommonFunctions.onLogin();
  }

  Future<void> _openMediaCatelog() async {
    final AppRouter router = await ref.watch(appRouterProvider);
    await router.push(const MediaCatalogRoute());
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

  Future<void> _shareMyLocation({bool fromQuickAction = false}) async {
    if (fromQuickAction) {
      await ref.read(appRouterProvider).push(ShareMyLocationRoute());
      return;
    }

    final context = rootNavigatorKey.currentContext;
    if (context == null || !context.mounted) {
      return;
    }
    await ref
        .read(authMethodsProvider.notifier)
        .authAndOpen(
          context,
          callback: () async {
            await ref.read(appRouterProvider).push(ShareMyLocationRoute());
          },
        );
  }

  Future<void> _shareLiveLocation({bool fromQuickAction = false}) async {
    ref.read(shareMyLocationLaunchIntentProvider.notifier).requestLiveLocationOptions();
    await _shareMyLocation(fromQuickAction: fromQuickAction);
  }

  Future<void> _openFavourites({bool fromQuickAction = false}) async {
    if (fromQuickAction) {
      await ref.read(appRouterProvider).push(const FavouritesRoute());
      return;
    }

    final context = rootNavigatorKey.currentContext;
    if (context == null || !context.mounted) {
      return;
    }
    await ref
        .read(authMethodsProvider.notifier)
        .authAndOpen(
          context,
          callback: () => ref.read(appRouterProvider).push(const FavouritesRoute()),
        );
  }

  Future<void> _openDirections({bool fromQuickAction = false}) async {
    if (fromQuickAction) {
      final allowed = await ref.read(locationProvider.notifier).checkLocationPermission();
      if (!allowed) {
        return;
      }
      await ref.read(appRouterProvider).navigate(const RoutingPointsRoute());
      return;
    }

    final context = rootNavigatorKey.currentContext;
    if (context == null || !context.mounted) {
      return;
    }
    await ref
        .read(authMethodsProvider.notifier)
        .authAndOpen(
          context,
          callback: () async {
            final allowed = await ref.read(locationProvider.notifier).checkLocationPermission();
            if (!allowed) {
              return;
            }
            await ref.read(appRouterProvider).navigate(const RoutingPointsRoute());
          },
        );
  }

  Future<void> _openContribute({bool fromQuickAction = false}) async {
    final router = ref.read(appRouterProvider);
    if (!fromQuickAction) {
      ref.read(appAnalyticsProvider).quickActionSelected('contribute');
    }
    await router.push(const ContributeRoute());
  }

  Future<void> _openQibla() async {
    final AppRouter router = await ref.watch(appRouterProvider);
    ref.read(appAnalyticsProvider).quickActionSelected('qibla');
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
    ServiceEvents.setPendingOpenSource(ServiceEvents.sourceQuickAction);
    CommonFunctions.openMiniApp(serviceKey: 'Quran');
  }

  Future<void> _openAthkar() async {
    ref.read(appAnalyticsProvider).quickActionSelected('athkar');
    // await NavigationService.navigatorKey.currentState?.pushNamed(RouteName.mainAthkarPage);
    ServiceEvents.setPendingOpenSource(ServiceEvents.sourceQuickAction);
    CommonFunctions.openMiniApp(serviceKey: 'Athkar');
  }

  Future<void> _openSnapSend({bool fromQuickAction = false}) async {
    if (!fromQuickAction) {
      CommonFunctions.sendAnalyticsEvent(
        AnalyticsEvents.SnapAndSend_Open_From_Home_Event,
      );
    } else {
      ServiceEvents.setPendingOpenSource(ServiceEvents.sourceQuickAction);
    }
    CommonFunctions.openMiniApp(serviceKey: 'snapandsend');
    // await NavigationService.navigatorKey.currentState!.pushNamed(
    //   RouteName.vDAllTypesScreen,
    // );
  }

  Future<void> _openQuickFilter(String filter) async {
    final AppRouter router = await ref.watch(appRouterProvider);
    final quickFilter = QuickFilter.values.firstWhereOrNull(
      (element) => element.name.toLowerCase() == filter.toLowerCase(),
    );
    final NaviQuickFilterMore? naviFilter = quickFilter == null
        ? NaviQuickFilterMore.values.firstWhereOrNull(
            (element) => element.name.toLowerCase() == filter.toLowerCase(),
          )
        : null;

    if (quickFilter == null && naviFilter == null) return;

    final String filterName = quickFilter?.name ?? naviFilter!.name;
    unawaited(
      ref.read(urbiAnalyticsProvider).track('quickFilterSearch', properties: {'filter': filterName}),
    );
    ref.read(appAnalyticsProvider).categorySelected(filterName);
    ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetricsKeys.exploreSearch);

    final language = ref.read(appLanguageProvider);

    final String? query = quickFilter?.query[language] ?? naviFilter?.query[language];
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
      final searchNotifier = ref.read(searchProvider(SearchScopeEnum.map.value).notifier);

      if (quickFilter != null) {
        searchNotifier.quickSearch(quickFilter);
      } else if (naviFilter != null) {
        searchNotifier.searchByText(naviFilter.name);
      }
    });
  }

  Future<void> _openStories(String id) async {
    final AppRouter router = await ref.watch(appRouterProvider);

    ref.read(storiesOpenStateProvider.notifier).open();

    await router.push(
      StoriesRoute(
        type: StoryTypes.network,
        initialStoryId: id,
        onClose: ref.read(storiesOpenStateProvider.notifier).close,
      ),
    );
  }

  Future<void> _poiDeeplinkById(int dgisObjectId, [LatLng? location]) async {
    final appRouter = ref.watch(appRouterProvider);
    final storeParkingData = await ref.read(
      parkingManageProvider(theme: context.read<ThemeController>().currentTheme).future,
    );
    final isParkingPoi = dgisObjectId == parkingObjectId;

    if (isParkingPoi && storeParkingData == null) {
      if (location != null) {
        await _poiDeepLinkByCoords(location.latitude, location.longitude);
      }
      return;
    }

    await appRouter.replaceOrPush(
      route: PoiCardWidgetRoute(
        objectId: DgisObjectIdMessage(objectId: dgisObjectId, entranceId: 0),
        closestPoint: location,
        cameraConfig: const PoiCameraConfig(zoom: 17),
      ),
      toCompareRoutes: [RoutingRoutesRoute.page, PoiCardWidgetRoute.page],
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
      await appRouter.push(
        DeeplinkRoute(
          closestPoint: LatLng(latitude: latitude, longitude: longitude),
          cameraConfig: const PoiCameraConfig(zoom: 17),
        ),
      );
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

    await ref
        .watch(appRouterProvider)
        .replaceOrPush(
          route: PoiCardWidgetRoute(
            objectId: DgisObjectIdMessage(objectId: dgisId, entranceId: 0),
            cameraConfig: const PoiCameraConfig(zoom: 17),
          ),
          toCompareRoutes: [PoiCardWidgetRoute.page],
        );
  }

  void _myLocationDeepLinkHandler(double latitude, double longitude) {
    final latLng = LatLng(latitude: latitude, longitude: longitude);
    ref
        .watch(appRouterProvider)
        .push(
          DeeplinkRoute(
            closestPoint: latLng,
            cameraConfig: const PoiCameraConfig(zoom: 17),
          ),
        );
  }

  /// `?q=<lat>,<lon>&navigate=yes` - draws a route from the current location to
  /// the requested point. Falls back to showing the point when the current
  /// location is not available (permission denied, timeout, ...).
  Future<void> _routeToPointDeepLinkHandler(double latitude, double longitude) async {
    try {
      final l10n = ref.read(appLocaleProvider);
      final location = await ref.read(getLocationSyncProvider().future);
      if (!mounted) {
        return;
      }

      final startPoint = RouteParamsPointWithLabel(
        label: l10n.myLocation,
        value: RouteParamsPoint(latitude: location.latitude, longitude: location.longitude),
      );
      final finishPoint = RouteParamsPointWithLabel(
        label: 'B',
        value: RouteParamsPoint(latitude: latitude, longitude: longitude),
      );

      ref
          .read(appRouterProvider)
          .replaceOrPush(
            route: RoutingRoutesRoute(points: [startPoint, finishPoint]),
            shouldPopAndPush: true,
            toCompareRoutes: [RoutingRoutesRoute.page, PoiCardWidgetRoute.page],
          );
    } catch (e) {
      logger.log('failed to build route from deeplink: $e', logLevel: MapnessLogLevel.error);
      if (mounted) {
        _myLocationDeepLinkHandler(latitude, longitude);
      }
    }
  }

  /// `?s=<text>` - opens the search sheet with the query prefilled and runs it,
  /// used for free-text addresses shared from other apps.
  Future<void> _searchTextDeepLinkHandler(String query) async {
    final AppRouter router = await ref.watch(appRouterProvider);

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

    unawaited(router.push(SearchRoute(requestFocus: false)));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      ref.read(searchProvider(SearchScopeEnum.map.value).notifier).searchByText(query);
    });
  }

  Future<void> _momrahDeepLinkHandler(String momrahId) async {
    final env = await ref.read(dgisEnvironmentProvider.future);
    final dio = ref.read(baseDioProvider);

    final twinsUrl = BaldayDeeplink.twinsUrl(env.twinsApi);

    final twinsResponse = await dio.get(
      twinsUrl,
      queryParameters: {
        BaldayDeeplink.keyKey: BaldayDeeplink.momrahTwinsKey,
        BaldayDeeplink.momrahPartnerCodeKey: BaldayDeeplink.momrahPartnerCodeValue,
        BaldayDeeplink.momrahPartnerCodeId: momrahId,
      },
    );
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
    await appRouter.push(
      PoiCardWidgetRoute(
        objectId: DgisObjectIdMessage(objectId: dgisId, entranceId: 0),
        cameraConfig: const PoiCameraConfig(zoom: 17),
      ),
    );
  }
}

Future<void> setupMapness(EnvType envType) async {
  final vendorConfigLocal = await AppConfigLoader.getAppConfig();
  final vendorConfigContentMessage = VendorConfigContentMessage(
    content: vendorConfigLocal,
  );

  await initialiseDGis(
    logOptions: LogOptionsMessage(
      // systemLevel: LogLevelMessage.fatal,
      // customLevel: LogLevelMessage.fatal,
      systemLevel: LogLevelMessage.verbose,
      customLevel: LogLevelMessage.verbose,
    ),
    configContent: vendorConfigContentMessage,
  );

  _initBytePlus(envType);
}

/// Initializes the BytePlus RangersAppLog SDK (DataFinder analytics).
///
/// Config is read per-flavor from the loaded `.env.<flavor>` file via
/// [RemoteConfig] (same pattern as APIGEE/SSO). Each flavor points at the right
/// BytePlus project through its own `BYTEPLUS_APP_ID`:
///  * `.env.prod` → production project `Balady` (10000002),
///  * `.env.stg` / `.env.pre` / `.env.dev` → `Balady Staging Test` (10000000).
///
/// Only real production traffic goes to the production project; pre-prod and all
/// lower environments report to staging so they don't pollute prod analytics.

/// Guards against initializing the BytePlus SDK more than once — `setupMapness`
/// can run twice (e.g. the engine re-attaches), and a second `initRangersAppLog`
/// triggers a duplicate device-register / session.
bool _bytePlusInitialized = false;

void _initBytePlus(EnvType envType) {
  if (_bytePlusInitialized) {
    return;
  }

  final isProduction = envType == EnvType.prod;
  final appId = RemoteConfig.bytePlusAppId;
  final channel = RemoteConfig.bytePlusChannel;

  if (appId.isEmpty) {
    debugPrint('[BytePlus] Skipped: BYTEPLUS_APP_ID not set in .env.${envType.name}.');
    return;
  }

  try {
    RangersApplogFlutterPlugin.initRangersAppLog(
      appId,
      channel,
      true, // enableAb
      false, // enableEncrypt
      !isProduction, // enableLog: verbose on stg/dev, quiet on prod
      'https://balady.finder-snssdk.bytepluses.com',
    );
    _bytePlusInitialized = true;
    debugPrint('[BytePlus] RangersAppLog initialized — AppID=$appId, channel=$channel');
  } catch (e) {
    debugPrint('[BytePlus] Init failed: $e');
  }
}

Future<void> enableInsiderGeofenceAfterConsent() async {
  //! Ensure OS permissions
  final locationEnabled = await Geolocator.isLocationServiceEnabled();
  if (!locationEnabled) {
    return;
  }

  LocationPermission perm = await Geolocator.checkPermission();
  if (perm == LocationPermission.denied) {
    perm = await Geolocator.requestPermission();
  }
  if (perm == LocationPermission.deniedForever) {
    return;
  }

  final isOk = perm == LocationPermission.always || perm == LocationPermission.whileInUse;
  if (!isOk) {
    return;
  }

  //! Set Insider location
  await FlutterInsider.Instance.enableLocationCollection(true);

  //! IOS background switch
  await FlutterInsider.Instance.setAllowsBackgroundLocationUpdates(true);

  //! Start geofence
  await FlutterInsider.Instance.startTrackingGeofence();
}

void _startupLog(String message) {
  if (kDebugMode) {
    debugPrint(message);
  }
}

Future<void> runMapnessApp(
  EnvType envType,
  FutureOr<void> Function() main,
) async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    _startupLog('runMapnessApp: Starting initialization...');
    await initHive();
    _startupLog('runMapnessApp: Hive initialized');

    final hostFlutterApi = _HostFlutterApi();
    HostFlutterApi.setUp(hostFlutterApi);
    _startupLog('runMapnessApp: HostFlutterApi set up, waiting for runMain()...');

    await AppConfigLoader.init(envType);
    _startupLog('runMapnessApp: AppConfigLoader initialized');

    // Add timeout to prevent infinite waiting
    await hostFlutterApi.appRunCompleter.future.timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        _startupLog('runMapnessApp: WARNING - Timeout waiting for runMain() from native side');
        // Complete manually if timeout occurs (this might indicate the native side already called it)
        if (!hostFlutterApi.appRunCompleter.isCompleted) {
          hostFlutterApi.appRunCompleter.complete();
        }
      },
    );
    _startupLog('runMapnessApp: runMain() received, proceeding to main()');

    await initAppIconQuickActionsBridge();
    _startupLog('runMapnessApp: App icon quick actions bridge initialized');

    await main();
    _startupLog('runMapnessApp: main() completed');
  } catch (e, stackTrace) {
    try {
      logger
        ..log('Error in runMapnessApp: $e', logLevel: MapnessLogLevel.error)
        ..log('StackTrace: $stackTrace', logLevel: MapnessLogLevel.error);
    } catch (_) {
      // Logger might not be initialized yet
    }
    rethrow;
  }
}

Future<void> initHive() async {
  try {
    _startupLog('initHive: Starting Hive initialization...');
    await Hive.initFlutter();
    _startupLog('initHive: Hive.initFlutter() completed');
    Hive
      ..registerAdapter(SearchHistoryItemAdapter())
      ..registerAdapter(FavoriteCacheItemAdapter())
      ..registerAdapter(HiveCoordinatesAdapter())
      ..registerAdapter(HiveFavouriteItemEntityAdapter())
      ..registerAdapter(FavoriteCacheStateAdapter());
    _startupLog('initHive: All adapters registered');
  } catch (e, stackTrace) {
    try {
      logger
        ..log('Error initializing Hive: $e', logLevel: MapnessLogLevel.error)
        ..log('StackTrace: $stackTrace', logLevel: MapnessLogLevel.error);
    } catch (_) {
      // Logger might not be initialized yet
    }
    // Re-throw to prevent app from continuing with broken Hive
    rethrow;
  }
}

class _HostFlutterApi extends HostFlutterApi {
  final appRunCompleter = Completer();

  _HostFlutterApi();

  bool isAppRun = false;

  @override
  void analyticsTrack(String event) {
    analyticsClient.track(event, properties: {'app_run': isAppRun});
  }

  @override
  void runMain() {
    _startupLog('_HostFlutterApi.runMain() called from native side');
    isAppRun = true;
    if (!appRunCompleter.isCompleted) {
      appRunCompleter.complete();
      _startupLog('_HostFlutterApi.runMain() - completer completed');
    } else {
      _startupLog('_HostFlutterApi.runMain() - completer already completed');
    }
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
