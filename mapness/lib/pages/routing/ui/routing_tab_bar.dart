import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/features/routing/providers/routes.dart';
import 'package:mapness/pages/routing/lib/route_point_extension.dart';
import 'package:mapness/pages/routing/lib/route_search_options_extension.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/map/find_brief_route_info.dart';
import 'package:mapness/widgets/routing/lib/duration_distance_fmt.dart';
import 'package:urbi_utils/urbi_utils.dart';

class RouteTabBar extends ConsumerStatefulWidget {
  final void Function(RouteSearchOptionsMessage) onChanged;
  final RouteSearchOptionsMessage active;
  final List<RouteParamsPoint?> points;

  const RouteTabBar({
    required this.onChanged,
    required this.active,
    required this.points,
    super.key,
  });

  @override
  ConsumerState<RouteTabBar> createState() => _RouteTabBarState();
}

class _RouteTabBarState extends ConsumerState<RouteTabBar> {
  int? defaultDurationForCar;
  int? defaultDurationForPedestrian;

  @override
  Widget build(BuildContext context) {
    final routes = ref
            .watch(
              routesProvider(
                startPoint: widget.points[0],
                finishPoint: widget.points[1],
                navType: widget.active,
              ),
            )
            .unwrapPrevious()
            .valueOrNull ??
        [];
    final activeRoute = ref.watch(activeRouteProvider);
    final routeDuration = routes.isEmpty ? null : routes[activeRoute].duration;

    final isCar = widget.active == RouteSearchOptionsMessage.car;
    final anotherRoute = ref.watch(
      briefRouteInfoProvider(
        startPoint: widget.points[0]?.toRouteSearch,
        finishPoint: widget.points[1]?.toRouteSearch,
        navType: isCar ? RouteSearchOptionsMessage.pedestrian : RouteSearchOptionsMessage.car,
      ),
    );

    if (isCar) {
      defaultDurationForCar ??= routeDuration;
    } else {
      defaultDurationForPedestrian ??= routeDuration;
    }

    final defaultForOther = isCar ? defaultDurationForPedestrian : defaultDurationForCar;
    final defaultForThis = isCar ? defaultDurationForCar : defaultDurationForPedestrian;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.verticalPaddingInsideWrapper),
      child: Row(
        children: [
          RouteSearchOptionsMessage.car,
          RouteSearchOptionsMessage.pedestrian,
        ]
            .map<Widget>(
              (e) => Expanded(
                child: Chips(
                  onTap: () => widget.onChanged(e),
                  style: ChipsStyle.whiteBackground,
                  leadingIcon: ChipIconData(e.icon(context)),
                  title: widget.active == e
                      ? (routeDuration ?? defaultForThis)?.formatDuration(context.l10n)
                      : (defaultForOther ?? anotherRoute?.firstOrNull?.duration.toInt())?.formatDuration(context.l10n),
                  isSelected: widget.active == e,
                  size: ChipsSize.medium,
                ),
              ),
            )
            .insertBetween(Spacing.horizontalGapBetweenChips.widthBox)
            .toList(),
      ),
    );
  }
}
