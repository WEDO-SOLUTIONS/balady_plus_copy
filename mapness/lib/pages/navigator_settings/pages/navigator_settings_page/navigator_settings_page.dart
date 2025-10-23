import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/pages/navigator_settings/pages/navigator_settings_page/navigator_settings_page_content.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

@RoutePage()
class NavigatorSettingsPage extends ConsumerWidget {
  const NavigatorSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Material(
          color: context.colors.backgroundSurface4,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: Spacing.$4x),
              child: Scaffold(
                appBar: BaladyTopBar.iconAndText(
                  systemUiOverlayStyle: SystemUiOverlayStyle.dark,
                  title: context.l10n.navigatorSettings,
                  textStyle: context.textStyles.bodyLargeSemiBold.copyWith(
                    color: context.colors.foregroundDefault,
                  ),
                  leading: ActionModel(
                    onPressed: () => context.router.popForced(),
                    icon: SystemIcons.arrowCornerLeftLarge,
                  ),
                ),
                body: const NavigatorSettingsPageContent(),
              ),
            ),
          ),
        ),
      );
}
