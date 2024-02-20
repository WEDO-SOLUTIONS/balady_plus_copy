import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:balady_plus/app/core/utils/constants/apis/env_types.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_uikit/colors/app_color_scheme.dart';
import 'package:balady_uikit/colors/app_colors_theme.dart';
import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/_features/common/widgets/eager_init_widget.dart';
import 'package:mapness/_features/debug_overlay/debug_overlay.dart';
import 'package:mapness/entities/search/models/search_history.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/l10n/generated/app_localizations_ar.dart';
import 'package:mapness/l10n/generated/app_localizations_en.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/debug_state.dart';
import 'package:mapness/widgets/map/map_page.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart' as provider;
import 'package:share_plus/share_plus.dart';

import 'app/router.dart';

Mixpanel? mixpanel;

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
  final void Function(DgisMapController) mapCreated;

  const MapnessEntryPoint({
    required this.mapCreated,
    super.key,
  });

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
          MaterialApp.router(
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
              // unselectedWidgetColor: context.color.text_and_icons_base_primary,
              scaffoldBackgroundColor: Colors.transparent,
              dividerColor: Colors.grey[400],
              useMaterial3: false,
              extensions: <ThemeExtension<dynamic>>[
                ThemeTextStyles.arabic(isDark: false),
                AppColorsThemeExt.palette(AppColorScheme.main, isDark: false),
              ],
            ),
            locale: language.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            debugShowCheckedModeBanner: false,
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
    final FlutterUxConfig config = FlutterUxConfig(
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
      openAppLink(appLink);
    }

    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      if (kDebugMode) {
        print('_linkSubscription $uri');
      }
      openAppLink(uri);
    });
  }

  void openAppLink(Uri uri) {
    ref.read(goRouterProvider).push(uri.fragment);
  }
}

Future<void> setupMapness(EnvType envType) async {
  final vendorConfig = switch (envType) {
    EnvType.stg => VendorConfigMessage.momrahProd,
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
  Hive.registerAdapter(
    SearchHistoryItemAdapter(),
  );
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
