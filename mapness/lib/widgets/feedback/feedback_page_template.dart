import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

/// Basic wrapper for feedback pages
class FeedbackPageTemplate extends StatelessWidget {
  final Widget child;
  final String title;
  final VoidCallback? onBack;
  const FeedbackPageTemplate({
    required this.child,
    required this.title,
    super.key,
    this.onBack,
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
                icon: context.isLTR ? SystemIcons.arrowCornerLeftLarge : SystemIcons.arrowCornerRightLarge,
                onPressed: onBack ?? context.pop,
              ),
            ),
            body: child,
          ),
        ),
      );
}
