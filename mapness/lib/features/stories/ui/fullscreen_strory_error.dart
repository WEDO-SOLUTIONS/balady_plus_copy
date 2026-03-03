import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/entities/city_event/city_event.dart';
import 'package:mapness/features/city_event/active_city_event.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:provider/provider.dart';
import 'package:mapness/shared/providers/theme_controller.dart';

part 'fullscreen_story_content.dart';

class FullscreenStroryError extends StatelessWidget {
  final VoidCallback? onClose;
  final VoidCallback? onRetry;
  final String? buttonLabel;
  final String? errorLabel;
  final String? errorTitle;

  const FullscreenStroryError({
    super.key,
    this.onClose,
    this.onRetry,
    this.buttonLabel,
    this.errorLabel,
    this.errorTitle,
  });

  @override
  Widget build(BuildContext context) => Material(
    color: context.colorsV3.backgroundSurface4,
    child: SafeArea(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(child: ColoredBox(color: context.colorsV3.backgroundSurface4)),
            _FullscreenErrorContent(
              onClose: onClose,
              onRetry: onRetry,
              buttonLabel: buttonLabel,
              errorLabel: errorLabel,
              errorTitle: errorTitle,
            ),
          ],
        ),
      ),
    ),
  );
}
