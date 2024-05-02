import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/app/routes/home_shell.dart';
import 'package:mapness/entities/path_nav/models/path_nav_state.dart';
import 'package:mapness/features/path_nav/providers/path_nav_message.dart';
import 'package:mapness/pages/path_nav/ui/eta_continue.dart';
import 'package:mapness/pages/path_nav/ui/eta_finished.dart';
import 'package:mapness/pages/path_nav/ui/eta_sheet.dart';
import 'package:mapness/pages/path_nav/ui/path_nav_map_controlls.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/navigator_voice.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class PathNavPage extends ConsumerStatefulWidget {
  const PathNavPage({
    required this.navType,
    super.key,
  });
  final RouteSearchOptionsMessage navType;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => PathNavPageState();
}

class PathNavPageState extends ConsumerState<PathNavPage> {
  ValueNotifier<PathNavState> navigationState =
      ValueNotifier(PathNavState.running);

  late StreamSubscription? _naviEventsListener;

  void _setNavigationState(PathNavState value) {
    setState(() {
      navigationState.value = value;
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
      ref.read(pathNavMessageProvider.notifier).stopNavigation();
      await ref.read(dgisControllerProvider).value?.stopNavigation();
      _setNavigationState(PathNavState.finished);
      const RoutingRoute(collapseInitially: true).go(context);
    }

    ref.read(layersControlsProvider.notifier).updateLayerInfo();
  }

  void _naviEvent(NavigationEvent event) {
    if (event == NavigationEvent.finished) {
      _setNavigationState(PathNavState.finished);
    }
  }

  Future<void> _moveCameraToUser() async {
    final position = ref.read(locationProvider);
    final cameraProvider = ref.read(cameraPositionProvider.notifier);

    if (position != null) {
      await cameraProvider.animateTo(
        CameraPositionMessage(
          point: position,
          zoom: 17.5,
          tilt: 0,
          bearing: 0,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          /// controls and driver info
          Positioned.fill(
            bottom: 68,
            child: SafeArea(
              child: PathNavMapControlls(
                navType: widget.navType,
              ),
            ),
          ),
          ValueListenableBuilder(
              valueListenable: navigationState,
              builder: (context, state, child) {
                switch (state) {
                  case PathNavState.running:
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: LayoutBuilder(
                        builder: (context, constraints) => EtaSheet(
                          onEndTripPressed: _endTrip,
                          onRoutePressed: () async {
                            _setNavigationState(PathNavState.paused);
                            await ref
                                .read(cameraPositionProvider.notifier)
                                .animateToRoute();
                          },
                        ),
                      ),
                    );
                  case PathNavState.paused:
                    return EtaContinue(
                      onTap: () async {
                        _setNavigationState(PathNavState.running);
                        final dgisController =
                            await ref.read(dgisControllerProvider.future);

                        await _moveCameraToUser();

                        await dgisController.followNavigation();
                      },
                    );
                  case PathNavState.finished:
                    return EtaFinished(onEndTripPressed: _endTrip);
                }
              }),
        ],
      );
}
