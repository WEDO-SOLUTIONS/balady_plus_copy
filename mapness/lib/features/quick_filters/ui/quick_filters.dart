import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/_features/favourites/providers/favourite_cache.dart';
import 'package:mapness/app/routes/routing.dart';
import 'package:mapness/entities/quick_filters/quick_filter.dart' as models;
import 'package:mapness/features/quick_filters/providers/quick_filters.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_features.dart';
import 'package:mapness/widgets/quick_filters/models/filter_item.dart';
import 'package:mapness/widgets/quick_filters/ui/quick_filters.dart' as widgets;

class QuickFilters extends ConsumerWidget {
  const QuickFilters({
    required this.onFilterTap,
    required this.onFavouritesBookmarkTap,
    super.key,
    this.selectedIndex,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 16,
    ),
    this.customFilters,
    this.onCustomTap,
    this.itemBackground = NonThemeColor.color11,
  });

  final int? selectedIndex;
  final List<FilterItem>? customFilters;
  final void Function(models.QuickFilter, int index) onFilterTap;
  final void Function() onFavouritesBookmarkTap;
  final void Function(FilterItem)? onCustomTap;
  final EdgeInsets padding;
  final Color itemBackground;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quickFilters = ref.watch(quickFiltersProvider);
    final favouritesState = ref.watch(favouriteCacheProvider);
    final naviFeature = ref.watch(appFeaturesProvider);

    final favourites = <FilterItem>[
      FilterItem(
        filterType: FilterType.favourites,
        icon: 'assets/icons/svg/quick_filters/ic_quick_bookmark.svg',
        onTap: onFavouritesBookmarkTap,
      ),
      if (favouritesState.valueOrNull?.home != null && naviFeature.naviEnabled)
        FilterItem(
          filterType: FilterType.home,
          title: context.l10n.home,
          icon: 'assets/icons/svg/quick_filters/ic_quick_home.svg',
          onTap: () {
            final FavouriteItem? point;
            final home = favouritesState.valueOrNull?.home;
            if (home != null) {
              point = home;
            } else {
              return;
            }

            /// navigation to fav item when pressed
            _showRouting(naviFeature, point, context);
          },
        ),
      if (favouritesState.valueOrNull?.work != null && naviFeature.naviEnabled)
        FilterItem(
          filterType: FilterType.work,
          title: context.l10n.work,
          icon: 'assets/icons/svg/quick_filters/ic_quick_work.svg',
          onTap: () {
            final FavouriteItem? point;
            final work = favouritesState.valueOrNull?.work;
            if (work != null) {
              point = work;
            } else {
              return;
            }

            /// navigation to fav item when pressed
            _showRouting(naviFeature, point, context);
          },
        ),
    ];

    final customItems = customFilters ?? [];

    final items = [
      ...customItems,
      ...favourites,
      ...(quickFilters.valueOrNull ?? []).mapIndexed(
        (index, filter) => FilterItem(
          index: index + customItems.length + favourites.length,
          filterType: FilterType.quick,
          icon: filter.uiIcon,
          title: filter.titleOrFailback(context.l10n),
          onTap: () {
            onFilterTap(
              filter,
              index + customItems.length + favourites.length,
            );
          },
        ),
      ),
    ];

    return widgets.QuickFilters(
      padding: padding,
      filters: items,
      selectedIndex: selectedIndex,
      itemBackground: itemBackground,
    );
  }

  void _showRouting(
    AppFeatures naviFeature,
    FavouriteItem point,
    BuildContext context,
  ) {
    if (naviFeature.naviEnabled) {
      RoutingRoutesRoute(
        finishLabel: point.title,
        finishLatitude: point.coordinates.latitude,
        finishLongitude: point.coordinates.longitude,
        finishLevelId: null,
        finishObjectId: null,
        finishEntranceId: null,
        startLabel: context.l10n.myLocation,
        startLatitude: null,
        startLongitude: null,
        startObjectId: null,
        startEntranceId: null,
        startLevelId: null,
      ).push(context);
    }
  }
}
