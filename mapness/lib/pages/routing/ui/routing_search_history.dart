import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/entities/routing/route_point.dart';
import 'package:mapness/features/quick_filters/ui/quick_filters.dart';
import 'package:mapness/pages/routing/ui/routing_history.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/routing/ui/search_action.dart';

class RoutingSearchHistory extends StatelessWidget {
  const RoutingSearchHistory({
    super.key,
    required this.showMyLocation,
  });

  final bool showMyLocation;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: QuickFilters(
              onFavouritesBookmarkTap: () {},
              onFilterTap: (_, __) {},
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SearchActions(
            children: [
              if (showMyLocation)
                Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () => context.pop(
                      RoutePoint(
                        type: RoutePointType.myLocation,
                        object: null,
                      ),
                    ),
                    borderRadius: BorderRadius.circular(12),
                    child: SearchActionRow(
                      icon: "assets/icons/svg/ic_actions_loc.svg",
                      title: context.l10n.myLocation,
                    ),
                  ),
                ),
              SearchActionRow(
                icon: "assets/icons/svg/ic_actions_map.svg",
                title: context.l10n.specifyOnTheMap,
              ),
              SearchActionRow(
                icon: "assets/icons/svg/ic_actions_fav.svg",
                title: context.l10n.findInFavorites,
              ),
            ],
          ),
        ),
        RoutingHistory(
          updatePoint: (point) {
            context.pop(point);
          },
        ),
      ],
    );
  }
}
