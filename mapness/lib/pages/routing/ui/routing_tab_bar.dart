import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/features/routing/providers/routes.dart';
import 'package:mapness/pages/routing/lib/route_search_options_extension.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/car_connection.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:urbi_utils/urbi_utils.dart';

String _routeModeTabTitle(AppLocalizations l10n, RouteSearchOptionsMessage mode) {
  if (mode == RouteSearchOptionsMessage.car || mode == RouteSearchOptionsMessage.truck) {
    return l10n.mapLayerCar;
  }
  if (mode == RouteSearchOptionsMessage.publicTransport) {
    return l10n.mapLayerTransport;
  }
  if (mode == RouteSearchOptionsMessage.pedestrian) {
    return l10n.a11yRouteWalking;
  }
  if (mode == RouteSearchOptionsMessage.bicycle) {
    return l10n.a11yRouteBicycle;
  }
  if (mode == RouteSearchOptionsMessage.scooter) {
    return l10n.a11yRouteScooter;
  }
  return l10n.nav_route;
}

class RouteTabBar extends ConsumerWidget {
  final void Function(RouteSearchOptionsMessage) onChanged;
  final RouteSearchOptionsMessage active;
  final List<RouteParamsPoint?> points;
  final bool hasPublicTransport;
  final AsyncValue<List<RouteInfo>> routes;
  final RouteSearchOptionsMessage? lockedNavType;

  const RouteTabBar({
    required this.onChanged,
    required this.active,
    required this.points,
    required this.hasPublicTransport,
    required this.routes,
    this.lockedNavType,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCarConnected = ref
        .watch(carConnectionProvider)
        .maybeWhen(data: (connected) => connected, orElse: () => false);
    final isNavigationLocked = lockedNavType != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: Spacing.$12x),
        child: Row(
          children: [
            if (!isCarConnected && !isNavigationLocked) _buildRouteOptionsWidget(context),
            if (!isCarConnected && isNavigationLocked) _buildLockedNavTypeWidget(context),
          ].insertBetween(Spacing.$2x.widthBox).toList(),
        ),
      ),
    );
  }

  Widget _buildLockedNavTypeWidget(BuildContext context) {
    final l10n = context.l10n;
    return Expanded(
      child: TabsRow.v2(
        onIndexChanged: (_) {},
        tabsContent: [
          TabsRowV2Content(
            title: _routeModeTabTitle(l10n, lockedNavType!),
            leadingIcon: TabsV2IconData(
              lockedNavType!.icon(context, noPublicTransportData: false, isPedestrianBlocked: false, isOffline: false),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildRouteOptionsWidget(BuildContext context) {
    const chips = [
      RouteSearchOptionsMessage.car,
      RouteSearchOptionsMessage.publicTransport,
      RouteSearchOptionsMessage.pedestrian,
    ];

    final errorPedestrian = routes.error is WalkingDistanceException;
    final noInternetException = routes.error is NoInternetException;
    final l10n = context.l10n;

    return Expanded(
      child: TabsRow.v2(
        initialIndex: chips.indexOf(active),
        onIndexChanged: (_) {},
        tabsContent: chips
            .map(
              (chip) => TabsRowV2Content(
                title: _routeModeTabTitle(l10n, chip),
                leadingIcon: TabsV2IconData(
                  chip.icon(
                    context,
                    noPublicTransportData: !hasPublicTransport,
                    isPedestrianBlocked: errorPedestrian,
                    isOffline: noInternetException,
                  ),
                ),
                onTap: () => onChanged(chip),
              ),
            )
            .toList(),
      ),
    );
  }
}
