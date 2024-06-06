import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/_features/favourites/providers/favourite_cache.dart';
import 'package:mapness/_features/landing/providers/quick_filter_request_source_screen.dart';
import 'package:mapness/app/routes/favourites.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/widgets/quick_filters/models/filter_item.dart';
import 'package:mapness/widgets/quick_filters/ui/quick_filters.dart' as widgets;

class RoutingFavourites extends ConsumerWidget {
  const RoutingFavourites({
    required this.showBookmark,
    required this.onFavouriteTap,
    super.key,
  });

  final bool showBookmark;
  final void Function(FavouriteItem) onFavouriteTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favourites = [
      if (showBookmark)
        FilterItem(
          filterType: FilterType.favourites,
          icon: 'assets/icons/svg/quick_filters/ic_quick_bookmark.svg',
          onTap: () async {
            if (showBookmark) {
              await CommonFunctions.authOrOpen(
                context,
                callback: () async {
                  final result = await const FavouritesPickerRoute().push(context);

                  if (result != null) {
                    onFavouriteTap(result as FavouriteItem);
                  }
                  return;
                },
              );
            }
          },
        ),
      FilterItem(
        filterType: FilterType.home,
        title: context.l10n.home,
        icon: 'assets/icons/svg/quick_filters/ic_quick_home.svg',
        onTap: () async {
          final favouritesState = await ref.read(favouriteCacheProvider.future);
          final home = favouritesState.home;
          if (home == null) {
            await CommonFunctions.authOrOpen(
              context,
              callback: () async {
                await const FavouritesSearchRoute(
                  markerType: FavouriteItemMarkerType.home,
                ).push(context);

                final favouritesState = await ref.read(favouriteCacheProvider.future);

                onFavouriteTap(favouritesState.home!);
              },
            );
          } else {
            onFavouriteTap(home);
          }
        },
      ),
      FilterItem(
        filterType: FilterType.work,
        title: context.l10n.work,
        icon: 'assets/icons/svg/quick_filters/ic_quick_work.svg',
        onTap: () async {
          final favouritesState = await ref.read(favouriteCacheProvider.future);
          final work = favouritesState.work;
          if (work == null) {
            await CommonFunctions.authOrOpen(
              context,
              callback: () async {
                await const FavouritesSearchRoute(
                  markerType: FavouriteItemMarkerType.work,
                ).push(context);

                final favouritesState = await ref.read(favouriteCacheProvider.future);

                onFavouriteTap(
                  favouritesState.work!,
                );
              },
            );
          } else {
            onFavouriteTap(work);
          }
        },
      ),
    ];

    return widgets.QuickFilters(
      filters: favourites,
      id: QuickFilterScreen.routing,
    );
  }
}
