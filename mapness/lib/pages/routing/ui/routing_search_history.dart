import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/routing/route_point.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/pages/routing/ui/routing_favourites.dart';
import 'package:mapness/pages/routing/ui/routing_history.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/widgets/routing/ui/search_action.dart';

class RoutingSearchHistory extends ConsumerWidget {
  const RoutingSearchHistory({
    required this.showMyLocation,
    super.key,
  });

  final bool showMyLocation;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
        children: [
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: RoutingFavourites(
                showBookmark: false,
                onFavouriteTap: (point) async {
                  await context.router.maybePopTop(RoutePointFavouriteItem(point));
                },
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
                      onTap: () => context.pop(RoutePointMyLocation()),
                      borderRadius: BorderRadius.circular(12),
                      child: SearchActionRow(
                        icon: 'assets/icons/svg/ic_actions_loc.svg',
                        title: context.l10n.myLocation,
                      ),
                    ),
                  ),
                Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () async {
                      final result = await context.router.push(const RoutingMapSelectRoute());

                      if (result != null) {
                        await context.router.maybePopTop(result);
                      }
                    },
                    child: SearchActionRow(
                      icon: 'assets/icons/svg/ic_actions_map.svg',
                      title: context.l10n.specifyOnTheMap,
                    ),
                  ),
                ),
                Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () async {
                      await CommonFunctions.authOrOpen(
                        context,
                        callback: () async {
                          if (!context.mounted) {
                            return;
                          }
                          final result = await context.router.push(const FavouritesPickerRoute());

                          if (result != null) {
                            await context.router.maybePop(
                              RoutePointFavouriteItem(result as FavouriteItem?),
                            );
                          }
                        },
                      );
                    },
                    child: SearchActionRow(
                      icon: 'assets/icons/svg/ic_actions_fav.svg',
                      title: context.l10n.findInFavorites,
                    ),
                  ),
                ),
              ],
            ),
          ),
          RoutingHistory(
            updatePoint: (point) {
              context.pop(point);
            },
            searchByQuery: (query) {
              ref.read(searchProvider(SearchScopeEnum.routes.value).notifier).fetchSuggest(query);
            },
          ),
        ],
      );
}
