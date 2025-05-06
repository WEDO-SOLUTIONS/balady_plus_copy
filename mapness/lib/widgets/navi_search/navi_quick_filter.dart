import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/widgets/navi_search/providers/navi_quick_filter_provider.dart';
import 'package:mapness/widgets/navi_search/vertical_chip.dart';

class NaviQuickFilter extends ConsumerWidget {
  final ValueChanged<String>? onFilterSelected;
  const NaviQuickFilter({this.onFilterSelected, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quickFilters = ref.watch(naviQuickFilterProvider).where((filter) => filter.icon != null).toList();

    return Container(
      color: context.colorsV3.backgroundSurface2,
      padding: const EdgeInsets.only(bottom: Spacing.$4x),
      child: SizedBox(
        height: 70,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: quickFilters.length,
          itemBuilder: (context, index) {
            final filter = quickFilters[index];

            final isFirst = index == 0;
            final isLast = index == quickFilters.length - 1;

            return Container(
              margin: EdgeInsetsDirectional.only(
                start: isFirst ? Spacing.$4x : Spacing.$2x,
                end: isLast ? Spacing.$4x : 0.0,
              ),
              child: VerticalChip(
                icon: filter.icon!,
                title: filter.title,
                onTap: () => onFilterSelected?.call(filter.query),
              ),
            );
          },
        ),
      ),
    );
  }
}
