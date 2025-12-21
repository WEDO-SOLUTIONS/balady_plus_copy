import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart' hide IconButton;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/saudi_pass/notifiers/category_selection_dialog_view_notifier.dart';
import 'package:mapness/features/saudi_pass/notifiers/city_selection_dialog_view_notifier.dart';
import 'package:mapness/features/saudi_pass/providers/get_all_lookups_provider.dart';
import 'package:mapness/features/saudi_pass/providers/get_profile_preferences_provider.dart';
import 'package:mapness/features/saudi_pass/providers/profile_preferences_provider.dart';
import 'package:mapness/features/saudi_pass/providers/set_profile_preferences_provider.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart';
import 'package:mapness/features/saudi_pass/widgets/saudi_pass_chips_selection_widget.dart';
import 'package:mapness/features/saudi_pass/widgets/saudi_pass_city_selection_widget.dart';
import 'package:mapness/features/saudi_pass/widgets/settings_screen_view_widget.dart';
import 'package:mapness/features/saudi_pass/widgets/small_chip_widget.dart';
import 'package:mapness/shared/entities/selection.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/error_widget/fullscreen_error_widget.dart';

@RoutePage()
class ProfilePreferencesPage extends ConsumerWidget {
  const ProfilePreferencesPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;

    void popWithPreferences() {
      context.router.popForced(ref.read(getProfilePreferencesProvider.future));
    }

    ref.listen(setProfilePreferencesProvider, (prev, next) {
      if (next == SetProfilePreferencesState.setSuccess) {
        popWithPreferences();
      }
    });

    final profilePreferences = ref.watch(profilePreferencesProvider);
    final setPreferencesProvider = ref.watch(setProfilePreferencesProvider);

    final isLoading = profilePreferences.isLoading ||
        setPreferencesProvider == SetProfilePreferencesState.loading;
    final hasProfilePreferencesError = profilePreferences.hasError;
    final hasSetPreferencesError =
        setPreferencesProvider == SetProfilePreferencesState.setError ||
            setPreferencesProvider == SetProfilePreferencesState.resetError;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Material(
        color: colors.backgroundSurface4,
        child: SafeArea(
          child: Scaffold(
            appBar: BaladyTopBar.iconAndText(
              title: context.l10n.preferences,
              textStyle: context.textStyles.bodyLargeSemiBold.copyWith(
                color: colors.foregroundDefault,
              ),
              leading: ActionModel(
                onPressed: popWithPreferences,
                icon: SystemIcons.arrowCornerLeftLarge,
              ),
            ),
            body: isLoading
                ? Center(child: Loading.large())
                : hasProfilePreferencesError
                    ? _ErrorWidget(
                        onRetry: () =>
                            ref.invalidate(profilePreferencesProvider))
                    : hasSetPreferencesError
                        ? _ErrorWidget(
                            onRetry: ref
                                .read(setProfilePreferencesProvider.notifier)
                                .retry)
                        : const _Content(),
          ),
        ),
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorWidget({required this.onRetry, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => FullscreenErrorWidget(
        onRetry: onRetry,
        errorTitle: context.l10n.failedToLoadData,
        backgroundColor: context.colors.backgroundSurface4,
      );
}

class _Content extends ConsumerWidget {
  const _Content();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferencesProvider = ref.watch(profilePreferencesProvider);
    if (!preferencesProvider.hasValue) {
      return const SizedBox.shrink();
    }

    final preferences = preferencesProvider.requireValue;
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: Spacing.$4x, right: Spacing.$4x),
              child: Column(
                children: [
                  SaudiPassCitySelection(
                    title: preferences.city?.name,
                    onTap: () => _selectCity(context, ref),
                  ),
                  Spacing.$3x.heightBox,
                  _SelectRecommendedTypes(
                    items: preferences.recommendedTypes,
                    onItemTap: (item) => ref
                        .watch(profilePreferencesProvider.notifier)
                        .changeRecommendedType(item),
                  ),
                  Spacing.$3x.heightBox,
                  _SelectCategories(
                    items: preferences.subCategories,
                    allCategories: preferences.allCategories,
                    onCategoryTap: (categoryId) => ref
                        .read(profilePreferencesProvider.notifier)
                        .toggleCategory(categoryId),
                    onDetailedTap: () => _onCategoriesTap(context, ref),
                  ),
                  // TODO: uncomment when profile editing page will be implemented
                  // Spacing.$3x.heightBox,
                  // const _EditAccount(),
                ],
              ),
            ),
          ),
        ),
        _ButtonsContainer(
          onSave: () => ref.read(setProfilePreferencesProvider.notifier).set(),
          onReset: () =>
              ref.read(setProfilePreferencesProvider.notifier).reset(),
        ),
      ],
    );
  }

  Future<void> _selectCity(BuildContext context, WidgetRef ref) async {
    final lookups = await ref.read(getAllLookupsProvider.future);
    final notifier = CitySelectionDialogViewNotifier(lookups.cities);
    final city = await context.router.push<City>(
        CitySelectionDialogViewRoute(citySelectionDialogView: notifier));
    if (city != null) {
      ref.read(profilePreferencesProvider.notifier).setCity(city);
    }
  }

  Future<void> _onCategoriesTap(BuildContext context, WidgetRef ref) async {
    final prefs = await ref.read(profilePreferencesProvider.future);
    final allSubs = prefs.subCategories.map((it) => it.value);
    final selectedSubs = prefs.subCategories
        .where((it) => it.selected)
        .map((it) => it.value)
        .toSet();

    final notifier = CategorySelectionDialogViewNotifier(
      (
        prefs.allCategories,
        allSubs,
        selectedSubs,
        ref.read(profilePreferencesProvider.notifier).applySubCategories,
      ),
    );

    await context.router.push(
      AllCategoriesSelectionDialogViewRoute(selectionDialogView: notifier),
    );

    final updated = notifier.selected;

    if (!setEquals(selectedSubs, updated)) {
      unawaited(ref.read(setProfilePreferencesProvider.notifier).set());
    }
  }
}

