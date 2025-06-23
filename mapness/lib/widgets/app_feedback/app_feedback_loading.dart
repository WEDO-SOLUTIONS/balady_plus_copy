import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/ui/loading/fullscreen_loading_indicator.dart';

class AppFeedbackLoading extends StatelessWidget {
  const AppFeedbackLoading({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 89.0, bottom: 111.0),
        child: FullscreenLoadingIndicator(
          isDisplayTitle: false,
          color: context.colors.accentDefault,
        ),
      );
}
