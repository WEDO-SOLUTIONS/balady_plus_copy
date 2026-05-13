import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapness/pages/navigator_settings/pages/dark_map_page/dark_map_page_content.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:provider/provider.dart';

@RoutePage()
class DarkMapPage extends StatelessWidget {
  const DarkMapPage({super.key});

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
    value: context.read<ThemeController>().systemOverlayStyle,
    child: Scaffold(
      backgroundColor: context.colors.backgroundSurface4,
      appBar: BaladyTopBar(
        systemUiOverlayStyle: context.read<ThemeController>().systemOverlayStyle,
        title: context.l10n.darkMode,
        textStyle: context.textStyles.bodyLargeSemiBold.copyWith(color: context.colors.foregroundDefault),
        onLeadingPressed: () => context.router.pop(),
        leading: Semantics(
          label: context.l10n.a11yBack,
          button: true,
          child: ExcludeSemantics(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: Spacing.$4x),
                Icon(SystemIcons.arrowCornerLeftLarge, color: context.colors.foregroundDefault),
                const SizedBox(width: Spacing.$4x),
              ],
            ),
          ),
        ),
      ),
      body: const SafeArea(child: DarkMapPageContent()),
    ),
  );
}
