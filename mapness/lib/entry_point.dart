// ignore_for_file: always_put_control_body_on_new_line

import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:balady_plus/app/core/utils/constants/apis/env_types.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_uikit/core/colors/app_colors_theme.dart';
import 'package:balady_uikit/core/typography/text_theme_styles.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapness/_features/common/providers/color_scheme.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/_features/common/widgets/eager_init_widget.dart';
import 'package:mapness/_features/debug_overlay/debug_overlay.dart';
import 'package:mapness/_features/favourites/entity/models/favorite_cache_item.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/app/routes/poi_map.dart';
import 'package:mapness/entities/search/models/search_history.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/l10n/generated/app_localizations_ar.dart';
import 'package:mapness/l10n/generated/app_localizations_en.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/base_dio.dart';
import 'package:mapness/shared/providers/debug_state.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/providers/vendor_config.dart';
import 'package:mapness/widgets/map/map_page.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart' as provider;
import 'package:share_plus/share_plus.dart';

Mixpanel? mixpanel;

class MapnessRouteObserver extends RouteObserver<ModalRoute<void>> {
  static final MapnessRouteObserver _instance =
      MapnessRouteObserver._internal();

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
              final goRouter = ref.watch(goRouterProvider);
              final language = ref.watch(appLanguageProvider);
              final localizations = language == Language.arabic
                  ? AppLocalizationsAr()
                  : AppLocalizationsEn();

