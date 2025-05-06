import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class NaviSearchEmpty extends StatelessWidget {
  const NaviSearchEmpty({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: Spacing.$12x),
            Text(
              context.l10n.searchCouldNotFindAnything,
              style: context.textStyleV3.bodyLargeSemiBold,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Spacing.$3x),
            Text(
              context.l10n.searchTryToSearchForADifferentLocation,
              textAlign: TextAlign.center,
              style: context.textStyleV3.bodySmallRegular,
            ),
          ],
        ),
      );
}
