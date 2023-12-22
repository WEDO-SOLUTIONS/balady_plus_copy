import 'package:balady_plus/app/core/utils/constants/apis/env_types.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/_features/debug_overlay/debug_overlay.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mapness/_features/common/widgets/eager_init_widget.dart';
import 'package:mapness/entities/search/models/search_history.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/widgets/map/map_page.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

import 'app/router.dart';

late Mixpanel? mixpanel;

class MapnessProviderScope extends StatelessWidget {
  const MapnessProviderScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(child: EagerInitWidget(child: child));
  }
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
  OverlayEntry? _debugOverlay;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
    initMixpanel();
    mixpanel?.actionLog();
  }

  @override
  Widget build(BuildContext context) {
    final goRouter = ref.watch(goRouterProvider);
    final language = ref.watch(appLanguageProvider);
    final direction = ref.watch(uiDirectionProvider);

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
              unselectedWidgetColor: const Color(0xFF1E2A36),
              scaffoldBackgroundColor: Colors.transparent,
              dividerColor: Colors.grey[400],
              useMaterial3: false,
              extensions: <ThemeExtension<dynamic>>[
                ThemeTextStyles.arabic(isDark: false),
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
      "2d045d85e25087812e92c62b84d6fbc3",
      trackAutomaticEvents: true,
      optOutTrackingDefault: false,
    );
    mixpanel?.setLoggingEnabled(true);
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
  Hive.registerAdapter(
    SearchHistoryItemAdapter(),
  );
  final box = await Hive.openBox("envType");
  final env = switch (envType) {
    EnvType.dev => "dev",
    EnvType.stg => "stg",
    EnvType.pre => "pre",
    EnvType.prod => "prod",
    EnvType.urbiPre => "urbiPre",
  };
  await box.put("envType", env);
}
