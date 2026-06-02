import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/widgets/decorated_smooth_radius.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/saudi_pass/views/settings_screen_view.dart';
import 'package:mapness/features/saudi_pass/widgets/reset_save_widget.dart';
import 'package:mapness/features/saudi_pass/widgets/saudi_pass_city_selection_widget.dart';
import 'package:mapness/features/saudi_pass/widgets/saudi_pass_scaffold.dart';
import 'package:mapness/features/saudi_pass/widgets/selection_dialog_view_widget.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class SettingsScreenViewWidget extends StatelessWidget {
  final SettingsScreenView settingsScreenView;

  const SettingsScreenViewWidget({required this.settingsScreenView, super.key});

  @override
  Widget build(BuildContext context) => Container(
    color: context.colors.backgroundSurface4,
    padding: const EdgeInsets.only(top: Spacing.$4x),
    child: SaudiPassScaffold(
      onBackButton: () => settingsScreenView.tapBack(context),
      title: context.l10n.saudiPassSettingsPageTitle,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: settingsScreenView,
          builder: (context, _) {
            final parentCategories = settingsScreenView.parentCategoriesWithCounts;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        SaudiPassCitySelection(
                          title: settingsScreenView.cityTitle,
                          onTap: () => settingsScreenView.tapCity(context),
                        ),
                        const SizedBox(height: Spacing.$3x),
                        SettingsCardWidget(
                          title: context.l10n.saudiPassOffersPageFilterType,
                          child: WrapLayout(settingsScreenView.typeSelectionViews),
                        ),
                        const SizedBox(height: Spacing.$3x),
                        SettingsCategoryCardWidget(
                          title: context.l10n.saudiPassOffersPageFilterCategory,
                          onDetailedTap: () => settingsScreenView.tapShowAllCategories(context),
                          child: Wrap(
                            spacing: Spacing.$2x,
                            runSpacing: Spacing.$2x,
                            children: parentCategories
                                .map(
                                  (cat) => CategoryChipWidget(
                                    title: cat.name,
                                    count: cat.selectedCount,
                                    isHighlighted: cat.selectedCount > 0,
                                    onTap: () => settingsScreenView.tapCategory(cat.id),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Spacing.$3x),
                  ResetSaveWidget(settingsScreenView),
                ],
              ),
            );
          },
        ),
      ),
    ),
  );
}

class SettingsCardWidget extends StatelessWidget {
  final String title;
  final Widget child;

  const SettingsCardWidget({required this.child, required this.title, super.key});

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: const BorderRadius.all(Radius.circular(RadiusBorder.xl)),
    child: ColoredBox(
      color: context.profileCardColor,
      child: Padding(
        padding: const EdgeInsets.all(Spacing.$4x),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: context.textStyles.bodyLargeSemiBold.copyWith(color: context.colors.foregroundDefault)),
            const SizedBox(height: Spacing.$3x),
            child,
          ],
        ),
      ),
    ),
  );
}

class SettingsCategoryCardWidget extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback onDetailedTap;

  const SettingsCategoryCardWidget({required this.child, required this.title, required this.onDetailedTap, super.key});

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: const BorderRadius.all(Radius.circular(RadiusBorder.xl)),
    child: ColoredBox(
      color: context.profileCardColor,
      child: Padding(
        padding: const EdgeInsets.all(Spacing.$4x),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: context.textStyles.bodyLargeSemiBold.copyWith(color: context.colors.foregroundDefault),
                ),
                TextButton(
                  onPressed: onDetailedTap,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Row(
                    children: [
                      Text(
                        context.l10n.saudiPassCategoryDetailed,
                        style: context.textStyles.bodySmallSemiBold.copyWith(color: context.colors.accentDefault),
                      ),
                      Icon(SystemIcons.arrowCornerRightSmall, color: context.colors.accentDefault),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.$3x),
            child,
          ],
        ),
      ),
    ),
  );
}

class CategoryChipWidget extends StatelessWidget {
  final String title;
  final int count;
  final bool isHighlighted;
  final VoidCallback onTap;

  const CategoryChipWidget({
    required this.title,
    required this.count,
    required this.isHighlighted,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isHighlighted
        ? context.colors.accentSecondaryDefault
        : context.colors.neutralContainerDefault;
    final textColor = isHighlighted ? context.colors.accentOnAccent : context.colors.foregroundDefault;
    final countColor = isHighlighted ? context.colors.accentOnAccent : context.colors.accentSecondaryMuted;

    return GestureDetector(
      onTap: onTap,
      child: DecoratedSmoothRadius(
        borderRadius: RadiusBorder.m,
        color: backgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.$3x),
          child: SizedBox(
            height: AppSizes.xs,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: context.textStyles.bodySmallMedium.copyWith(color: textColor)),
                if (count > 0) ...[
                  const SizedBox(width: Spacing.$1x),
                  Text(
                    count.toString(),
                    style: context.textStyles.bodySmallMedium.copyWith(color: countColor),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
