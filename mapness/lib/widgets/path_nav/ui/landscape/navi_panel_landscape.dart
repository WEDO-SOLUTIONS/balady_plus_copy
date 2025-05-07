import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/entities/path_nav/models/path_nav_state.dart';
import 'package:mapness/features/map_tap_handler/map_tap_handler_provider.dart';
import 'package:mapness/widgets/path_nav/ui/eta_continue.dart';
import 'package:mapness/widgets/path_nav/ui/eta_finished.dart';
import 'package:mapness/widgets/path_nav/ui/eta_sheet.dart';

class NaviPanelLandscape extends ConsumerStatefulWidget {
  final ValueNotifier<PathNavState> navigationState;
  final ValueNotifier<bool> expansionNotifier;
  final VoidCallback onShowRoutePressed;
  final Function(BuildContext context) acceptBetterRoute;
  final Function(BuildContext context) rejectBetterRoute;
  final Function(BuildContext context) onSearchPressed;
  final ValueNotifier<int?> betterRouteDurationProfit;
  final Function(Size size) onSizeChanged;
  final VoidCallback onContinuePressed;
  final VoidCallback endTripAndShowHome;
  final VoidCallback onTapRoute;
  final VoidCallback endTripAndBuildAnotherRoute;

  const NaviPanelLandscape({
    required this.navigationState,
    required this.expansionNotifier,
    required this.onShowRoutePressed,
    required this.acceptBetterRoute,
    required this.rejectBetterRoute,
    required this.betterRouteDurationProfit,
    required this.onSizeChanged,
    required this.onContinuePressed,
    required this.endTripAndShowHome,
    required this.endTripAndBuildAnotherRoute,
    required this.onSearchPressed,
    required this.onTapRoute,
    super.key,
  });

  @override
  ConsumerState<NaviPanelLandscape> createState() => _NaviPanelLandscapeState();
}

class _NaviPanelLandscapeState extends ConsumerState<NaviPanelLandscape> {
  final _landscapeWidth = 370.0;

  @override
  void initState() {
    super.initState();
    ref.read(mapTapHandlerProvider.notifier).disableTapOnMap = true;
  }

  @override
  void deactivate() {
    ref.read(mapTapHandlerProvider.notifier).disableTapOnMap = false;
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        bottom: false,
        child: SizedBox(
          width: _landscapeWidth,
          child: Directionality(
            textDirection: ref.watch(uiDirectionProvider),
            child: ValueListenableBuilder<PathNavState>(
              valueListenable: widget.navigationState,
              builder: (context, state, child) {
                switch (state) {
                  case PathNavState.running:
                    return EtaSheet(
                      onEndTripPressed: () => widget.endTripAndShowHome(),
                      onTapRoute: widget.onTapRoute,
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
                      onSearchPressed: () => widget.onSearchPressed(context),
                    );
                }
              },
            ),
          ),
        ),
      );
}
