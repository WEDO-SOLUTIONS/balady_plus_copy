import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/favourites/favourite_item.dart';
import 'package:mapness/entities/quick_filters/quick_filter.dart' as models;
import 'package:mapness/entities/quick_filters/quick_filter.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/features/favourites/providers/favourite_cache.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/quick_filters/models/filter_item.dart';
import 'package:mapness/widgets/quick_filters/ui/quick_filters.dart' as widgets;

class QuickFilters extends ConsumerWidget {
  final List<FilterItem>? customFilters;
  final ValueChanged<models.QuickFilter> onQuickFilterTap;
  final void Function() onFavouritesTap;
  final void Function() onFavouritesBookmarkTap;
  final void Function(FilterItem)? onCustomTap;
  final EdgeInsets padding;
  final double? height;
  final ScrollController? scrollController;

  const QuickFilters({
    required this.onQuickFilterTap,
    required this.onFavouritesTap,
    required this.onFavouritesBookmarkTap,
    this.height,
    super.key,
    this.padding = const EdgeInsets.only(bottom: 16.0),
    this.customFilters,
    this.onCustomTap,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favouritesState = ref.watch(favouriteCacheProvider);

    final favourites = <FilterItem>[
      if (favouritesState.value?.home != null)
        FilterItemConfig(
          filterType: FilterType.home,
          title: context.l10n.home,
          icon: GeneralIcons.home,
          onTap: () {
            final home = favouritesState.value?.home;
            if (home != null) {
            } else {
              return;
            }

            onFavouritesTap();
            _showRouting(home, context);
          },
        ),
      if (favouritesState.value?.work != null)
        FilterItemConfig(
          filterType: FilterType.work,
          title: context.l10n.work,
          icon: GeneralIcons.briefcase,
          onTap: () {
            final work = favouritesState.value?.work;
            if (work != null) {
            } else {
              return;
            }

            onFavouritesTap();
            _showRouting(work, context);
          },
        ),
    ];

    final customItems = customFilters ?? [];

    final items = [
      FilterItemConfig(
        filterType: FilterType.favourites,
        icon: SystemIcons.bookmark,
        semanticsLabel: context.l10n.favourites,
        onTap: onFavouritesBookmarkTap,
      ),
      ...customItems,
      ...favourites,
      ...models.QuickFilterList().list.map(
        (filter) => FilterItemConfig(
          filterType: FilterType.quick,
          title: filter.title(context.l10n),
          icon: filter.icon,
          onTap: () => onQuickFilterTap(filter),
        ),
      ),
    ];

    return widgets.QuickFilters(
      padding: padding,
      filters: items,
      height: height,
      scrollController: scrollController,
    );
  }

  void _showRouting(
    FavouriteItem point,
    BuildContext context,
  ) {
    context.router.push(
      RoutingRoutesRoute(
        points: [
          RouteParamsPointWithLabel(
            value: null,
            label: context.l10n.myLocation,
          ),
          RouteParamsPointWithLabel(
            value: RouteParamsPoint(
              latitude: point.coordinates.latitude,
              longitude: point.coordinates.longitude,
            ),
            label: point.title,
          ),
        ],
      ),
    );
  }
}
