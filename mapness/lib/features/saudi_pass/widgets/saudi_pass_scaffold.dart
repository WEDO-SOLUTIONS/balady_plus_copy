import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SaudiPassScaffold extends StatelessWidget {
  final VoidCallback onBackButton;
  final String title;
  final Widget body;
  final VoidCallback? onShowOnMapPressed;

  const SaudiPassScaffold({
    required this.onBackButton,
    required this.body,
    required this.title,
    this.onShowOnMapPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: Spacing.$4x),
    child: Scaffold(
      backgroundColor: context.colors.backgroundSurface4,
      appBar: BaladyTopBar.iconAndText(
        systemUiOverlayStyle: context.read<ThemeController>().systemOverlayStyle,
        title: title,
        textStyle: context.textStyles.bodyLargeSemiBold.copyWith(color: context.colors.foregroundDefault),
        colorEnabled: context.colors.foregroundDefault,
        leading: ActionModel(onPressed: onBackButton, icon: SystemIcons.arrowCornerLeftLarge),
        trailing: onShowOnMapPressed != null
            ? ActionModel(onPressed: onShowOnMapPressed, icon: GeneralIcons.map)
            : null,
      ),
      body: body,
    ),
  );
}
