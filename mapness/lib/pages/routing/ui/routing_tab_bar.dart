import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/features/routing/providers/public_transport_visibility.dart';
import 'package:mapness/features/routing/providers/routes.dart';
import 'package:mapness/pages/routing/lib/route_search_options_extension.dart';
import 'package:mapness/shared/providers/car_connection.dart';
import 'package:urbi_utils/urbi_utils.dart';

class RouteTabBar extends ConsumerStatefulWidget {
  final void Function(RouteSearchOptionsMessage) onChanged;
  final RouteSearchOptionsMessage active;
  final List<RouteParamsPoint?> points;
  final AsyncValue<PublicTransportVisibilityResult> publicTransportVisibility;
  final AsyncValue<List<RouteInfo>> routes;
  final AsyncValue<List<BriefPublicTransportModel>> publicTransportRoutes;

  const RouteTabBar({
    required this.onChanged,
    required this.active,
    required this.points,
    required this.publicTransportVisibility,
    required this.routes,
    required this.publicTransportRoutes,
    super.key,
  });

  @override
  ConsumerState<RouteTabBar> createState() => _RouteTabBarState();
}

class _RouteTabBarState extends ConsumerState<RouteTabBar> {
  @override
  Widget build(BuildContext context) {
    final carConnected = ref.watch(carConnectionProvider).maybeWhen(
          data: (connected) => connected,
          orElse: () => false,
        );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: Spacing.$12x),
        child: Row(
          children: [
            AppButton(
              onTap: () => context.router.push(const NavigatorSettingsRoute()),
              buttonColorScheme: ButtonColorScheme.neutral,
              buttonType: ButtonType.secondary,
              size: ButtonSize.small,
              primaryIcon: SystemIcons.tuning,
            ),
            // when car connected, choice of route search options shouldn't be available to user
            if (!carConnected) _getRouteSearchOptionsWidgets(context),
          ].insertBetween(Spacing.$2x.widthBox).toList(),
        ),
      ),
    );
  }

  Widget _getRouteSearchOptionsWidgets(BuildContext context) {
    final chips = [
      RouteSearchOptionsMessage.car,
      RouteSearchOptionsMessage.publicTransport,
      RouteSearchOptionsMessage.pedestrian,
    ];

    final errorPedestrian = widget.routes.error is WalkingDistanceException;
    final noInternetException = widget.routes.error is NoInternetException;

    return Expanded(
      child: TabsRow.v2(
        initialIndex: chips.indexOf(widget.active),
        onIndexChanged: (index) => {},
        tabsContent: chips
            .map(
              (chip) => TabsRowV2Content(
                leadingIcon: TabsV2IconData(
                  chip.icon(
                    context,
                    hasPublicTransportData: (widget.publicTransportRoutes.asData?.valueOrNull ?? []).isEmpty,
                    isPedestrianBlocked: errorPedestrian,
                    isOffline: noInternetException,
                  ),
                ),
                onTap: () => widget.onChanged(chip),
              ),
            )
            .toList(),
      ),
    );
  }
}
