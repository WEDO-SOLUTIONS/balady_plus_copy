import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart' as uikit;
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/path_nav/models/path_nav_message_state.dart';
import 'package:mapness/features/app_analytics/datafinder_source_tracker.dart';
import 'package:mapness/features/app_analytics/models/datafinder_models.dart';
import 'package:mapness/features/free_roam/free_roam_manager.dart';
import 'package:mapness/features/path_nav/providers/path_nav_maneuver.dart';
import 'package:mapness/features/path_nav/providers/path_nav_message.dart';
import 'package:mapness/features/path_nav/providers/path_nav_speed_info.dart';
import 'package:mapness/pages/free_roam/ui/road_panel.dart';
import 'package:mapness/pages/free_roam/ui/traffic_parking_control.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/extensions/path_nav_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/services/navigation_live_updates.dart';
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
  late final VoidCallback _deactivateFreeRoam;

  late final ToggleSheetController _bottomSheetController = ToggleSheetController(
    onClose: (_) => _bottomSheetController.close,
  );

  @override
  void initState() {
    super.initState();
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
    unawaited(_startLiveUpdates());

    WakelockPlus.enable();
  }

  /// Free roam has no route, so the widget only carries speed, limit and the
  /// current road — the same data the on-screen panel shows.
  Future<void> _startLiveUpdates() async {
    if (!mounted) {
      return;
    }
    final l10n = context.l10n;
    await NavigationLiveUpdates.instance.setSessionMetadata(
      destinationName: null,
      mode: 'freeRoam',
      routeType: 'car',
      language: ref.read(appLanguageProvider).baladyCompat,
      strings: <String, String>{
        'free_roam': l10n.freeRoam,
        'gps_lost': l10n.gpsLost,
        'end_trip': l10n.endTrip,
        'km': l10n.km,
        'm': l10n.meter,
        'h': l10n.hoursShort,
        'min': l10n.minutesShort,
      },
    );
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
    unawaited(NavigationLiveUpdates.instance.endSession());
    super.deactivate();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    WidgetsBinding.instance.removeObserver(this);
    WakelockPlus.disable();
    _naviEventsListener?.cancel();
    super.dispose();
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

    return Directionality(
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
