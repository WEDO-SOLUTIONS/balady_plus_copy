import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/saudi_pass/views/offers_screen_view.dart';
import 'package:mapness/features/saudi_pass/widgets/offers_list_widget.dart';
import 'package:mapness/features/saudi_pass/widgets/set_preferences_placeholder_widget.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/ar_functions.dart';

class PrefsContentWidget extends ConsumerWidget {
  final OffersScreenView offersListView;

  const PrefsContentWidget(this.offersListView, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.read(authProvider.notifier);
    final sso = ref.watch(authProvider);
    final isLoginVisible = sso.value == null;

    final l10n = context.l10n;

    String pluralTypes(int types) => switch (getPluralForAr(types)) {
          Plurals.zero => l10n.saudiPassOffersPreferencesTypesPluralZero,
          Plurals.one => l10n.saudiPassOffersPreferencesTypesPluralOne,
          Plurals.two => l10n.saudiPassOffersPreferencesTypesPluralTwo,
          Plurals.few => l10n.saudiPassOffersPreferencesTypesPluralFew,
          Plurals.many => l10n.saudiPassOffersPreferencesTypesPluralMany,
          Plurals.others => l10n.saudiPassOffersPreferencesTypesPluralOther,
        };

    String pluralCategories(int categories) => switch (getPluralForAr(categories)) {
          Plurals.zero => l10n.saudiPassOffersPreferencesCategoriesPluralZero,
          Plurals.one => l10n.saudiPassOffersPreferencesCategoriesPluralOne,
          Plurals.two => l10n.saudiPassOffersPreferencesCategoriesPluralTwo,
          Plurals.few => l10n.saudiPassOffersPreferencesCategoriesPluralFew,
          Plurals.many => l10n.saudiPassOffersPreferencesCategoriesPluralMany,
          Plurals.others => l10n.saudiPassOffersPreferencesCategoriesPluralOther,
        };

    if (isLoginVisible) {
      return Padding(
        padding: const EdgeInsets.only(top: Spacing.$3x),
        child: LoginPreferencesPlaceholderWidget(action: auth.doAuth),
      );
    }

    final prefsTextStyle = context.textStyleV3.captionLargeMedium.copyWith(color: context.colorsV3.foregroundMuted);

    return FutureBuilder(
      key: ObjectKey(offersListView.prefsOffersViewFuture),
      future: offersListView.prefsOffersViewFuture,
      builder: (_, snap) {
        if (snap.hasError) {
          return Padding(
            padding: const EdgeInsets.only(top: Spacing.$4x),
            child: WentWrongPlaceholderWidget(action: offersListView.tapRetryPrefs),
          );
        }

        final prefsOffersView = snap.data;

        if (prefsOffersView != null) {
          return ListenableBuilder(
            listenable: prefsOffersView,
            builder: (context, _) {
              if (prefsOffersView.isSetPreferencesOrOffersVisible) {
                return Padding(
                  padding: const EdgeInsets.only(top: Spacing.$3x),
                  child: SetPreferencesPlaceholderWidget(action: prefsOffersView.tapGotoPreferences),
                );
              } else {
                final types = '${prefsOffersView.types} ${pluralTypes(prefsOffersView.types)}';
                final categories = '${prefsOffersView.categories} ${pluralCategories(prefsOffersView.categories)}';
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: Spacing.$1x),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${prefsOffersView.cityTitle}, $types, $categories',
                          style: prefsTextStyle,
                        ),
                        IconButton(
                          onPressed: prefsOffersView.tapIconEdit,
                          icon: const Icon(
                            General16Icons.edit,
                            size: 14,
                          ),
                          color: context.colorsV3.neutralDefault,
                        ),
                      ],
                    ),
                    const SizedBox(height: Spacing.$4x),
                    Expanded(child: OffersListWidget(prefsOffersView.asyncIterableOffers)),
                  ],
                );
              }
            },
          );
        }

        return const Center(child: Loading(size: LoaderSize.large));
      },
    );
  }
}
