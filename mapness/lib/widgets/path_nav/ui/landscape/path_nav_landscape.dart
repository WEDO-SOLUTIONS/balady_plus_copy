import 'package:dgis_map/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/path_nav/models/path_nav_state.dart';
import 'package:mapness/widgets/path_nav/ui/eta_continue.dart';
import 'package:mapness/widgets/path_nav/ui/eta_finished.dart';
import 'package:mapness/widgets/path_nav/ui/eta_sheet.dart';
import 'package:mapness/widgets/path_nav/ui/parking_bottom_banner.dart';
import 'package:mapness/widgets/path_nav/ui/parking_bottom_sheet.dart';
import 'package:mapness/widgets/path_nav/ui/path_nav_map_controls.dart';

class PathNavLandscape extends ConsumerStatefulWidget {
  final ValueNotifier<double> bottomHeightNotifier;
  final ValueNotifier<PathNavState> navigationState;
  final ValueNotifier<bool> expansionNotifier;
  final RouteSearchOptionsMessage navType;
  final bool isHomeOrWork;
  final Function(double size) onSizeChangedParking;
  final Function(BuildContext context) endTripAndShowFeedback;
  final VoidCallback onShowRoutePressed;
  final Function(BuildContext context) acceptBetterRoute;
  final Function(BuildContext context) rejectBetterRoute;
  final ValueNotifier<int?> betterRouteDurationProfit;
  final Function(Size size) onSizeChanged;
  final VoidCallback onContinuePressed;
  final VoidCallback endTripAndShowHome;
  final VoidCallback endTripAndBuildAnotherRoute;

  const PathNavLandscape({
    required this.bottomHeightNotifier,
    required this.navigationState,
    required this.expansionNotifier,
    required this.navType,
    required this.isHomeOrWork,
    required this.onSizeChangedParking,
    required this.endTripAndShowFeedback,
    required this.onShowRoutePressed,
    required this.acceptBetterRoute,
    required this.rejectBetterRoute,
    required this.betterRouteDurationProfit,
    required this.onSizeChanged,
    required this.onContinuePressed,
    required this.endTripAndShowHome,
    required this.endTripAndBuildAnotherRoute,
    super.key,
  });

  @override
  ConsumerState<PathNavLandscape> createState() => _PathNavLandscapeState();
}

class _PathNavLandscapeState extends ConsumerState<PathNavLandscape> {
  final double _roadPanelWidth = 370;

  @override
  Widget build(BuildContext context) => SafeArea(
        bottom: false,
        child: Stack(
          children: [
            PathNavMapControls(
              bottomHeightNotifier: widget.bottomHeightNotifier,
              navigationState: widget.navigationState,
              expansionNotifier: widget.expansionNotifier,
              navType: widget.navType,
            ),
            Positioned.fill(
              child: Align(
                alignment: AlignmentDirectional.bottomStart,
                child: SizedBox(
                  width: _roadPanelWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ParkingBanner(
                        navigatorType: widget.navType,
                        navigationState: widget.navigationState,
                        isHomeOrWork: widget.isHomeOrWork,
                      ),
                      Flexible(
                        child: Directionality(
                          textDirection: Directionality.of(context),
                          child: ValueListenableBuilder(
                            valueListenable: widget.navigationState,
                            builder: (context, state, child) {
                              switch (state) {
                                case PathNavState.running:
                                  return EtaSheet(
                                    onEndTripPressed: () => widget.endTripAndShowFeedback(context),
                                    onRoutePressed: widget.onShowRoutePressed,
                                    onBetterRouteAccept: () => widget.acceptBetterRoute(context),
                                    onBetterRouteReject: () => widget.rejectBetterRoute(context),
                                    betterRouteDurationProfit: widget.betterRouteDurationProfit,
                                    onSizeChanged: widget.onSizeChanged,
                                  );
                                case PathNavState.paused:
                                  return EtaContinue(
                                    onTap: widget.onContinuePressed,
                                    onSizeChanged: widget.onSizeChanged,
                                  );
                                case PathNavState.finished:
                                  return EtaFinished(
                                    expansionNotifier: widget.expansionNotifier,
                                    onEndTripPressed: widget.endTripAndShowHome,
                                    onBuildAnotherRoutePressed: widget.endTripAndBuildAnotherRoute,
                                    onSizeChanged: widget.onSizeChanged,
                                  );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ParkingBottomSheetPage(onSizeChanged: widget.onSizeChangedParking)
          ],
        ),
      );
}
