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
      appBar: BaladyTopBar.iconAndText(
        systemUiOverlayStyle: context.read<ThemeController>().systemOverlayStyle,
        title: context.l10n.darkMap,
        textStyle: context.textStyles.bodyLargeSemiBold.copyWith(color: context.colors.foregroundDefault),
        leading: ActionModel(onPressed: () => context.router.pop(), icon: SystemIcons.arrowCornerLeftLarge),
      ),
      body: const SafeArea(child: DarkMapPageContent()),
    ),
  );
}
