import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/debug_overlay/debug_overlay.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mapness/_features/common/widgets/eager_init_widget.dart';
import 'package:mapness/entities/search/models/search_history.dart';

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
  OverlayEntry? _debugOverlay = null;

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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: MaterialApp.router(
        routerConfig: goRouter,
        theme: ThemeData(
          primarySwatch: Colors.green,
          unselectedWidgetColor: Colors.grey,
          appBarTheme: const AppBarTheme(
            elevation: 2.0,
            centerTitle: true,
          ),
          scaffoldBackgroundColor: Colors.grey[200],
          dividerColor: Colors.grey[400],
        ),
        debugShowCheckedModeBanner: false,
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
