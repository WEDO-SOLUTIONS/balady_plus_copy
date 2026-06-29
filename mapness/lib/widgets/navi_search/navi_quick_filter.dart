import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/quick_filters/quick_filter.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/ui/toast/app_locale.dart';
import 'package:mapness/widgets/navi_search/more_filter_chip.dart';
import 'package:mapness/widgets/navi_search/providers/navi_quick_filter_provider.dart';
import 'package:mapness/widgets/navi_search/vertical_chip.dart';

class NaviQuickFilter extends ConsumerWidget {
  final ValueChanged<String>? onFilterSelected;
  final bool showMoreView;
  final VoidCallback? onMoreTap;

  const NaviQuickFilter({
    this.onFilterSelected,
    this.showMoreView = false,
    this.onMoreTap,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.watch(appLocaleProvider);
    final language = ref.watch(appLanguageProvider);
    final quickFilters = ref.watch(naviQuickFilterProvider).where((filter) => filter.icon != null).toList();
    final secondaryItems = NaviQuickFilterMoreList().list;

    return Container(
      color: context.colors.backgroundSurface1,
      padding: const EdgeInsets.only(bottom: Spacing.$4x),
      child: showMoreView
          ? _SecondaryQuickFiltersView(
              key: const ValueKey('secondary-quick-filters'),
              items: secondaryItems,
              locale: l10n,
              language: language,
              onTap: (query) {
                onFilterSelected?.call(query);
                onMoreTap?.call();
              },
            )
          : SizedBox(
              key: const ValueKey('primary-quick-filters'),
              height: 70,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: quickFilters.length + 1,
                itemBuilder: (context, index) {
                  final isMore = index == quickFilters.length;
                  final isFirst = index == 0;
                  final isLast = index == quickFilters.length;

                  return Container(
                    margin: EdgeInsetsDirectional.only(
                      start: isFirst ? Spacing.$4x : Spacing.$2x,
                      end: isLast ? Spacing.$4x : 0.0,
                    ),
                    child: isMore
                        ? VerticalChip(
                            icon: SystemIcons.ellipsis,
                            title: context.l10n.more,
                            onTap: onMoreTap,
                          )
                        : VerticalChip(
                            icon: quickFilters[index].icon!,
                            title: quickFilters[index].title,
                            onTap: () => onFilterSelected?.call(quickFilters[index].query),
                          ),
                  );
                },
              ),
            ),
    );
  }
}

class _SecondaryQuickFiltersView extends StatelessWidget {
  final List<NaviQuickFilterMore> items;
  final Language language;
  final AppLocalizations locale;
  final ValueChanged<String> onTap;

  const _SecondaryQuickFiltersView({
    required this.items,
    required this.language,
    required this.locale,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(Spacing.$4x),
    child: GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: Spacing.$3x,
        crossAxisSpacing: Spacing.$2x,
        childAspectRatio: 0.99,
      ),
      itemBuilder: (context, index) {
        final item = items[index];

        return MoreFilterChip(
          icon: item.icon ?? PlacesIcons.markets,
          title: item.title(locale),
          onTap: () => onTap(
            item.query[language] ?? item.query[Language.english] ?? '',
          ),
        );
      },
    ),
  );
}
