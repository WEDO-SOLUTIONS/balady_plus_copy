import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/first_start.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/navigation_controls_visibility.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';

@RoutePage()
class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  final int _keyIndex = 0;
  bool _needRefresh = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // We show toast on the map (not in MapnessEntryPoint) because it must be shown only when the map is visible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initToastMessage();
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (_needRefresh && state == AppLifecycleState.resumed) {
      setState(() {
        _needRefresh = false;
      });
    }
  }

  @override
  void didHaveMemoryPressure() {
    setState(() {
      _needRefresh = true;
    });
    super.didHaveMemoryPressure();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final dgisController = ref.watch(dgisControllerProvider.notifier);

    ref.watch(selectedMarkerProvider);
    final settings = MapObjectManagerSettings.selectedMarker();
    ref.watch(
      mapObjectManagerProvider(
        named: settings.name,
        layerId: settings.layerId,
      ).notifier,
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: (_) => ref.read(navigationControlsVisibilityProvider.notifier).registerInteraction(),
          onPointerSignal: (_) => ref.read(navigationControlsVisibilityProvider.notifier).registerInteraction(),
          child: DgisMap(
            key: ValueKey(_keyIndex),
            androidUseExpensive: true,
            onMapCreated: (controller) async {
              await dgisController.onMapCreated(controller);
              Future.delayed(const Duration(seconds: 3), () {
                if (!mounted) return;
                ref.read(layersControlsProvider.notifier).showActiveLayerOnMap();
              });
            },
          ),
        ),
        Positioned.fill(
          top: null,
          child: Container(
            color: context.colors.backgroundSurface2,
            height: MediaQuery.of(context).viewPadding.bottom,
          ),
        ),
        const SafeArea(top: false, child: AutoRouter()),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _initToastMessage() async {
    final isFirstStart = ref.read(firstStartProvider);
    if (!isFirstStart) {
      return;
    }

    ToastOverlay.of(context).show(
      title: context.l10n.darkModeToastMessage,
      isDismissible: true,
      actions: [
        ToastAction(
          title: context.l10n.darkModeToastAction,
          onTap: () {
            ref
                .read(appRouterProvider)
                .push(
                  const DarkMapRoute(),
                );
          },
        ),
      ],
      icon: ToastIconData(GeneralIcons.darkMode, color: context.themeRead.colors.foregroundSoft),
    );
  }
}
