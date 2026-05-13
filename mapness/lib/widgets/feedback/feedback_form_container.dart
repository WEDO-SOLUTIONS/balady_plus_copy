import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:provider/provider.dart';

/// Basic wrapper for feedback pages
class FeedbackFormContainer extends ConsumerWidget {
  final Widget child;
  final String title;
  final VoidCallback? onSend;
  final VoidCallback? onBack;
  final bool isSendEnabled;
  final bool isSendVisible;

  const FeedbackFormContainer({
    required this.child,
    required this.title,
    this.onSend,
    this.isSendEnabled = false,
    this.isSendVisible = true,
    super.key,
    this.onBack,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => AnnotatedRegion<SystemUiOverlayStyle>(
    value: context.read<ThemeController>().systemOverlayStyle,
    child: Material(
      color: context.colors.backgroundSurface4,
      child: SafeArea(
        child: Scaffold(
          appBar: BaladyTopBar(
            title: title,
            onLeadingPressed: onBack ?? context.router.pop,
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
          body: Column(
            children: [
              Expanded(
                child: Padding(padding: const EdgeInsets.all(Spacing.$4x), child: child),
              ),
              if (isSendVisible)
                Padding(
                  padding: const EdgeInsets.all(Spacing.$4x),
                  child: SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      buttonState: isSendEnabled ? ButtonState.defaultState : ButtonState.disabled,
                      buttonColorScheme: ButtonColorScheme.accentSecondary,
                      size: ButtonSize.large,
                      onTap: isSendEnabled ? onSend : null,
                      primaryLabel: context.l10n.send,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}
