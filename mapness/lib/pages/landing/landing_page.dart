import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Provider;
import 'package:flutter_riverpod/legacy.dart';
import 'package:mapness/entities/city_event/city_event.dart';
import 'package:mapness/features/city_event/active_city_event.dart';
import 'package:mapness/features/favourites/providers/favourite_markers.dart';
import 'package:mapness/features/founding_day/founding_day.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/features/thermal_monitor/thermal_monitor.dart';
import 'package:mapness/shared/lib/urbi_metrics_utils.dart';
import 'package:mapness/shared/providers/map/camera_padding.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/map/sound_settings.dart';
import 'package:mapness/shared/providers/media_query.dart';
import 'package:mapness/widgets/hajj/hajj_wrapper_listeners.dart';
import 'package:mapness/widgets/landing/dashboard/dashboard.dart';
import 'package:provider/provider.dart';
import 'package:sheetify/sheetify.dart';

part 'landing_page_bottom_sheet_controller.dart';

@RoutePage()
class LandingPage extends ConsumerStatefulWidget {
  const LandingPage({super.key});

  @override
  ConsumerState<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage>
    with WidgetsBindingObserver, TickerProviderStateMixin, AutoRouteAwareStateMixin<LandingPage> {
  late final bottomSheetController = ref.read(bottomSheetControllerProvider.notifier).state.controller;

  ThreeStateSheet? get bottomSheetState => bottomSheetController?.state;

  ConfettiGeneratorConfig getConfettiConfig(BuildContext context) {
    final color = ref.read(activeCityEventProvider)?.fireworkGradientColors;
    final colors = ref.read(activeCityEventProvider)?.fireworkGradientColors2;
    return ConfettiGeneratorConfig.confetti(
      dissappearStartsAt: 0.33,
      dissappearCurve: Curves.easeInOutQuint,
      commonShapeAppearance: 1,
      animationDuration: const Duration(seconds: 4),
      mostCommonGradientColors: color,
      gradientColors: colors,
      mostCommonConfettiShape: (startPosition, velocity, scale, gradient, x, y, z) =>
          ShiningShape(startPosition, velocity, scale, gradient, x, y, z),
    );
  }

  late final confettiController = AnimationController(
    vsync: this,
    duration: getConfettiConfig(context).animationDuration,
  );

  MediaQueryData? _mediaQuery;

  // Only first time when sheet is open
  bool _sheetExpanded = false;
  bool _routeCovered = false;
  bool _sheetOverlayVisible = false;
  ThreeStateSheet? _lastTracedSheetState;
  ThreeStateSheet? _lastTracedClosestSheetState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _mediaQuery = ref.read(mediaQueryInfoProvider);
    });
    _sheetOverlayVisible = bottomSheetState != ThreeStateSheet.hidden;
    bottomSheetController?.addListener(_bottomsheetListener);
    _traceSheet('init');

    _setupTapListener();
  }

  Future<void> _setupTapListener() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _calculatePadding();
    });
  }

  void _calculatePadding() {
    final bottomSheetController = this.bottomSheetController;
    if (!mounted || bottomSheetController == null) {
      return;
    }

    ref
        .read(cameraPaddingProvider.notifier)
        .resetPadding(
          defaultPadding: CameraSetPaddingMessage(
            leftPadding: _mediaQuery?.padding.left.toInt() ?? 0,
            rightPadding: _mediaQuery?.padding.right.toInt() ?? 0,
            topPadding: _mediaQuery?.padding.top.toInt() ?? 0,
            bottomPadding: bottomSheetController.sheetHeight.toInt(),
          ),
        );
  }

  void _bottomsheetListener() {
    final state = bottomSheetController?.state;
    final closestState = bottomSheetController?.closestState;
    if (state != _lastTracedSheetState || closestState != _lastTracedClosestSheetState) {
      _lastTracedSheetState = state;
      _lastTracedClosestSheetState = closestState;
      _traceSheet('sheet-listener');
    }

    if (bottomSheetController?.state == ThreeStateSheet.expanded && !_sheetExpanded) {
      _sheetExpanded = true;
      final isFoundingDayToday = ref.read(foundingDayUrbiProvider);
      if (isFoundingDayToday) {
        confettiController
          ..value = 0
          ..animateTo(confettiController.upperBound, curve: Curves.easeOutQuint, duration: confettiController.duration);
      }
    }

    _syncSheetOverlayVisibility();
    _calculatePadding();
  }

  @override
  void dispose() {
    _traceSheet('dispose');
    bottomSheetController?.removeListener(_bottomsheetListener);

    WidgetsBinding.instance.removeObserver(this);
    confettiController.dispose();

    super.dispose();
  }

  @override
  void didPushNext() {
    _setRouteCovered(true);
  }

  @override
  void didPopNext() {
    _setRouteCovered(false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _calculatePadding();
      }
    });
  }

  void _setRouteCovered(bool value) {
    if (_routeCovered == value || !mounted) {
      return;
    }
    setState(() {
      _routeCovered = value;
      if (!value) {
        _sheetOverlayVisible = bottomSheetState != ThreeStateSheet.hidden;
      }
    });
  }

  void _syncSheetOverlayVisibility() {
    if (!mounted || _routeCovered) {
      return;
    }

    final isVisible = bottomSheetState != ThreeStateSheet.hidden;
    if (_sheetOverlayVisible == isVisible) {
      return;
    }
    setState(() {
      _sheetOverlayVisible = isVisible;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      AdvancedMetrics.instance.pauseMeasureBattery();
    } else if (state == AppLifecycleState.resumed) {
      // Re-sync sound settings from persistence.
      // CarPlay writes directly to UserDefaults when the phone app is
      // backgrounded, but Flutter's SharedPreferences cache doesn't see
      // native writes until reload() is called.
      ref.read(soundSettingsProvider.notifier).syncFromPersistence();
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
      ..watch(favouriteMarkersProvider(theme: context.read<ThemeController>().currentTheme).select((value) => null))
      /// keep iwish markers alive when page is opened  (DO NOT DELETE UNTIL REFACOR OF LAYER CONTROLS!)
      ..watch(mapObjectManagerProvider(named: esri.name, layerId: esri.layerId).notifier)
      ..watch(thermalMonitorProvider)
      ..watch(mapObjectManagerProvider(named: mappness.name, layerId: mappness.layerId).notifier)
      ..watch(mapObjectManagerProvider(named: metro.name, layerId: metro.layerId).notifier)
      ..watch(mapObjectManagerProvider(named: myLocation.name, layerId: myLocation.layerId).notifier)
      ..watch(activeCityEventProvider);

    final confettiConfig = getConfettiConfig(context);
    final content = HajjWrapperListeners(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: context.watch<ThemeController>().systemOverlayStyle,
        child: Directionality(
          textDirection: Directionality.of(context),
          child: Material(
            type: MaterialType.transparency,
            child: Stack(
              children: [
                if (_sheetOverlayVisible)
                  Positioned.fill(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTapDown: (_) => _hideBottomSheet(),
                      onTapUp: (_) => _hideBottomSheet(),
                      onTap: _hideBottomSheet,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: Spacing.$3x),
                  child: Dashboard(
                    bottomSheetController: bottomSheetController!,
                    fireworksController: confettiController,
                  ),
                ),
                RepaintBoundary(
                  child: ConfettiAnimation(
                    key: ValueKey(confettiConfig.hashCode),
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

    return Offstage(
      offstage: _routeCovered,
      child: TickerMode(
        enabled: !_routeCovered,
        child: IgnorePointer(
          ignoring: _routeCovered,
          child: content,
        ),
      ),
    );
  }

  void _hideBottomSheet() {
    _traceSheet('hideBottomSheet-before');
    if (bottomSheetState != ThreeStateSheet.hidden) {
      bottomSheetController?.setState(ThreeStateSheet.hidden);
    }
    _syncSheetOverlayVisibility();
    _traceSheet('hideBottomSheet-after');
  }

  void _traceSheet(String event) {
    final controller = bottomSheetController;
    if (controller == null) {
      return;
    }
  }
}
