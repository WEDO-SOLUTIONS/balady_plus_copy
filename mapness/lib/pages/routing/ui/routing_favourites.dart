import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/_features/favourites/providers/favourite_repository.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/quick_filters/models/filter_item.dart';
import 'package:mapness/widgets/quick_filters/ui/quick_filters.dart' as widgets;

class RoutingFavourites extends ConsumerWidget {
  const RoutingFavourites({
    super.key,
    required this.onFavouriteTap,
    required this.onFavouritesBookmarkTap,
  });

  final void Function(FavouriteItem) onFavouriteTap;
  final void Function() onFavouritesBookmarkTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favouritesState = ref.watch(favouriteRepositoryProvider);
    List<FavouriteItem> favItems = [
      if (favouritesState.valueOrNull?.home != null)
        favouritesState.valueOrNull!.home!,
      if (favouritesState.valueOrNull?.work != null)
        favouritesState.valueOrNull!.work!,
    ];
    final favourites = [
      FilterItem(
        icon: "assets/icons/svg/quick_filters/ic_quick_bookmark.svg",
      ),
      if (favouritesState.valueOrNull?.home != null)
        FilterItem(
          title: context.l10n.home,
          icon: "assets/icons/svg/quick_filters/ic_quick_home.svg",
        ),
      if (favouritesState.valueOrNull?.work != null)
        FilterItem(
          title: context.l10n.work,
          icon: "assets/icons/svg/quick_filters/ic_quick_work.svg",
        ),
    ];

    return widgets.QuickFilters(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      filters: favourites,
      onTap: (index) {
        if (index == 0) {
          onFavouritesBookmarkTap();
        } else {
          onFavouriteTap(favItems[index - 1]);
        }
      },
      itemBackground: const Color(0x0D1E2A36),
    );
  }
}
