import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/favourites/providers/favourite_repository.dart';
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
    required this.onFavouritesTap,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 16,
    ),
    this.customFilters,
    this.onCustomTap,
    this.itemBackground = const Color(0x0D1E2A36),
  });

  final int? selectedIndex;
  final List<FilterItem>? customFilters;
  final Function(models.QuickFilter, int index) onFilterTap;
  final Function() onFavouritesTap;
  final Function(int index)? onCustomTap;
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
          title: e.title,
        ),
      ),
    ];

    return widgets.QuickFilters(
      padding: padding,
      filters: items,
      selectedIndex: selectedIndex,
      onTap: (index) {
        if (index < customItems.length) {
          onCustomTap?.call(index);
        } else if (index == customItems.length) {
          onFavouritesTap();
        } else if (index >= favourites.length + customItems.length) {
          onFilterTap(
              quickFilters
                  .value![index - favourites.length - customItems.length],
              index);
        }
      },
      itemBackground: itemBackground,
    );
  }
}
