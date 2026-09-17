import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/pages/navigator_settings/components/dark_map_mode_row_widget.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:urbi_utils/urbi_utils.dart';

class DarkMapPageContent extends ConsumerWidget {
  const DarkMapPageContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = ref.watch(darkModeProvider);
    const darkModes = DarkMapStateEnum.values;
    final isDGA =
        context.read<ThemeController>().currentTheme == BaladyAppThemes.darkDGA ||
        context.read<ThemeController>().currentTheme == BaladyAppThemes.lightDGA;

    return Padding(
      padding: const EdgeInsets.all(Spacing.$4x).copyWith(bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(RadiusBorder.xl),
              child: Image.asset(
                dark.value?.isDark ?? false
                    ? 'assets/images/dark_map_preview.webp'
                    : 'assets/images/light_map_preview.webp',
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
                semanticLabel: context.l10n.a11yImage,
                height: switch (MediaQuery.of(context).orientation) {
                  Orientation.portrait => null,
                  Orientation.landscape => 100,
                },
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: ContentWrapper(
                color: isDGA ? context.colors.accentSecondarySoft : context.colors.backgroundSurface1,
                children: darkModes
                    .mapIndexed<Widget>(
                      (i, e) => DarkMapModeRowWidget(
                        currentMode: e,
                        dividerEnabled: i < darkModes.length - 1,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ].insertBetween(Spacing.$4x.heightBox).toList(),
      ),
    );
  }
}
