import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/routes/home_shell.dart';
import 'package:mapness/entities/path_nav/models/path_nav_state.dart';
import 'package:mapness/features/path_nav/providers/path_nav_eta.dart';
import 'package:mapness/pages/path_nav/ui/eta_sheet.dart';
import 'package:mapness/pages/path_nav/ui/path_nav_map_controlls.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/navigator_voice.dart';
import 'package:mapness/widgets/path_nav/ui/path_nav_continue_trip.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class PathNavPage extends ConsumerStatefulWidget {
  const PathNavPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => PathNavPageState();
}

class PathNavPageState extends ConsumerState<PathNavPage> {
  ValueNotifier<PathNavState> navigationState =
      ValueNotifier(PathNavState.running);

  late StreamSubscription? _naviEventsListener;

  final ValueNotifier<double> _bgOpacity = ValueNotifier(0.0);

  void _setNavigationState(PathNavState value) {
    setState(() {
      navigationState.value = value;
      _bgOpacity.value = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    ref.read(dgisControllerProvider).value?.setNavigatorVoice(
          ref.read(navigatorVoiceProvider),
        );
    _naviEventsListener = ref
        .read(dgisControllerProvider)
        .value
        ?.navigationEvents
        .listen(_naviEvent);
    unawaited(ref.read(dgisControllerProvider).value?.startNavigation());
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    _naviEventsListener?.cancel();
    WakelockPlus.disable();
    super.dispose();
  }

  Future<void> _endTrip() async {
    if (navigationState.value == PathNavState.finished) {
      if (context.mounted) {
        const RoutingRoute(collapseInitially: true).go(context);
      }
    } else {
      await ref.read(dgisControllerProvider).value?.stopNavigation();
      _setNavigationState(PathNavState.finished);
      const RoutingRoute(collapseInitially: true).go(context);
    }
  }

  void _naviEvent(NavigationEvent event) {
    if (event == NavigationEvent.finished) {
      _setNavigationState(PathNavState.finished);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Directionality(
      textDirection: Directionality.of(context),
      child: Ink(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            /// controls and driver info
            const Positioned.fill(
              bottom: 68,
              child: SafeArea(child: PathNavMapControlls()),
            ),

            /// shadow bg + tap observer
            Positioned.fill(
              child: ValueListenableBuilder(
                valueListenable: _bgOpacity,
                builder: (context, value, child) {
                  if (value <= 0.03) {
                    return const SizedBox.shrink();
                  }
                  return Container(
                    color: Colors.black.withOpacity(0.8 * value),
                  );
                },
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final maxExtent = 812 / constraints.maxHeight * 0.4;
                  final minExtent =
                      (75 + bottomPadding) / constraints.maxHeight;
                  return EtaSheet(
                    onEndTripPressed: _endTrip,
                    onRoutePressed: () async {
                      _setNavigationState(PathNavState.paused);
                      await ref
                          .read(cameraPositionProvider.notifier)
                          .animateToRoute();
                    },
                    onBgOpacityChanged: (opacity) => _bgOpacity.value = opacity,
                    maxExtent: maxExtent,
                    minExtent: minExtent,
                    navigationState: navigationState,
                  );
                },
              ),
            ),

            ValueListenableBuilder(
              valueListenable: navigationState,
              builder: (context, state, child) => state == PathNavState.paused
                  ? child!
                  : const SizedBox.shrink(),
              child: Positioned(
                bottom: 20 + MediaQuery.of(context).padding.bottom,
                left: 8,
                right: 8,
                child: Consumer(
                  builder: (context, ref, child) {
                    final eta = ref.watch(pathNavEtaProvider);
                    return PathNavContinueTrip(
                      onPressed: () async {
                        _setNavigationState(PathNavState.running);
                        final dgisController =
                            await ref.read(dgisControllerProvider.future);
                        await dgisController.followNavigation();
                      },
                      eta: eta,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
