import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart' as uikit;
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/path_nav/models/path_nav_message_state.dart';
import 'package:mapness/features/app_analytics/datafinder_source_tracker.dart';
import 'package:mapness/features/app_analytics/models/datafinder_models.dart';
import 'package:mapness/features/free_roam/free_roam_manager.dart';
import 'package:mapness/features/path_nav/providers/path_nav_maneuver.dart';
import 'package:mapness/features/path_nav/providers/path_nav_message.dart';
import 'package:mapness/features/path_nav/providers/path_nav_speed_info.dart';
import 'package:mapness/features/routing/providers/routes.dart';
import 'package:mapness/pages/free_roam/ui/road_panel.dart';
import 'package:mapness/pages/free_roam/ui/traffic_parking_control.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/extensions/path_nav_ext.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/widgets/landing/compass_control.dart';
import 'package:mapness/widgets/landing/follow_control.dart';
import 'package:mapness/widgets/landing/indoor_control.dart';
import 'package:mapness/widgets/landing/sound_control.dart';
import 'package:mapness/widgets/map_dimensions_control/dimension_contrtol.dart';
import 'package:mapness/widgets/path_nav/ui/parking_bottom_sheet.dart';
import 'package:sheetify/sheetify.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

@RoutePage()
class FreeRoamPage extends ConsumerStatefulWidget {
  static const landscapeWidth = 370.0;

