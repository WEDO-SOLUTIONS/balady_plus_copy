import 'package:dgis_map/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/path_nav/models/path_nav_state.dart';
import 'package:mapness/widgets/path_nav/ui/eta_continue.dart';
import 'package:mapness/widgets/path_nav/ui/eta_finished.dart';
import 'package:mapness/widgets/path_nav/ui/eta_sheet.dart';
import 'package:mapness/widgets/path_nav/ui/parking_bottom_banner.dart';

class NaviPanelLandscape extends ConsumerWidget {
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

  const NaviPanelLandscape({
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
  Widget build(BuildContext context, WidgetRef ref) {
    const double _roadPanelWidth = 370;

    return SafeArea(
      bottom: false,
      child: SizedBox(
        width: _roadPanelWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            ParkingBanner(
              navigatorType: navType,
              navigationState: navigationState,
              isHomeOrWork: isHomeOrWork,
            ),
            Flexible(
              child: Directionality(
                textDirection: Directionality.of(context),
                child: ValueListenableBuilder<PathNavState>(
                  valueListenable: navigationState,
                  builder: (context, state, child) {
                    switch (state) {
                      case PathNavState.running:
                        return EtaSheet(
                          onEndTripPressed: () => endTripAndShowFeedback(context),
                          onRoutePressed: onShowRoutePressed,
                          onBetterRouteAccept: () => acceptBetterRoute(context),
                          onBetterRouteReject: () => rejectBetterRoute(context),
                          betterRouteDurationProfit: betterRouteDurationProfit,
                          onSizeChanged: onSizeChanged,
                        );
                      case PathNavState.paused:
                        return EtaContinue(
                          onTap: onContinuePressed,
                          onSizeChanged: onSizeChanged,
                        );
                      case PathNavState.finished:
                        return EtaFinished(
                          expansionNotifier: expansionNotifier,
                          onEndTripPressed: endTripAndShowHome,
                          onBuildAnotherRoutePressed: endTripAndBuildAnotherRoute,
                          onSizeChanged: onSizeChanged,
                        );
                    }
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
