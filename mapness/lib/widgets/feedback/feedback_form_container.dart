import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

/// Basic wrapper for feedback pages
class FeedbackFormContainer extends StatelessWidget {
  final Widget child;
  final String title;
  final VoidCallback? onBack;
  final VoidCallback? onSend;
  final bool isSendEnabled;
  final bool isSendVisible;

  const FeedbackFormContainer({
    required this.child,
    required this.title,
    this.isSendEnabled = false,
    this.isSendVisible = true,
    super.key,
    this.onBack,
    this.onSend,
  });

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Material(
          color: context.colorsV2.backgroundSurface4,
          child: Scaffold(
            appBar: BaladyTopBar.iconAndText(
              title: title,
              leading: ActionModel(
                icon: context.isLTR
                    ? SystemIcons.arrowCornerLeftLarge
                    : SystemIcons.arrowCornerRightLarge,
                onPressed: onBack ?? context.pop,
              ),
              trailing: isSendVisible
                  ? ActionModel(
                      text: context.l10n.send,
                      isEnabled: isSendEnabled,
                      onPressed: isSendEnabled ? onSend : null,
                    )
                  : null,
              colorEnabled: context.colorsV2.accentDefault,
              colorDisabled: context.colorsV2.foregroundMuted,
            ),
            body: Padding(
              padding: const EdgeInsets.all(Spacing.$4x),
              child: child,
            ),
          ),
        ),
      );
}
