import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  final RouteSearchOptionsMessage? lockedNavType;

  const RouteTabBar({
    required this.onChanged,
    required this.active,
    required this.points,
    required this.publicTransportVisibility,
    required this.routes,
    this.lockedNavType,
    super.key,
  });

  @override
  ConsumerState<RouteTabBar> createState() => _RouteTabBarState();
}

class _RouteTabBarState extends ConsumerState<RouteTabBar> {
  bool get _isCarConnected => ref.watch(carConnectionProvider).maybeWhen(
        data: (connected) => connected,
        orElse: () => false,
      );

  bool get _isNavigationLocked => widget.lockedNavType != null;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: Spacing.$12x),
          child: Row(
            children: [
              if (!_isCarConnected && !_isNavigationLocked) _buildRouteOptionsWidget(context),
              if (!_isCarConnected && _isNavigationLocked) _buildLockedNavTypeWidget(context),
            ].insertBetween(Spacing.$2x.widthBox).toList(),
          ),
        ),
      );

  Widget _buildLockedNavTypeWidget(BuildContext context) => Expanded(
        child: TabsRow.v2(
          onIndexChanged: (_) {},
          tabsContent: [
            TabsRowV2Content(
              leadingIcon: TabsV2IconData(
                widget.lockedNavType!.icon(
                  context,
                  hasPublicTransportData: false,
                  isPedestrianBlocked: false,
                  isOffline: false,
                ),
              ),
              onTap: () {},
            ),
          ],
        ),
      );

  Widget _buildRouteOptionsWidget(BuildContext context) {
    const chips = [
      RouteSearchOptionsMessage.car,
      RouteSearchOptionsMessage.publicTransport,
      RouteSearchOptionsMessage.pedestrian,
    ];

    final errorPedestrian = widget.routes.error is WalkingDistanceException;
    final noInternetException = widget.routes.error is NoInternetException;
    final hasPublicTransport = widget.publicTransportVisibility.asData?.value.hasPublicTransportRoutes ?? false;

    return Expanded(
      child: TabsRow.v2(
        initialIndex: chips.indexOf(widget.active),
        onIndexChanged: (_) {},
        tabsContent: chips
            .map(
              (chip) => TabsRowV2Content(
                leadingIcon: TabsV2IconData(
                  chip.icon(
                    context,
                    hasPublicTransportData: !hasPublicTransport,
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
