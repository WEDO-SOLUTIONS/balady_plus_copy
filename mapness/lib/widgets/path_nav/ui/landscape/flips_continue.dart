import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';

class FlipsContinue extends StatelessWidget {
  const FlipsContinue({super.key});

  @override
  Widget build(BuildContext context) => Material(
    child: Container(
          color: context.colorsV3.backgroundSurface4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('packages/mapness/assets/images/ic_flips_continue.png'),
              Spacing.$4x.heightBox,
              Text(
                'The screen flips to continue',
                style: context.textStyleV3.h3SemiBold,
              )
            ],
          ),
        ),
  );
}
