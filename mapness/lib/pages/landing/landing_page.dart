import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/favourites/providers/favourite_markers.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/features/thermal_monitor/thermal_monitor.dart';
import 'package:mapness/pages/landing/landing_state_mapper.dart';
import 'package:mapness/shared/lib/urbi_metrics_utils.dart';
import 'package:mapness/shared/providers/map/camera_padding.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/media_query.dart';
import 'package:mapness/widgets/hajj/hajj_wrapper_listeners.dart';
import 'package:mapness/widgets/landing/dashboard/dashboard.dart';
import 'package:sheetify/sheetify.dart';

part 'landing_page_bottom_sheet_controller.dart';


@RoutePage()
class LandingPage extends ConsumerStatefulWidget {
  const LandingPage({super.key});

  @override
  ConsumerState<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage> with WidgetsBindingObserver, TickerProviderStateMixin {
  late final MultiStateSheetController<ThreeStateSheet> _bottomSheetController = MultiStateSheetController(
    initialState: ThreeStateSheet.open,
    behavior: FractionSnappingBehavior(fractions: {0.0, if (Platform.isIOS) .3 else .38, 1.0}),
    stateMapper: const LandingStateMapper(),
  );

  final confettiConfig = ConfettiGeneratorConfig.confetti(
    dissappearStartsAt: 0.33,
    dissappearCurve: Curves.easeInOutQuint,
    commonShapeAppearance: 1,
    animationDuration: const Duration(seconds: 4),
    mostCommonConfettiShape: (startPosition, velocity, scale, gradient, x, y, z) =>
        ShiningShape(startPosition, velocity, scale, gradient, x, y, z),
  );
  late final confettiController = AnimationController(vsync: this, duration: confettiConfig.animationDuration);

  MediaQueryData? _mediaQuery;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mediaQuery = ref.read(mediaQueryInfoProvider);
    });

    _bottomSheetController.addListener(_calculatePadding);

    _setupTapListener();
    ref.read(_bottomSheetControllerProvider)._controller = _bottomSheetController;
  }

  Future<void> _setupTapListener() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculatePadding();
    });
  }

  void _calculatePadding() {
    ref.read(cameraPaddingProvider.notifier).resetPadding(
          defaultPadding: CameraSetPaddingMessage(
            leftPadding: _mediaQuery?.padding.left.toInt() ?? 0,
            rightPadding: _mediaQuery?.padding.right.toInt() ?? 0,
            topPadding: _mediaQuery?.padding.top.toInt() ?? 0,
            bottomPadding: _bottomSheetController.sheetHeight.toInt(),
          ),
        );
  }

  @override
  void dispose() {
    _bottomSheetController.removeListener(_calculatePadding);
    ref.read(_bottomSheetControllerProvider)._controller = null;

    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      AdvancedMetrics.instance.pauseMeasureBattery();
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    final esri = MapObjectManagerSettings.esri();
    final mappness = MapObjectManagerSettings.mappness();
    final metro = MapObjectManagerSettings.metro();
    final myLocation = MapObjectManagerSettings.myLocation();

    ref
      ..watch(layersControlsProvider)
      ..watch(favouriteMarkersProvider.select((value) => null))

      /// keep iwish markers alive when page is opened  (DO NOT DELETE UNTIL REFACOR OF LAYER CONTROLS!)
      ..watch(mapObjectManagerProvider(named: esri.name, layerId: esri.layerId).notifier)
      ..watch(thermalMonitorProvider)
      ..watch(mapObjectManagerProvider(named: mappness.name, layerId: mappness.layerId).notifier)
      ..watch(mapObjectManagerProvider(named: metro.name, layerId: metro.layerId).notifier)
      ..watch(mapObjectManagerProvider(named: myLocation.name, layerId: myLocation.layerId).notifier);

    return HajjWrapperListeners(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Directionality(
          textDirection: Directionality.of(context),
          child: Material(
            type: MaterialType.transparency,
            child: Stack(
              children: [
                ListenableBuilder(
                  listenable: _bottomSheetController,
                  builder: (_, __) {
                    if (_bottomSheetController.state == ThreeStateSheet.hidden) {
                      return const SizedBox.shrink();
                    }

                    return GestureDetector(
                      onTapDown: (_) => _hideBottomSheet(),
                      onTapUp: (_) => _hideBottomSheet(),
                      onTap: _hideBottomSheet,
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: Spacing.$3x),
                  child: Dashboard(
                    bottomSheetController: _bottomSheetController,
                    fireworksController: confettiController,
                  ),
                ),
                RepaintBoundary(
                  child: ConfettiAnimation(
                    animationController: confettiController,
                    config: confettiConfig,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _hideBottomSheet() {
    if (_bottomSheetController.state != ThreeStateSheet.hidden) {
      _bottomSheetController.setState(ThreeStateSheet.hidden);
    }
  }
}
