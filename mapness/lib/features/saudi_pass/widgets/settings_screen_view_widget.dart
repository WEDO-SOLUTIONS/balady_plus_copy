import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/features/saudi_pass/views/settings_screen_view.dart';
import 'package:mapness/features/saudi_pass/widgets/saudi_pass_city_selection_widget.dart';
import 'package:mapness/features/saudi_pass/widgets/saudi_pass_scaffold.dart';
import 'package:mapness/features/saudi_pass/widgets/selection_dialog_view_widget.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class SettingsScreenViewWidget extends StatelessWidget {
  final SettingsScreenView settingsScreenView;

  const SettingsScreenViewWidget({required this.settingsScreenView, super.key});

  @override
  Widget build(BuildContext context) => SaudiPassScaffold(
        onBackButton: settingsScreenView.tapBack,
        title: context.l10n.saudiPassSettingsPageTitle,
        body: SafeArea(
          child: ListenableBuilder(
            listenable: settingsScreenView,
            builder: (context, _) => Padding(
              padding: const EdgeInsets.all(Spacing.$4x),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        SaudiPassCitySelection(title: settingsScreenView.cityTitle, onTap: settingsScreenView.tapCity),
                        const SizedBox(height: Spacing.$3x),
                        SettingsCardWidget(
                          title: context.l10n.saudiPassOffersPageFilterType,
                          child: WrapLayout(settingsScreenView.typeSelectionViews),
                        ),
                        const SizedBox(height: Spacing.$3x),
                        SettingsCardWidget(
                          title: context.l10n.saudiPassOffersPageFilterCategory,
                          child: WrapLayout(settingsScreenView.categorySelectionViews),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Spacing.$3x),
                  ResetSaveWidget(settingsScreenView),
                ],
              ),
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
