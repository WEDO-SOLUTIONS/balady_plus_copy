import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/landing/dashboard.dart';
import 'package:mapness/_features/landing/landing_state_mapper.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/city_contains/service_not_available.dart';
import 'package:mapness/features/favourites/providers/favourite_markers.dart';
import 'package:mapness/features/stories/providers/stories_open_state.dart';
import 'package:mapness/shared/lib/urbi_metrics_utils.dart';
import 'package:mapness/shared/providers/beta_notification.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/camera_padding.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/media_query.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';

@RoutePage()
class LandingPage extends ConsumerStatefulWidget {
  const LandingPage({super.key});

  @override
  ConsumerState<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage> with WidgetsBindingObserver {
  late final StatefulBottomSheetController<ThreeStateBottomSheet> _bottomSheetController =
      StatefulBottomSheetController(
    initialState: ThreeStateBottomSheet.open,
    behavior: AspectRatioSnappingBehavior(aspectRatios: {0.0, if (Platform.isIOS) .3 else .38, .931}),
    stateMapper: const LandingStateMapper(),
  );

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
  }

  Future<void> _setupTapListener() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculatePadding();
    });
  }

  void _showBetaNotification() {
    final wasBetaShown = ref.read(betaNotificationProvider);

    if (!wasBetaShown) {
      ref.read(betaNotificationProvider.notifier).setShown();
      ToastOverlay.of(context).showBetaNotification();
    }
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

    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(locationProvider.notifier).checkLocationPermission();
    } else if (state == AppLifecycleState.paused) {
      AdvancedMetrics.instance.pauseMeasureBattery();
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    if (!ref.read(storiesOpenStateProvider)) {
      Future(_showBetaNotification);
    }

    ref.listen(storiesOpenStateProvider, (_, isStoriesOpen) {
      if (isStoriesOpen) {
        ToastOverlay.of(context).hide();
      } else {
        _showBetaNotification();
      }
    });

    final esri = MapObjectManagerSettings.esri();
    final mappness = MapObjectManagerSettings.mappness();
    final metro = MapObjectManagerSettings.metro();
    final myLocation = MapObjectManagerSettings.myLocation();

    ref
      ..watch(layersControlsProvider)
      ..watch(favouriteMarkersProvider.select((value) => null))
      ..listen(serviceNotAvailableProvider, (prev, isAvailible) {
        final isPrevIsAvailible = prev?.valueOrNull ?? true;
        final isAvailibleValue = isAvailible.valueOrNull;

        // Show only if service is not available
        if (isPrevIsAvailible == true && isAvailibleValue == false) {
          context.router.push(const ServiceNotAvailableSheetRoute());
        }
      })

      /// keep iwish markers alive when page is opened  (DO NOT DELETE UNTIL REFACOR OF LAYER CONTROLS!)
      ..watch(mapObjectManagerProvider(named: esri.name, layerId: esri.layerId).notifier)
      ..watch(mapObjectManagerProvider(named: mappness.name, layerId: mappness.layerId).notifier)
      ..watch(mapObjectManagerProvider(named: metro.name, layerId: metro.layerId).notifier)
      ..watch(mapObjectManagerProvider(named: myLocation.name, layerId: myLocation.layerId).notifier);

    return AnnotatedRegion<SystemUiOverlayStyle>(
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
                  if (_bottomSheetController.state == ThreeStateBottomSheet.hidden) {
                    return const SizedBox.shrink();
                  }

                  return GestureDetector(
                    onTapDown: (_) => _hideBottomSheet(),
                    onTapUp: (_) => _hideBottomSheet(),
                    onTap: _hideBottomSheet,
                  );
                },
              ),
              Dashboard(bottomSheetController: _bottomSheetController),
            ],
          ),
        ),
      ),
    );
  }

  void _hideBottomSheet() {
    if (_bottomSheetController.state != ThreeStateBottomSheet.hidden) {
      _bottomSheetController.setState(ThreeStateBottomSheet.hidden);
    }
  }
}
