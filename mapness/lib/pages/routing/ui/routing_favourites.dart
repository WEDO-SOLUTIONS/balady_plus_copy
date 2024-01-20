import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/_features/favourites/providers/favourite_repository.dart';
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
    final favouritesState = ref.watch(favouriteRepositoryProvider);
    final favItems = <FavouriteItem?>[
      favouritesState.valueOrNull?.home,
      favouritesState.valueOrNull?.work,
    ];
    final favourites = [
      if (showBookmark)
        FilterItem(
          icon: 'assets/icons/svg/quick_filters/ic_quick_bookmark.svg',
        ),
      FilterItem(
        title: context.l10n.home,
        icon: 'assets/icons/svg/quick_filters/ic_quick_home.svg',
      ),
      FilterItem(
        title: context.l10n.work,
        icon: 'assets/icons/svg/quick_filters/ic_quick_work.svg',
      ),
    ];

    return widgets.QuickFilters(
      filters: favourites,
      onTap: (index) async {
        // Bookmarks click
        if (index == 0 && showBookmark) {
          CommonFunctions.authOrOpen(context, callback: () async {
            final result = await const FavouritesPickerRoute().push(context);

            if (result != null) {
              onFavouriteTap(result);
            }
            return;
          });
        }

        // TODO(@alexstrnik) rewrite QuickFilters!!!
        index = showBookmark ? index - 1 : index;
        if (favItems[index] == null) {
          CommonFunctions.authOrOpen(context, callback: () async {
            await FavouritesSearchRoute(
              markerType: index == 0
                  ? FavouriteItemMarkerType.home
                  : FavouriteItemMarkerType.work,
            ).push(context);
            final favouritesState =
                await ref.read(favouriteRepositoryProvider.future);
            onFavouriteTap(
              index == 0 ? favouritesState.home! : favouritesState.work!,
            );
          });
        } else {
          onFavouriteTap(favItems[index]!);
        }
      },
    );
  }
}
