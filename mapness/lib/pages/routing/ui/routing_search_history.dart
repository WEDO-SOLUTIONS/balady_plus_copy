import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/landing/widgets/favorites.dart';
import 'package:mapness/entities/routing/route_point.dart';
import 'package:mapness/pages/routing/ui/routing_history.dart';
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
          child: const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Favorites(
              background: Color(0x0D1E2A36),
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
                    child: const SearchActionRow(
                      icon: "assets/icons/svg/ic_actions_loc.svg",
                      title: "My location",
                    ),
                  ),
                ),
              const SearchActionRow(
                icon: "assets/icons/svg/ic_actions_map.svg",
                title: "Specify on the map",
              ),
              const SearchActionRow(
                icon: "assets/icons/svg/ic_actions_fav.svg",
                title: "Find in Favorites",
              ),
            ],
          ),
        ),
        const RoutingHistory(),
      ],
    );
  }
}
