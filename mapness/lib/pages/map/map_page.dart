import 'dart:io';

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
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/providers/first_start.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/map_recreation.dart';
import 'package:mapness/shared/providers/map/map_swap_curtain.dart';
import 'package:mapness/shared/providers/map/navigation_controls_visibility.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';
import 'package:mapness/shared/providers/map/tunnel_state.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';

@RoutePage()
class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver, AutoRouteAwareStateMixin<MapPage> {
  bool _needRefresh = false;

  @override
  void initState() {
    super.initState();
    _trace('initState');
    WidgetsBinding.instance.addObserver(this);
    // We show toast on the map (not in MapnessEntryPoint) because it must be shown only when the map is visible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initToastMessage();
    });
  }

  @override
  void dispose() {
    _trace('dispose');
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didPushNext() {
    _trace('didPushNext');
  }

  @override
  void didPopNext() {
    _trace('didPopNext');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _trace('appLifecycle=$state');
    if (_needRefresh && state == AppLifecycleState.resumed) {
      setState(() {
        _needRefresh = false;
      });
    }
  }

  @override
  void didHaveMemoryPressure() {
    _trace('memoryPressure-before');
    setState(() {
      _needRefresh = true;
    });
    super.didHaveMemoryPressure();
    _trace('memoryPressure-after');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final dgisController = ref.watch(dgisControllerProvider.notifier);
    // Recreation counter drives the DgisMap ValueKey; bumping it tears down
    // the native MapView so the 2GIS SDK drops its process-scoped GLB cache.
    // See [MapRecreationCounter].
    final recreationKey = ref.watch(mapRecreationCounterProvider);

    ref.watch(selectedMarkerProvider);
    final settings = MapObjectManagerSettings.selectedMarker();
    ref.watch(
      mapObjectManagerProvider(
        named: settings.name,
        layerId: settings.layerId,
      ).notifier,
    );

    if (Platform.isAndroid) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (_) {
              _trace('pointerDown android');
              ref.read(navigationControlsVisibilityProvider.notifier).registerInteraction();
            },
            onPointerSignal: (_) => ref.read(navigationControlsVisibilityProvider.notifier).registerInteraction(),
            child: DgisMap(
              key: ValueKey(recreationKey),
              androidUseExpensive: true,
              onMapCreated: (controller) async {
                _trace('onMapCreated android start controller=${identityHashCode(controller)}');
                await dgisController.onMapCreated(controller);
                _trace('onMapCreated android done controller=${identityHashCode(controller)}');
                Future.delayed(const Duration(seconds: 3), () {
                  if (!mounted) {
                    return;
                  }
                  _trace('showActiveLayerOnMap android');
                  ref.read(layersControlsProvider.notifier).showActiveLayerOnMap();
                });
              },
            ),
          ),
          const _MapSwapCurtain(),
          Positioned.fill(
            top: null,
            child: Container(
              color: context.colors.backgroundSurface2,
              height: MediaQuery.of(context).viewPadding.bottom,
            ),
          ),

          const SafeArea(
            top: false,
            child: AutoRouter(),
          ),
        ],
      );
    } else {
      return Stack(
        fit: StackFit.expand,
        children: [
          Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (_) {
              _trace('pointerDown ios');
              ref.read(navigationControlsVisibilityProvider.notifier).registerInteraction();
            },
            onPointerSignal: (_) => ref.read(navigationControlsVisibilityProvider.notifier).registerInteraction(),
            child: DgisMap(
              key: ValueKey(recreationKey),
              androidUseExpensive: true,
              onMapCreated: (controller) async {
                _trace('onMapCreated ios start controller=${identityHashCode(controller)}');
                await dgisController.onMapCreated(controller);
                _trace('onMapCreated ios done controller=${identityHashCode(controller)}');
                Future.delayed(const Duration(seconds: 3), () {
                  if (!mounted) {
                    return;
                  }
                  _trace('showActiveLayerOnMap ios');
                  ref.read(layersControlsProvider.notifier).showActiveLayerOnMap();
                });
              },
            ),
          ),
          const _MapSwapCurtain(),
          const AutoRouter(),
        ],
      );
    }
  }

  @override
  bool get wantKeepAlive => true;

  void _trace(String event) {}

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

/// BALADY-3772: cover over the map while a style swap recreates the native
/// MapView (see [MapSwapCurtain]). Shows the map frame captured just before
/// the teardown (fallback: a plain map-ground color), appears instantly so no
/// white teardown frame leaks through, and fades out once the fresh map has
/// restored the camera. Sits under [AutoRouter] so sheets and panels stay
/// visible.
class _MapSwapCurtain extends ConsumerWidget {
  const _MapSwapCurtain();

  /// Fallback when there is no snapshot: roughly the ground color of the 2GIS
  /// style in day / night appearance, so a curtain without a frame still reads
  /// as "the map", not as a blank screen. Deliberately not a UI-kit surface
  /// token — `backgroundSurface2` is near-white in the light theme, which made
  /// the fallback itself the white flash.
  static const _dayGround = Color(0xFFE8E4DA);
  static const _nightGround = Color(0xFF1C2026);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final curtain = ref.watch(mapSwapCurtainProvider);
    final image = curtain.image;
    // Same day/night resolution the map surface itself follows: the user's
    // preference plus the transient tunnel override.
    final isNight = (ref.watch(darkModeProvider).value?.isDark ?? false) || ref.watch(tunnelStateProvider);
    return Positioned.fill(
      child: IgnorePointer(
        child: AnimatedOpacity(
          opacity: curtain.visible ? 1 : 0,
          duration: curtain.visible ? Duration.zero : MapSwapCurtain.fadeOutDuration,
          // RawImage clones the already-decoded frame and paints it on the very
          // first frame — unlike Image.memory, whose async decode left this
          // overlay transparent exactly when the old platform view went away.
          child: image != null
              ? RawImage(image: image, fit: BoxFit.cover)
              : ColoredBox(color: isNight ? _nightGround : _dayGround),
        ),
      ),
    );
  }
}
