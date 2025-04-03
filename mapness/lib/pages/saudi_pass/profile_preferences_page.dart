import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart' hide IconButton;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/saudi_pass/notifiers/city_selection_dialog_view_notifier.dart';
import 'package:mapness/features/saudi_pass/providers/get_all_lookups_provider.dart';
import 'package:mapness/features/saudi_pass/providers/get_profile_preferences_provider.dart';
import 'package:mapness/features/saudi_pass/providers/profile_preferences_provider.dart';
import 'package:mapness/features/saudi_pass/providers/set_profile_preferences_provider.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart';
import 'package:mapness/features/saudi_pass/widgets/saudi_pass_chips_selection_widget.dart';
import 'package:mapness/features/saudi_pass/widgets/saudi_pass_city_selection_widget.dart';
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
    final colors = context.colorsV3;

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

    final isLoading = profilePreferences.isLoading || setPreferencesProvider == SetProfilePreferencesState.loading;
    final hasProfilePreferencesError = profilePreferences.hasError;
    final hasSetPreferencesError = setPreferencesProvider == SetProfilePreferencesState.setError ||
        setPreferencesProvider == SetProfilePreferencesState.resetError;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Material(
        color: colors.backgroundSurface4,
        child: SafeArea(
          child: Scaffold(
            appBar: BaladyTopBar.iconAndText(
              title: context.l10n.preferences,
              textStyle: context.textStyleV3.bodyLargeSemiBold.copyWith(
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
                    ? _ErrorWidget(onRetry: () => ref.invalidate(profilePreferencesProvider))
                    : hasSetPreferencesError
                        ? _ErrorWidget(onRetry: ref.read(setProfilePreferencesProvider.notifier).retry)
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
        backgroundColor: context.colorsV3.backgroundSurface4,
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
              padding: const EdgeInsets.only(left: Spacing.$4x, right: Spacing.$4x),
              child: Column(
                children: [
                  SaudiPassCitySelection(
                    city: preferences.city,
                    onTap: () => _selectCity(context, ref),
                  ),
                  _SelectRecommendedTypes(
                    items: preferences.recommendedTypes,
                    onItemTap: (item) => ref.watch(profilePreferencesProvider.notifier).changeRecommendedType(item),
                  ),
                  Spacing.$3x.heightBox,
                  _SelectCategories(
                    items: preferences.categories,
                    onItemTap: (item) => ref.watch(profilePreferencesProvider.notifier).changeCategory(item),
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
          onReset: () => ref.read(setProfilePreferencesProvider.notifier).reset(),
        ),
      ],
    );
  }

  Future<void> _selectCity(BuildContext context, WidgetRef ref) async {
    final lookups = await ref.read(getAllLookupsProvider.future);
    final notifier = CitySelectionDialogViewNotifier(lookups.cities, context.router);
    final city = await context.router.push<City>(CitySelectionDialogViewRoute(citySelectionDialogView: notifier));
    if (city != null) {
      ref.read(profilePreferencesProvider.notifier).setCity(city);
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
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        decoration: BoxDecoration(color: context.colorsV3.backgroundSurface4),
        padding: const EdgeInsets.only(left: Spacing.$4x, top: Spacing.$3x, right: Spacing.$4x, bottom: Spacing.$4x),
        child: Row(
          children: [
            Expanded(
              child: AppButton(
                buttonColorScheme: ButtonColorScheme.secondary,
                onTap: onReset,
                primaryLabel: context.l10n.saudiPassDialogReset,
              ),
            ),
            Spacing.$2x.widthBox,
            Expanded(
              child: AppButton(
                buttonColorScheme: ButtonColorScheme.primary,
                onTap: onSave,
                primaryLabel: context.l10n.saudiPassDialogSave,
              ),
            ),
          ],
        ),
      );
}

// TODO: uncomment when profile editing page will be implemented
// ignore: unused_element
class _EditAccount extends StatelessWidget {
  const _EditAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = context.colorsV3;
    return Container(
      padding: const EdgeInsets.all(Spacing.$4x),
      decoration: BoxDecoration(
        color: context.colorsV3.backgroundSurface1,
        borderRadius: const BorderRadius.all(Radius.circular(RadiusBorder.xl)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.saudiPassBestOffersForYou,
            style: context.textStyleV3.bodyLargeSemiBold.copyWith(color: colors.foregroundDefault),
          ),
          Spacing.$0_5x.heightBox,
          Text(
            context.l10n.saudiPassBestOffersForYouDescription,
            style: context.textStyleV3.bodySmallRegular.copyWith(color: colors.foregroundSoft),
          ),
          Spacing.$3x.heightBox,
          SizedBox(
            width: double.infinity,
            child: AppButton(
              buttonColorScheme: ButtonColorScheme.secondary,
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
  final List<Selection<Category>> items;
  final Function(Selection<Category>) onItemTap;

  const _SelectCategories({required this.items, required this.onItemTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) => SaudiPassChipsSelectionWidget<Category>(
        title: context.l10n.saudiPassOffersPageFilterCategory,
        items: items,
        itemBuilder: (context, item) => SmallChipWidget(
          title: item.value.name,
          isHighlighted: item.selected,
          onTap: () => onItemTap(item),
        ),
      );
}

class _SelectRecommendedTypes extends ConsumerWidget {
  final List<Selection<RecommendedType>> items;
  final Function(Selection<RecommendedType>) onItemTap;

  const _SelectRecommendedTypes({required this.items, required this.onItemTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) => SaudiPassChipsSelectionWidget<RecommendedType>(
        title: context.l10n.saudiPassOffersPageFilterType,
        items: items,
        itemBuilder: (context, item) => SmallChipWidget(
          title: item.value.name,
          isHighlighted: item.selected,
          onTap: () => onItemTap(item),
        ),
      );
}
