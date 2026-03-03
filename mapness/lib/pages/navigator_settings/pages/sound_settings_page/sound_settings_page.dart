import 'package:mapness/shared/providers/theme_controller.dart';
import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/pages/navigator_settings/pages/sound_settings_page/sound_settings_page_content.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:provider/provider.dart';

@RoutePage()
class SoundSettingsPage extends ConsumerStatefulWidget {
  const SoundSettingsPage({super.key});

  @override
  ConsumerState<SoundSettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SoundSettingsPage> {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final textStyles = context.textStyles;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: context.read<ThemeController>().systemOverlayStyle,
      child: Material(
        color: colors.backgroundSurface4,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: Spacing.$4x),
            child: Scaffold(
              appBar: BaladyTopBar.iconAndText(
                systemUiOverlayStyle: context.read<ThemeController>().systemOverlayStyle,
                title: l10n.soundSettings,
                textStyle: textStyles.bodyLargeSemiBold.copyWith(color: colors.foregroundDefault),
                leading: ActionModel(onPressed: () => context.router.pop(), icon: SystemIcons.arrowCornerLeftLarge),
              ),
              body: const SoundSettingsPageContent(),
            ),
          ),
        ),
      ),
    );
  }
}
