import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/pages/navigator_settings/pages/navigator_settings_page/navigator_settings_page_content.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:provider/provider.dart';

@RoutePage()
class NavigatorSettingsPage extends ConsumerStatefulWidget {
  const NavigatorSettingsPage({this.showDarkModeSection = true, super.key});
  final bool showDarkModeSection;

  @override
  ConsumerState<NavigatorSettingsPage> createState() => _NavigatorSettingsPage();
}

class _NavigatorSettingsPage extends ConsumerState<NavigatorSettingsPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.changeSystemNavBar();
  }

  @override
  Widget build(BuildContext context) => Material(
    color: context.colors.backgroundSurface4,
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: Spacing.$4x),
        child: Scaffold(
          appBar: BaladyTopBar(
            systemUiOverlayStyle: context.read<ThemeController>().systemOverlayStyle,
            title: context.l10n.navigatorSettings,
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
          body: NavigatorSettingsPageContent(showDarkModeSection: widget.showDarkModeSection),
        ),
      ),
    ),
  );
}
