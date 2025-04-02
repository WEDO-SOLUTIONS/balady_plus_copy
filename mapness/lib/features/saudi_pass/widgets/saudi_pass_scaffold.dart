import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SaudiPassScaffold extends StatelessWidget {
  final VoidCallback onBackButton;
  final String title;
  final Widget body;

  const SaudiPassScaffold({
    required this.onBackButton,
    required this.body,
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: Spacing.$4x),
        child: Scaffold(
          backgroundColor: context.colorsV2.backgroundSurface4,
          appBar: BaladyTopBar.iconAndText(
            systemUiOverlayStyle: SystemUiOverlayStyle.dark,
            title: title,
            textStyle: context.textStyleV3.bodyLargeSemiBold.copyWith(color: context.colorsV3.foregroundDefault),
            colorEnabled: context.colorsV2.foregroundDefault,
            leading: ActionModel(
              onPressed: onBackButton,
              icon: SystemIcons.arrowCornerLeftLarge,
            ),
          ),
          body: body,
        ),
      );
}
