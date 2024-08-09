import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

// TODO: This is template
class FeedbackCompanyNamePage extends StatelessWidget {
  final String initialCompanyName;

  const FeedbackCompanyNamePage({
    required this.initialCompanyName,
    super.key,
  });

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Material(
          color: context.colorsV2.backgroundSurface4,
          child: Scaffold(
            appBar: BaladyTopBar.iconAndText(
              title: context.l10n.feedbackCompanyName,
              leading: ActionModel(
                icon: SystemIcons.arrowCornerLeftLarge,
                onPressed: () {
                  context.pop();
                },
              ),
            ),
            body: const Placeholder(),
          ),
        ),
      );
}
