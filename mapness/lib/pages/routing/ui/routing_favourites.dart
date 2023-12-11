import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/_features/favourites/providers/favourite_repository.dart';
import 'package:mapness/app/routes/favourites.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/quick_filters/models/filter_item.dart';
import 'package:mapness/widgets/quick_filters/ui/quick_filters.dart' as widgets;

class RoutingFavourites extends ConsumerWidget {
  const RoutingFavourites({
    super.key,
    required this.onFavouriteTap,
  });

  final void Function(FavouriteItem) onFavouriteTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favouritesState = ref.watch(favouriteRepositoryProvider);
    List<FavouriteItem?> favItems = [
      favouritesState.valueOrNull?.home,
      favouritesState.valueOrNull?.work,
    ];
    final favourites = [
      FilterItem(
        title: context.l10n.home,
        icon: "assets/icons/svg/quick_filters/ic_quick_home.svg",
      ),
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
      onTap: (index) async {
        if (favItems[index] == null) {
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
        } else {
          onFavouriteTap(favItems[index]!);
        }
      },
      itemBackground: const Color(0x0D1E2A36),
    );
  }
}
