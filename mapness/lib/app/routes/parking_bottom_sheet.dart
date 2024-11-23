import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/pages/parking/parking_bottom_sheet_page.dart';
import 'package:mapness/shared/routing/transculent_page.dart';

part 'parking_bottom_sheet.g.dart';

@TypedGoRoute<ParkingBottomSheetRoute>(
  path: ParkingBottomSheetRoute.path,
)
class ParkingBottomSheetRoute extends GoRouteData {

  static const path = '/parking_bottom_sheet';
  const ParkingBottomSheetRoute();
  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  static void open(BuildContext context) {
    const route = ParkingBottomSheetRoute();
    final router = GoRouter.of(context);
    final matches = router.routerDelegate.currentConfiguration.matches;
    if (matches.last.matchedLocation == path) {
      route.pushReplacement(context);
    } else {
      route.push(context);
    }
  }

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) => const TransculentPage(
      child: ParkingBottomSheetPage(),
    );
}

final $parkingBottomSheet = $appRoutes;
