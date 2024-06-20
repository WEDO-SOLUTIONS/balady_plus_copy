import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/loading/loading_circular.dart';

class InlineLoadingIndicator extends StatelessWidget {
  const InlineLoadingIndicator({super.key, this.title});
  final String? title;

  static const _defaultSize = 64.0;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        type: MaterialType.transparency,
        child: Row(
          children: [
            const LoadingCircular(
              size: _defaultSize,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title ?? context.l10n.loading,
                  style: context.textStyle.heading1.copyWith(
                    fontSize: 16,
                    color: context.color.textAndIconsBasePrimary,
                  ),
                ),
                Text(
                  context.l10n.loading_in_progress,
                  style: context.textStyle.footNote.copyWith(
                    color: context.color.textAndIconsBasePrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}
