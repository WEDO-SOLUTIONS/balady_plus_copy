import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class FlipsContinue extends StatelessWidget {
  const FlipsContinue({super.key});

  @override
  Widget build(BuildContext context) => Material(
      child: ColoredBox(
        color: context.colorsV3.backgroundSurface4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Assets.images.icFlipsContinue.keyName),
            Spacing.$4x.heightBox,
            Text(
              context.l10n.theScreenFlipsContinue,
              style: context.textStyleV3.h3SemiBold,
            )
          ],
        ),
      ),
    );
}
