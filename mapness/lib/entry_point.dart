import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/debug_overlay/debug_overlay.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mapness/_features/common/widgets/eager_init_widget.dart';
import 'package:mapness/entities/search/models/search_history.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/widgets/map/map_page.dart';

import 'app/router.dart';

class MapnessProviderScope extends StatelessWidget {
  const MapnessProviderScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(child: EagerInitWidget(child: child));
  }
}

class MapnessEntryPoint extends ConsumerStatefulWidget {
  final List<Widget> navigationRoutes;
  const MapnessEntryPoint(this.navigationRoutes, {super.key});

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
        builder: (context) => ProviderScope(
          parent: ProviderScope.containerOf(context),
          child: const DebugOverlay(),
        ),
      );
      Overlay.of(context, rootOverlay: true).insert(_debugOverlay!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final goRouter = ref.watch(goRouterProvider(widget.navigationRoutes));
    final language = ref.watch(appLanguageProvider);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Stack(
        children: [
          const MapPage(),
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
}

Future<void> setupMapness() async {
  await initialiseDGis(
    logOptions: LogOptionsMessage(
      systemLevel: LogLevelMessage.verbose,
      customLevel: LogLevelMessage.verbose,
      customSink: "BaladyDGis",
    ),
  );
  await Hive.initFlutter();
  Hive.registerAdapter(
    SearchHistoryItemAdapter(),
  );
}
