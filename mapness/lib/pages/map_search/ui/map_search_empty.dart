import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class MapSearchEmpty extends StatelessWidget {
  const MapSearchEmpty({super.key});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          NumericBase.$12x.heightBox,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: NumericBase.$10x),
            child: Text(
              context.l10n.weCouldntFindAnythingTryToSearchForDifferentLocation,
              textAlign: TextAlign.center,
              style: context.textStyle.text.copyWith(color: context.color.textAndIconsBasePrimary),
            ),
          ),
        ],
      );
}
