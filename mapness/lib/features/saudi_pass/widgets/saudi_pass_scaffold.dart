import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
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
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: context.colors.backgroundSurface4,
    appBar: BaladyTopBar(
      systemUiOverlayStyle: context.read<ThemeController>().systemOverlayStyle,
      title: title,
      textStyle: context.textStyles.bodyLargeSemiBold.copyWith(color: context.colors.foregroundDefault),
      onLeadingPressed: onBackButton,
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
      trailing: onShowOnMapPressed != null
          ? SizedBox(
              width: 112,
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: IconButton(
                  tooltip: context.l10n.a11yShowOnMap,
                  onPressed: onShowOnMapPressed,
                  icon: Icon(GeneralIcons.map, color: context.colors.foregroundDefault),
                ),
              ),
            )
          : null,
    ),
    body: body,
  );
}