              return provider.MultiProvider(
                providers: [
                  provider.Provider<GoRouter>.value(value: goRouter),
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
  // ignore: use_late_for_private_fields_and_variables
  OverlayEntry? _debugOverlay;
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    initMixpanel();
    initDeepLinks();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final goRouter = ref.watch(goRouterProvider);
    final language = ref.watch(appLanguageProvider);
    final direction = ref.watch(uiDirectionProvider);

    ref.listen(debugStateProvider, (previous, next) {
      if (!next || (previous ?? false)) {
        return;
      }

      _debugOverlay = OverlayEntry(
        builder: (context) => Theme(
          data: Theme.of(context),
          child: ProviderScope(
            parent: ProviderScope.containerOf(context),
            child: const DebugOverlay(),
          ),
        ),
      );
      Overlay.of(context, rootOverlay: true).insert(_debugOverlay!);
    });

    return Directionality(
      textDirection: direction,
      child: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: const MapPage(),
          ),
          Consumer(
            builder: (context, ref, child) {
              final colorScheme = ref.watch(colorSchemeProvider);

              return MaterialApp.router(
                routerConfig: goRouter,
                theme: ThemeData(
                  primarySwatch: const MaterialColor(
                    0xFF4CA5B4,
                    <int, Color>{
                      50: Color(0xFF89cfbe),
                      100: Color(0xFF89cfbe),
                      200: Color(0xFF89cfbe),
                      300: Color(0xFF89cfbe),
                      400: Color(0xFF89cfbe),
                      500: Color(0xFF89cfbe),
                      600: Color(0xFF89cfbe),
                      700: Color(0xFF89cfbe),
                      800: Color(0xFF89cfbe),
                      900: Color(0xFF89cfbe),
                    },
                  ),
                  // unselectedWidgetColor: context.color.textAndIconsBasePrimary,
                  scaffoldBackgroundColor: Colors.transparent,
                  dividerColor: Colors.grey[400],
                  useMaterial3: false,
                  extensions: <ThemeExtension<dynamic>>[
                    ThemeTextStyles.arabic(),
                    AppColorsThemeExt.palette(colorScheme, isDark: false)
                  ],
                ),
                locale: language.locale,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                debugShowCheckedModeBanner: false,
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> initMixpanel() async {
    mixpanel = await Mixpanel.init(
      '2d045d85e25087812e92c62b84d6fbc3',
      trackAutomaticEvents: true,
    );
    mixpanel?.setLoggingEnabled(true);
    final config = FlutterUxConfig(
      enableAdvancedGestureRecognition: true,
      enableCrashHandling: true,
      enableMultiSessionRecord: true,
      enableNetworkLogging: true,
      userAppKey: '2w1otnta9bvvhzo',
      enableAutomaticScreenNameTagging: false,
    );
    await FlutterUxcam.startWithConfiguration(config);
  }

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();

    final appLink = await _appLinks.getInitialAppLink();
    if (appLink != null) {
      await openAppLink(appLink);
    }

    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      if (kDebugMode) {
        print('_linkSubscription $uri');
      }
      openAppLink(uri);
    });
  }

  Future<void> openAppLink(Uri uri) async {
    final url = Uri.parse(uri.fragment);
    final momrahId = url.queryParameters['momrah-id'];
    final lat = url.queryParameters['lat'];
    final lon = url.queryParameters['lon'];
    final type = url.queryParameters['type'];

    if (lat != null && lon != null) {
      if (type != null && type == 'my-location') {
        await _myLocationDeepLinkHandler(double.parse(lat), double.parse(lon));
      } else {
        await _poiDeepLinkHandler(double.parse(lat), double.parse(lon));
      }
    } else if (momrahId != null) {
      await _momrahDeepLinkHandler(momrahId);
    } else {
      await ref.read(goRouterProvider).push(url.toString());
    }
  }

  Future<void> _poiDeepLinkHandler(double latitude, double longitude) async {
    const vendorConfigKey =
        'dgis/native-sdk/keys/user_web_api_key_for_on_premise';
    const catalogKey = 'Modules/directory/webapi_url';

    final vendorConfig = await ref.read(vendorConfigProvider.future);
    final dio = ref.read(baseDioProvider);

    final catalogApi = vendorConfig[catalogKey];
    final key = vendorConfig[vendorConfigKey];

    final geocodeUrl = '$catalogApi/3.0/items/geocode';

    final geocoderResponse = await dio.get(
      geocodeUrl,
      queryParameters: {
        'lon': longitude,
        'lat': latitude,
        'fields': 'items.point',
        'key': key,
      },
    );
    final data = geocoderResponse.data as Map<String, dynamic>;

    if (!data.containsKey('result')) return;

    final result = data['result'] as Map<String, dynamic>;
    if (!result.containsKey('items')) return;

    final items = result['items'] as List<dynamic>;
    if (items.isEmpty) return;

    final geocoderBest = items.first as Map<String, dynamic>;
    if (!geocoderBest.containsKey('id')) return;

    final dgisId = int.tryParse(geocoderBest['id']);
    if (dgisId == null) return;

    PoiMapRoute.open(
      ref.read(goRouterProvider),
      dgisId,
      zoom: 17,
    );
  }

  Future<void> _myLocationDeepLinkHandler(
      double latitude, double longitude) async {
    final latLng = LatLng(latitude: latitude, longitude: longitude);
    PoiMapRoute.open(
      ref.read(goRouterProvider),
      -2,
      latLng: latLng,
    );
  }

  Future<void> _momrahDeepLinkHandler(String momrahId) async {
    final env = await ref.read(dgisEnvironmentProvider.future);
    final dio = ref.read(baseDioProvider);

    final twinsUrl = '${env.twinsApi}/twins/search/partners';

    final twinsResponse = await dio.get(twinsUrl, queryParameters: {
      'key': 'dfdd94df-49f9-45df-84ec-e8870ebdb9a0',
      'partner_code': 'momrah',
      'partner_id': momrahId,
    });
    final data = twinsResponse.data as Map<String, dynamic>;

    if (!data.containsKey('result')) return;

    final result = data['result'] as Map<String, dynamic>;
    if (!result.containsKey('items')) return;

    final items = result['items'] as List<dynamic>;
    if (items.isEmpty) return;

    final item = items.first as Map<String, dynamic>;
    if (!item.containsKey('twins')) return;

    final twins = item['twins'] as List<dynamic>;
    if (twins.isEmpty) return;

    final twin = twins.first as Map<String, dynamic>;
    if (!twin.containsKey('dgis_id')) return;

    final dgisId = int.tryParse(twin['dgis_id']);
    if (dgisId == null) return;

    PoiMapRoute.open(
      ref.read(goRouterProvider),
      dgisId,
      zoom: 17,
    );
  }
}

Future<void> setupMapness(EnvType envType) async {
  final vendorConfig = switch (envType) {
    EnvType.stg => VendorConfigMessage.momrahStg,
    EnvType.pre || EnvType.prod => VendorConfigMessage.momrahProd,
    EnvType.urbiPre || EnvType.dev => VendorConfigMessage.urbiPreProd,
  };

  await initialiseDGis(
    logOptions: LogOptionsMessage(
      systemLevel: LogLevelMessage.fatal,
      customLevel: LogLevelMessage.fatal,
    ),
    config: vendorConfig,
  );

  await Hive.initFlutter();

  // Initialize hive adapters
  Hive
    ..registerAdapter(SearchHistoryItemAdapter())
    ..registerAdapter(FavoriteCacheItemAdapter())
    ..registerAdapter(HiveCoordinatesAdapter())
    ..registerAdapter(HiveFavouriteItemEntityAdapter())
    ..registerAdapter(FavoriteCacheStateAdapter());

  final box = await Hive.openBox('envType');
  final env = switch (envType) {
    EnvType.dev => 'dev',
    EnvType.stg => 'stg',
    EnvType.pre => 'pre',
    EnvType.prod => 'prod',
    EnvType.urbiPre => 'urbiPre',
  };
  await box.put('envType', env);
}

class MapnessLogger {
  static late File _logsFile;

  static Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    _logsFile = File('${directory.path}/balady-logs.txt');

    await _logsFile.writeAsString('');
  }

  static void append(String line) {
    _logsFile.writeAsString('$line\n', mode: FileMode.append);
  }

  static void share() {
    Share.shareXFiles(
      [
        XFile(_logsFile.path),
      ],
    );
  }
}

Future<void> runMapnessApp(FutureOr<void> Function() main) async {
  await Zone.current.fork(
    specification: ZoneSpecification(
      print: (self, parent, zone, line) {
        MapnessLogger.append(line);
        parent.print(zone, line);
      },
    ),
  ).run(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await MapnessLogger.init();

    await main();
  });
}
