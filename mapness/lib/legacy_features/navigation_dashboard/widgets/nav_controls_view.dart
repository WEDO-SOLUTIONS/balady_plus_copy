import 'package:dgis_map/library.dart';
import 'package:dgis_map/widgets/maneuver_widget.dart';
import 'package:flutter/material.dart';
import 'package:mapness/legacy_features/navigation_dashboard/widgets/sheet_close_button.dart';
import 'package:provider/provider.dart';

import '../dashboard_control.dart';
import '../models/navigation_view_model.dart';

///
class NavControlsView extends StatefulWidget {
  ///
  const NavControlsView({
    super.key,
    required this.controller,
    this.isFreeRoam = false,
    this.onFreeRoamStop,
  });

  final DgisMapController controller;
  final bool isFreeRoam;
  final Function()? onFreeRoamStop;

  @override
  State<NavControlsView> createState() => _NavControlsViewState();
}

class _NavControlsViewState extends State<NavControlsView> {
  late NavViewModel model;

  @override
  void initState() {
    super.initState();

    model = NavViewModel(
      widget.controller,
      freeRoamDefault: widget.isFreeRoam,
    )..init();
  }

  @override
  void dispose() {
    model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: model,
      child: WillPopScope(
        onWillPop: model.onWillPop,
        child: _NavControlsViewContent(
          onFreeRoamStop: widget.onFreeRoamStop,
        ),
      ),
    );
  }
}

class _NavControlsViewContent extends StatelessWidget {
  const _NavControlsViewContent({super.key, this.onFreeRoamStop});

  final Function()? onFreeRoamStop;

  @override
  Widget build(BuildContext context) {
    final navViewModel = context.watch<NavViewModel>();

    return ValueListenableBuilder(
        valueListenable: navViewModel.isFreeRoam,
        builder: (_, isFreeRoam, __) {
          return Stack(
            children: [
              Positioned(
                top: 64,
                right: 32,
                child:
                    SpeedInfoWidget(controller: navViewModel.speedController),
              ),
              Positioned(
                top: 56,
                left: 16,
                child: MessageControlWidget(
                  controller: navViewModel.messageController,
                ),
              ),
              Positioned(
                right: 12,
                bottom: 212,
                child: CompassControlWidget(
                  controller: navViewModel.compassController,
                ),
              ),
              Positioned(
                right: 8,
                top: 370,
                child: Center(
                  child: ZoomControlWidget(
                    controller: navViewModel.zoomController,
                  ),
                ),
              ),
              if (!isFreeRoam)
                Positioned(
                  top: 56,
                  left: 16,
                  child: ManeuverWidget(
                    controller: navViewModel.maneuverController,
                  ),
                ),
              if (!isFreeRoam)
                Positioned(
                  right: 8,
                  top: 164,
                  child: TrafficParkingControlWidget(
                    controller: navViewModel.trafficParkingController,
                  ),
                ),
              //TODO: only for testing purposes. Remove afterwards
              if (isFreeRoam)
                Positioned(
                  left: 12,
                  top: 48,
                  child: SheetCloseButton(onTap: () => onFreeRoamStop?.call()),
                ),
              if (!isFreeRoam)
                Positioned(
                  bottom: 0,
                  left: 0,
                  top: 0,
                  right: 0,
                  child: DashboardControl(
                    dashboardControlController:
                        navViewModel.dashboardControlController,
                  ),
                ),
            ],
          );
        });
  }
}
