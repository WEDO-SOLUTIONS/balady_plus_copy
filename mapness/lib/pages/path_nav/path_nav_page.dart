import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/routes/home_shell.dart';
import 'package:mapness/features/path_nav/providers/path_nav_eta.dart';
import 'package:mapness/features/path_nav/providers/path_nav_maneuver.dart';
import 'package:mapness/features/path_nav/providers/path_nav_message.dart';
import 'package:mapness/features/path_nav/providers/path_nav_speed_info.dart';
import 'package:mapness/pages/path_nav/ui/eta_sheet.dart';
import 'package:mapness/pages/path_nav/ui/path_nav_map_controlls.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/navigator_voice.dart';
import 'package:mapness/widgets/path_nav/ui/path_nav_continue_trip.dart';
import 'package:mapness/widgets/path_nav/ui/path_nav_maneuver_widget.dart';
import 'package:mapness/widgets/path_nav/ui/path_nav_message_widget.dart';
import 'package:mapness/widgets/path_nav/ui/path_nav_speed_info_widget.dart';

class PathNavPage extends ConsumerStatefulWidget {
  const PathNavPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => PathNavPageState();
}

class PathNavPageState extends ConsumerState<PathNavPage> {
  bool isInRouteViewMode = false;

  final ValueNotifier<double> _bgOpacity = ValueNotifier(0.0);

  void _setInRouteViewMode(bool value) {
    setState(() {
      isInRouteViewMode = value;
      _bgOpacity.value = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    ref.read(dgisControllerProvider)?.setNavigatorVoice(
          ref.read(navigatorVoiceProvider),
        );
    unawaited(ref.read(dgisControllerProvider)?.startNavigation());
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _endTrip() async {
    await ref.read(dgisControllerProvider)?.stopNavigation();

    if (context.mounted) {
      const RoutingRoute().go(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Ink(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            /// controls and driver info
            Positioned.fill(
              bottom: 68,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Consumer(
                            builder: (context, ref, child) {
                              final info = ref.watch(pathNavSpeedInfoProvider);
                              return PathNavSpeedInfoWidget(info: info);
                            },
                          ),
                          Consumer(
                            builder: (context, ref, child) {
                              final message = ref.watch(pathNavMessageProvider);
                              final maneuver =
                                  ref.watch(pathNavManeuverProvider);
                              if (message != null) {
                                return PathNavMessageWidget(message: message);
                              }
                              if (maneuver == null) {
                                return const SizedBox.shrink();
                              }
                              return PathNavManeuverWidget(maneuver: maneuver);
                            },
                          ),
                        ],
                      ),
                    ),
                    const Expanded(
                      child: PathNavMapControlls(),
                    ),
                  ],
                ),
              ),
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

            /// map overview
            if (isInRouteViewMode)
              Positioned(
                bottom: 20 + MediaQuery.of(context).padding.bottom,
                left: 8,
                right: 8,
                child: Consumer(
                  builder: (context, ref, child) {
                    final eta = ref.watch(pathNavEtaProvider);
                    return PathNavContinueTrip(
                      onPressed: () => _setInRouteViewMode(false),
                      eta: eta,
                    );
                  },
                ),
              )
            else

              /// eta sheet
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
                        _setInRouteViewMode(true);
                        // TODO(@alexstrnik): show route
                      },
                      onBgOpacityChanged: (opacity) =>
                          _bgOpacity.value = opacity,
                      maxExtent: maxExtent,
                      minExtent: minExtent,
                    );
                  },
                ),
              )
          ],
        ),
      ),
    );
  }
}
