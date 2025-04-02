import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/saudi_pass/views/offers_screen_view.dart';
import 'package:mapness/features/saudi_pass/widgets/saudi_pass_chips_widget.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class OffersFiltersViewWidget extends StatelessWidget {
  final OffersFiltersView view;

  const OffersFiltersViewWidget(this.view, {super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ListenableBuilder(
      listenable: view,
      builder: (context, _) {
        final filters = [
          SaudiPassChipsWidget(
            onTap: view.tapSort,
            isSelected: view.isSortHighlighted,
            leadingIcon: ChipIconData(TransportIcons.verticalChange),
            style: ChipsStyle.colorfulBackground,
            size: ChipsSize.medium,
          ),
          SaudiPassChipsWidget(
            onTap: view.tapSettings,
            leadingIcon: ChipIconData(SystemIcons.tuning),
            isSelected: view.isSettingsHighlighted,
            style: ChipsStyle.colorfulBackground,
            size: ChipsSize.medium,
          ),
          FilterWidget(
            filter: view.cityFilterView,
            l10nString: l10n.saudiPassCitySelectionPageTitle,
            onTap: view.tapCity,
          ),
          FilterWidget(
            filter: view.typeFilterView,
            l10nString: l10n.saudiPassOffersPageFilterType,
            onTap: view.tapType,
          ),
          FilterWidget(
            filter: view.categoryFilterView,
            l10nString: l10n.saudiPassOffersPageFilterCategory,
            onTap: view.tapCategory,
          ),
        ];

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.$3x),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, index) => filters.elementAt(index),
          separatorBuilder: (_, __) => const SizedBox(width: Spacing.$3x),
          itemCount: filters.length,
        );
      },
    );
  }
}

class FilterWidget extends StatelessWidget {
  final FilterView filter;
  final String l10nString;
  final VoidCallback onTap;

  const FilterWidget({
    required this.filter,
    required this.l10nString,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ChipIconWidget trailingIcon(FilterView filter) =>
        ChipIconWidget(
              ({required isSelected}) {
            final color = filter.isHighlighted ? context.colorsV2.accentOnAccent : context.colorsV2.foregroundDefault;
            return InkWell(
              onTap: filter.isHighlighted ? filter.tapCross : null,
              child: Icon(
                filter.isHighlighted ? SystemIcons.closeSmall : SystemIcons.arrowCornerDownSmall,
                color: color,
              ),
            );
          },
        );

    return SaudiPassChipsWidget(
      title: filter.title ?? l10nString,
      label: filter.plusMore,
      onTap: onTap,
      trailingIcon: trailingIcon(filter),
      style: ChipsStyle.colorfulBackground,
      size: ChipsSize.medium,
      isSelected: filter.isHighlighted,
    );
  }
}
