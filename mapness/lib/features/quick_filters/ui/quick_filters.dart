import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/_features/favourites/providers/favourite_cache.dart';
import 'package:mapness/_features/landing/providers/quick_filter_request_source_screen.dart';
import 'package:mapness/app/routes/routing.dart';
import 'package:mapness/entities/quick_filters/quick_filter.dart' as models;
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_features.dart';
import 'package:mapness/widgets/quick_filters/models/filter_item.dart';
import 'package:mapness/widgets/quick_filters/ui/quick_filters.dart' as widgets;

class QuickFilters extends ConsumerWidget {
  final models.QuickFilter? selectedQuickFilter;
  final List<FilterItem>? customFilters;
  final ValueChanged<models.QuickFilter> onQuickFilterTap;
  final void Function() onFavouritesTap;
  final void Function() onFavouritesBookmarkTap;
  final void Function(FilterItem)? onCustomTap;
  final EdgeInsets padding;
  final QuickFilterScreen id;
  final bool isDashboard;

  const QuickFilters({
    required this.onQuickFilterTap,
    required this.onFavouritesTap,
    required this.onFavouritesBookmarkTap,
    required this.id,
    required this.isDashboard,
    super.key,
    this.selectedQuickFilter,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 16,
    ),
    this.customFilters,
    this.onCustomTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

            onFavouritesTap();
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

            onFavouritesTap();
            _showRouting(naviFeature, point, context);
          },
        ),
    ];

    final customItems = customFilters ?? [];

    final items = [
      ...customItems,
      ...favourites,
      ...models.QuickFilter.values.map(
        (filter) => FilterItem(
            filterType: FilterType.quick,
            title: filter.title(context.l10n),
            selected: filter == selectedQuickFilter,
            onTap: () => onQuickFilterTap(filter)),
      ),
    ];

    return widgets.QuickFilters(
      padding: padding,
      filters: items,
      isDashboard: isDashboard,
      id: id,
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
