import 'dart:async';
import 'dart:math';

import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapness/legacy/navigation_dashboard/widgets/mapness_typography.dart';
import 'package:mapness/legacy/navigation_dashboard/widgets/measured_widget.dart';
import 'package:provider/provider.dart';

import '../routing_page/models/routing_view_model.dart';
import 'models/navigation_view_model.dart';

part 'dashboard_controller.dart';

part 'widgets/on_continue_bottom_sheet.dart';

part 'widgets/on_result_bottom_sheet.dart';

part 'widgets/on_route_bottom_sheet.dart';

/// @nodoc
class DashboardControl extends StatelessWidget {
  /// @nodoc
  const DashboardControl({
    super.key,
    required this.dashboardControlController,
  });

  ///
  final DashboardControlController dashboardControlController;

  @override
  Widget build(BuildContext context) {
    final navViewModel = context.watch<NavViewModel>();
    final routingViewModel = context.watch<RoutingViewModel>();

    return Stack(
      children: [
        Positioned(
          left: 0,
          bottom: 0,
          right: 0,
          top: 0,
          child: OnRouteSheet(
            key: dashboardControlController
                .sheetKeys[DashboardSheet.onRouteSheet],
            onRoutePressed: () async =>
                dashboardControlController.expandContinueSheet(),
            onCollapsePressed: () async =>
                dashboardControlController.changeStateRouteBottomSheet(),
            onSoundPressed: () async => navViewModel.onSoundTap(),
            onFinishPressed: () {
              routingViewModel.onNavigationFinishClicked();
            },
          ),
        ),
        Positioned(
          left: 0,
          bottom: 0,
          right: 0,
          top: 0,
          child: OnResultBottomSheet(
            key: dashboardControlController
                .sheetKeys[DashboardSheet.onResultSheet],
            onFinishPressed: () {
              routingViewModel.onNavigationFinishClicked();
            },
            onParkingPressed: () {},
            onMarkerPressed: () {},
          ),
        ),
        Positioned(
          bottom: 80,
          right: 0,
          left: 0,
          child: OnContinueBottomSheet(
            key: dashboardControlController
                .sheetKeys[DashboardSheet.onContinueSheet],
            onPressed: () async =>
                dashboardControlController.hideContinueSheet(),
          ),
        )
      ],
    );
  }
}
