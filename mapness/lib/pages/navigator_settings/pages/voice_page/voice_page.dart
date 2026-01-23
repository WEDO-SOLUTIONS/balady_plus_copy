import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/pages/navigator_settings/pages/voice_page/voice_page_content.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

@RoutePage()
class VoiceSettingsPage extends ConsumerStatefulWidget {
  const VoiceSettingsPage({super.key});

  @override
  ConsumerState<VoiceSettingsPage> createState() => _VoiceSettingsPageState();
}

class _VoiceSettingsPageState extends ConsumerState<VoiceSettingsPage> {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Material(
        color: colors.backgroundSurface4,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: Spacing.$4x),
            child: Scaffold(
              appBar: BaladyTopBar.iconAndText(
                systemUiOverlayStyle: SystemUiOverlayStyle.dark,
                title: l10n.voice,
                textStyle: context.textStyles.bodyLargeSemiBold.copyWith(
                  color: colors.foregroundDefault,
                ),
                leading: ActionModel(
                  onPressed: () => context.router.pop(),
                  icon: SystemIcons.arrowCornerLeftLarge,
                ),
              ),
              body: const VoicePageContent(),
            ),
          ),
        ),
      ),
    );
  }
}
