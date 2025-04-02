import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/features/saudi_pass/views/settings_screen.dart';
import 'package:mapness/features/saudi_pass/widgets/saudi_pass_chips_widget.dart';
import 'package:mapness/features/saudi_pass/widgets/saudi_pass_scaffold.dart';
import 'package:mapness/features/saudi_pass/widgets/selection_dialog_widget.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class SettingsScreenWidget extends StatelessWidget {
  final SettingsScreen settingsScreen;

  const SettingsScreenWidget({required this.settingsScreen, super.key});

  @override
  Widget build(BuildContext context) => SaudiPassScaffold(
        onBackButton: settingsScreen.tapBack,
        title: context.l10n.saudiPassSettingsPageTitle,
        body: ListenableBuilder(
          listenable: settingsScreen,
          builder: (context, _) => Padding(
            padding: const EdgeInsets.all(Spacing.$4x),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      SettingsCardWidget(
                        title: context.l10n.saudiPassCitySelectionPageTitle,
                        child: SaudiPassChipsWidget(
                          title: settingsScreen.cityTitle,
                          onTap: settingsScreen.tapCity,
                          style: ChipsStyle.whiteBackground,
                        ),
                      ),
                      const SizedBox(height: Spacing.$3x),
                      SettingsCardWidget(
                        title: context.l10n.saudiPassOffersPageFilterType,
                        child: WrapLayout(settingsScreen.typeSelectionViews),
                      ),
                      const SizedBox(height: Spacing.$3x),
                      SettingsCardWidget(
                        title: context.l10n.saudiPassOffersPageFilterCategory,
                        child: WrapLayout(settingsScreen.categorySelectionViews),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Spacing.$3x),
                ResetSaveWidget(settingsScreen),
              ],
            ),
          ),
        ),
      );
}

class SettingsCardWidget extends StatelessWidget {
  final String title;
  final Widget child;

  const SettingsCardWidget({
    required this.child,
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(RadiusBorder.xl)),
        child: ColoredBox(
          color: context.colorsV3.backgroundSurface1,
          child: Padding(
            padding: const EdgeInsets.all(Spacing.$4x),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  style: context.textStyleV3.bodyLargeSemiBold.copyWith(color: context.colorsV3.foregroundDefault),
                ),
                const SizedBox(height: Spacing.$3x),
                child,
              ],
            ),
          ),
        ),
      );
}
