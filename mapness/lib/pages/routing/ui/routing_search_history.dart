import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/favourites/favourite_item.dart';
import 'package:mapness/entities/routing/route_point.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/pages/routing/ui/routing_favourites.dart';
import 'package:mapness/pages/routing/ui/routing_history.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/auth/auth_methods.dart';
import 'package:mapness/widgets/routing/ui/search_action.dart';

class RoutingSearchHistory extends ConsumerWidget {
  final bool showMyLocation;

  const RoutingSearchHistory({
    required this.showMyLocation,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLTR = Directionality.of(context) == TextDirection.ltr;
    return Column(
      children: [
        RoutingFavourites(
          showBookmark: false,
          onFavouriteTap: (point) {
            context.router.popForced(RoutePointFavouriteItem(point));
          },
        ),
        Spacing.$4x.heightBox,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
          child: SearchActions(
            children: [
              if (showMyLocation)
                ContentRow(
                  leading: Icon(
                    isLTR ? TransportIcons.locationLTR : TransportIcons.locationRTL,
                    color: context.colors.accentActive,
                    size: 22,
                  ),
                  text: ContentRowTextOptions(
                    title: context.l10n.myLocation,
                  ),
                  onTap: () => context.router.popForced(RoutePointMyLocation()),
                ),
              ContentRow(
                leading: Icon(
                  GeneralIcons.location,
                  color: context.colors.accentActive,
                ),
                text: ContentRowTextOptions(
                  title: context.l10n.specifyOnTheMap,
                ),
                onTap: () => _specifyOnTheMap(context),
              ),
              ContentRow(
                leading: Icon(
                  SystemIcons.bookmark,
                  color: context.colors.accentActive,
                ),
                text: ContentRowTextOptions(
                  title: context.l10n.findInFavorites,
                ),
                onTap: () => _onFavouriteTap(context, ref),
              ),
            ],
          ),
        ),
        Spacing.$4x.heightBox,
        RoutingHistory(
          updatePoint: (point) {
            context.router.popForced(point);
          },
          searchByQuery: (query) {
            ref.read(searchProvider(SearchScopeEnum.routes.value).notifier).fetchSuggest(query);
          },
        ),
      ],
    );
  }

  Future<void> _specifyOnTheMap(BuildContext context) async {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }

    final result = await context.router.push(const RoutingMapSelectRoute());

    if (result != null) {
      context.router.popForced(result);
    }
  }

  Future<void> _onFavouriteTap(BuildContext context, WidgetRef ref) async {
    await ref.read(authMethodsProvider.notifier).authOrOpen(
      context,
      callback: () async {
        if (context.mounted) {
          final result = await context.router.push(const FavouritesPickerRoute());

          if (result != null) {
            context.router.popForced(
              RoutePointFavouriteItem(result as FavouriteItem?),
            );
          }
        }
      },
    );
  }
}
