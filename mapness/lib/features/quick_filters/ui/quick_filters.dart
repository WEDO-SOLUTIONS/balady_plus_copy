import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/_features/favourites/providers/favourite_repository.dart';
import 'package:mapness/app/routes/routing.dart';
import 'package:mapness/entities/quick_filters/quick_filter.dart' as models;
import 'package:mapness/features/quick_filters/providers/quick_filters.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/quick_filters/models/filter_item.dart';
import 'package:mapness/widgets/quick_filters/ui/quick_filters.dart' as widgets;

class QuickFilters extends ConsumerWidget {
  const QuickFilters({
    super.key,
    this.selectedIndex,
    required this.onFilterTap,
    required this.onFavouritesBookmarkTap,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 16,
    ),
    this.customFilters,
    this.onCustomTap,
    this.itemBackground = const Color(0x0D1E2A36),
  });

  final int? selectedIndex;
  final List<FilterItem>? customFilters;
  final void Function(models.QuickFilter, int index) onFilterTap;
  final void Function() onFavouritesBookmarkTap;
  final void Function(int index)? onCustomTap;
  final EdgeInsets padding;
  final Color itemBackground;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quickFilters = ref.watch(quickFiltersProvider);
    final favouritesState = ref.watch(favouriteRepositoryProvider);
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

    final customItems = customFilters ?? [];

    final items = [
      ...customItems,
      ...favourites,
      ...(quickFilters.valueOrNull ?? []).map(
        (e) => FilterItem(
          icon: e.uiIcon,
          title: e.titleOrFailback(context.l10n),
        ),
      ),
    ];

    // TODO(AlexStrNik): refactor this
    ///
    return widgets.QuickFilters(
      padding: padding,
      filters: items,
      selectedIndex: selectedIndex,
      onTap: (index) {
        /// elements before favourites
        if (index < customItems.length) {
          onCustomTap?.call(index);
        } else

        /// favourite bookmark (navigate to favourites)
        if (index == customItems.length) {
          onFavouritesBookmarkTap();
        } else

        /// favourites (home and work)
        if (index > customItems.length &&
            index < favourites.length + customItems.length) {
          final filter = favourites[index - customItems.length];
          final FavouriteItem? point;
          final home = favouritesState.valueOrNull?.home;
          final work = favouritesState.valueOrNull?.work;
          if (filter.title == context.l10n.home && home != null) {
            point = home;
          } else if (filter.title == context.l10n.work && work != null) {
            point = work;
          } else {
            return;
          }

          RoutingRoutesRoute(
            finishLabel: point.title,
            finishLatitude: point.coordinates.latitude,
            finishLongitude: point.coordinates.longitude,
            startLabel: context.l10n.myLocation,
            startLatitude: null,
            startLongitude: null,
          ).push(context);
        } else

        /// all other filters
        if (index >= favourites.length + customItems.length) {
          onFilterTap(
            quickFilters.value![index - favourites.length - customItems.length],
            index,
          );
        }
      },
      itemBackground: itemBackground,
    );
  }
}