class _ButtonsContainer extends StatelessWidget {
  final VoidCallback onSave;
  final VoidCallback onReset;

  const _ButtonsContainer({
    required this.onSave,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final resetButton = AppButton(
      primaryLabel: context.l10n.saudiPassDialogReset,
      onTap: onReset,
      size: ButtonSize.large,
      buttonColorScheme: ButtonColorScheme.accentSecondary,
      buttonType: ButtonType.secondary,
    );

    final saveButton = AppButton(
      primaryLabel: context.l10n.saudiPassDialogSave,
      onTap: onSave,
      size: ButtonSize.large,
      buttonColorScheme: ButtonColorScheme.accentSecondary,
    );

    return Padding(
      padding: const EdgeInsets.only(
        left: Spacing.$4x,
        right: Spacing.$4x,
        bottom: Spacing.$4x,
      ),
      child: Row(
        children: [
          Expanded(child: resetButton),
          const SizedBox(width: Spacing.$2x),
          Expanded(child: saveButton),
        ],
      ),
    );
  }
}

// TODO: uncomment when profile editing page will be implemented
// ignore: unused_element
class _EditAccount extends StatelessWidget {
  const _EditAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(Spacing.$4x),
      decoration: BoxDecoration(
        color: context.colors.backgroundSurface1,
        borderRadius: const BorderRadius.all(Radius.circular(RadiusBorder.xl)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.saudiPassBestOffersForYou,
            style: context.textStyles.bodyLargeSemiBold
                .copyWith(color: colors.foregroundDefault),
          ),
          Spacing.$0_5x.heightBox,
          Text(
            context.l10n.saudiPassBestOffersForYouDescription,
            style: context.textStyles.bodySmallRegular
                .copyWith(color: colors.foregroundSoft),
          ),
          Spacing.$3x.heightBox,
          SizedBox(
            width: double.infinity,
            child: AppButton(
              buttonColorScheme: ButtonColorScheme.accentSecondary,
              primaryLabel: context.l10n.editAccount,
              secondaryIcon: General16Icons.edit,
              onTap: () {
                // TODO: open profile editing page
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectCategories extends ConsumerWidget {
  final List<Selection<SubCategory>> items;
  final Iterable<Category> allCategories;
  final Function(String categoryId) onCategoryTap;
  final VoidCallback onDetailedTap;

  const _SelectCategories({
    required this.items,
    required this.allCategories,
    required this.onCategoryTap,
    required this.onDetailedTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sortedCategories = Category.displayOrder
        .map((id) => allCategories.where((cat) => cat.id == id).firstOrNull)
        .whereType<Category>();

    final parentCategoriesWithCounts = sortedCategories.map((category) {
      final subcategoriesForCategory =
          items.where((sub) => sub.value.categoryId == category.id);
      final selectedCount =
          subcategoriesForCategory.where((sub) => sub.selected).length;
      return (
        id: category.id,
        name: category.name,
        selectedCount: selectedCount,
      );
    }).toList()
      ..sort((a, b) {
        final aSelected = a.selectedCount > 0;
        final bSelected = b.selectedCount > 0;
        if (aSelected && !bSelected) {
          return -1;
        }
        if (!aSelected && bSelected) {
          return 1;
        }
        return 0;
      });

    return SettingsCategoryCardWidget(
      title: context.l10n.saudiPassOffersPageFilterCategory,
      onDetailedTap: onDetailedTap,
      child: Wrap(
        spacing: Spacing.$2x,
        runSpacing: Spacing.$2x,
        children: parentCategoriesWithCounts
            .map(
              (cat) => CategoryChipWidget(
                title: cat.name,
                count: cat.selectedCount,
                isHighlighted: cat.selectedCount > 0,
                onTap: () => onCategoryTap(cat.id),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _SelectRecommendedTypes extends ConsumerWidget {
  final List<Selection<RecommendedType>> items;
  final Function(Selection<RecommendedType>) onItemTap;

  const _SelectRecommendedTypes({
    required this.items,
    required this.onItemTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      SaudiPassChipsSelectionWidget<RecommendedType>(
        title: context.l10n.saudiPassOffersPageFilterType,
        items: items,
        itemBuilder: (context, item) => SmallChipWidget(
          title: item.value.name,
          isHighlighted: item.selected,
          onTap: () => onItemTap(item),
        ),
      );
}