  const FreeRoamPage({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => FreeRoamPageState();
}

class FreeRoamPageState extends ConsumerState<FreeRoamPage> with WidgetsBindingObserver {
  static const padding = EdgeInsets.symmetric(horizontal: uikit.Spacing.$3x);

  bool isLoading = true;

  bool isControlsActive = true;
  bool wasSetActive = true;

  Timer? timer;

  StreamSubscription? _naviEventsListener;

  /// Captured in `initState` so `dispose` doesn't touch `ref` while this
  /// element is being unmounted.
  late final StateController<bool> _navigationActive;
  late final VoidCallback _deactivateFreeRoam;
  bool _isEndingTrip = false;

  late final ToggleSheetController _bottomSheetController = ToggleSheetController(
    onClose: (_) => _bottomSheetController.close,
  );

  @override
  void initState() {
    super.initState();
    _navigationActive = ref.read(navigationActiveProvider.notifier);
    // Free Roam is navigation as far as the map is concerned: the camera
    // follows the driver and the TIFO capture layer has to step back the same
    // way it does on a route. Deferred for the same reason as the origin
    // stamp below — a provider can't be written during the build phase.
    _setNavigationActive(active: true);
    // DataFinder: entering Free Roam sets the journey origin (BRD
    // `Explore-Free Roam`), so a search/favorite from here is attributed to it.
    // Deferred: modifying a provider directly in initState throws in Riverpod.
    Future(() {
      ref.read(dataFinderSourceTrackerProvider.notifier).stampOrigin(DataFinderOrigin.freeRoam);
    });
    WidgetsBinding.instance
      ..addPostFrameCallback((_) async {
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      })
      ..addObserver(this);
    final freeRoamManager = ref.read(freeRoamManagerProvider.notifier);
    _deactivateFreeRoam = freeRoamManager.deactivate;
    freeRoamManager.initFreeRoam().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        isLoading = false;
      });
    });
    startControlsDisapearTimer();
    _listenNavigationEvents();

    WakelockPlus.enable();
  }

  @override
  void didChangeDependencies() {
    final x = MediaQuery.of(context).orientation == Orientation.landscape ? 0.6 : 0.5;
    ref.read(dgisControllerProvider).value?.setCameraPositionPoint(CameraPositionPointMessage(x: x, y: 0.85));
    super.didChangeDependencies();
    context.changeSystemNavBar();
  }

  @override
  void deactivate() {
    _deactivateFreeRoam();
    super.deactivate();
  }

  @override
  void dispose() {
    _setNavigationActive(active: false);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    WidgetsBinding.instance.removeObserver(this);
    WakelockPlus.disable();
    _naviEventsListener?.cancel();
    super.dispose();
  }

  /// Publishes "free roam is / isn't on screen" outside the current build
  /// phase — see `navigationActiveProvider` for what reads it.
  void _setNavigationActive({required bool active}) {
    final controller = _navigationActive;
    Future.microtask(() {
      try {
        controller.state = active;
      } catch (_) {
        // Provider container already gone (app shutting down).
      }
    });
  }

  Future<void> _listenNavigationEvents() async {
    final dgisController = await ref.read(dgisControllerProvider.future);
    if (!mounted) {
      return;
    }
    _naviEventsListener = dgisController.navigationEvents.listen((event) {
      if (event == NavigationEvent.disabled && context.mounted && mounted) {
        ref.read(freeRoamManagerProvider.notifier).endTripAndShowHome(context: context);
      }
    });
  }

  /// System back must end the free-roam session the same way "End trip" does;
  /// otherwise the native session keeps running on Explore, with its camera
  /// and my-location behaviour still applied to the dashboard.
  Future<void> _onPopInvoked(bool didPop, Object? result) async {
    if (didPop || _isEndingTrip) {
      return;
    }
    _isEndingTrip = true;
    try {
      await ref.read(freeRoamManagerProvider.notifier).endTripAndShowHome(context: context);
    } finally {
      _isEndingTrip = false;
    }
  }

  void startControlsDisapearTimer() {
    timer = Timer(const Duration(seconds: 15), () {
      if (mounted) {
        setState(() {
          isControlsActive = false;
          wasSetActive = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final systemDirectionality = Directionality.of(context);
    final isPortrait = MediaQuery.orientationOf(context) == Orientation.portrait;

    final content = Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (event) {
              timer?.cancel();
              timer = null;
              setState(() {
                if (!isControlsActive) {
                  wasSetActive = true;
                  isControlsActive = true;
                }
              });
            },
            onPointerUp: (event) {
              startControlsDisapearTimer();
            },
          ),
          GestureDetector(
            behavior: isControlsActive ? HitTestBehavior.deferToChild : HitTestBehavior.translucent,
            onTap: () {
              setState(() {
                if (wasSetActive) {
                  wasSetActive = false;
                  return;
                }

                isControlsActive = !isControlsActive;
              });
            },
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: uikit.Spacing.$1_5x, width: double.maxFinite),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: uikit.Spacing.$3x),
                  child: ManeuverWidget(),
                ),
                const SizedBox(height: uikit.Spacing.$6x),
                Expanded(
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: padding,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SoundControl(),
                          Expanded(
                            child: AnimatedOpacity(
                              opacity: isControlsActive ? 1 : 0,
                              duration: const Duration(milliseconds: 250),
                              child: IgnorePointer(
                                ignoring: !isControlsActive,
                                child: GestureDetector(
                                  onTap: () {
                                    timer?.cancel();
                                    timer = null;
                                    wasSetActive = true;
                                    isControlsActive = true;
                                    startControlsDisapearTimer();
                                  },
                                  child: isPortrait
                                      ? const Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            TrafficParkingControl(trafficVisible: false),
                                            SizedBox(height: uikit.Spacing.$2x),
                                            DimensionControl(),
                                            Spacer(),
                                            Row(
                                              children: [
                                                IndoorControl(),
                                              ],
                                            ),
                                            Spacer(),
                                            CompassControl(),
                                            SizedBox(height: uikit.Spacing.$2x),
                                            FollowControl(),
                                            SizedBox(height: uikit.Spacing.$3x),
                                          ],
                                        )
                                      : const Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Spacer(),
                                                Padding(
                                                  padding: padding,
                                                  child: IndoorControl(),
                                                ),
                                                Spacer(flex: 3),
                                              ],
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Directionality(
                  textDirection: systemDirectionality,
                  child: Align(
                    alignment: isPortrait ? AlignmentDirectional.center : AlignmentDirectional.bottomStart,
                    child: RoadPanel(
                      isLoading: isLoading,
                      onSearch: isPortrait ? () => context.router.push(NaviSearchRoute()) : null,
                      onEndTrip: () => ref.read(freeRoamManagerProvider.notifier).endTripAndShowHome(context: context),
                      onOpenSheet: () => context.router.push(const RoadPanelSheetRoute()),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const ParkingBottomSheetPage(),
        ],
      ),
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _onPopInvoked,
      child: content,
    );
  }
}

class ManeuverWidget extends ConsumerWidget {
  const ManeuverWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final message = ref.watch(pathNavMessageProvider);
    final maneuver = ref.watch(pathNavManeuverProvider);
    final info = ref.watch(pathNavSpeedInfoProvider);

    return Material(
      type: MaterialType.transparency,
      color: Colors.transparent,
      child: uikit.BaladyManeuverAndLimit(
        isPedestrian: false,
        hideSpeedLimit: info.speedLimit == null,
        speedInfo: uikit.LimitsModel(
          speed: info.speed,
          speedExceed: info.speedExceed,
          speedLimit: info.speedLimit,
        ),
        maneuver: maneuver != null
            ? uikit.BaladyManeuverModel(
                distance: maneuver.distance,
                instruction: maneuver.instruction?.toUIKit(),
                roadName: maneuver.roadName,
                unit: maneuver.unit,
              )
            : null,
        message: message != null && message.state != PathNavMessageState.reroute
            ? uikit.ManeuverMessageModel(
                comment: message.state.toMessage(context.l10n),
                state: message.state.toUIKit(),
              )
            : null,
      ),
    );
  }
}
