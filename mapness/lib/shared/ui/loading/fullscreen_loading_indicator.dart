import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

import 'package:mapness/shared/ui/loading/loading_circular.dart';

class FullscreenLoadingIndicator extends StatelessWidget {
  const FullscreenLoadingIndicator({super.key, this.title});
  final String? title;

  static const _defaultSize = 99.0;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        type: MaterialType.transparency,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const LoadingCircular(
              size: _defaultSize,
            ),
            const SizedBox(height: 32),
            Text(
              title ?? context.l10n.loading,
              style: context.textStyle.headingS
                  .copyWith(color: context.color.text_and_icons_base_primary),
            ),
            const SizedBox(height: 12),
            Text(
              context.l10n.loading_in_progress,
              style: context.textStyle.textM
                  .copyWith(color: context.color.text_and_icons_base_primary),
            ),
          ],
        ),
      );
}
