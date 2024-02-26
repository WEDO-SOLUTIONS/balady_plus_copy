import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/loading/loading_circular.dart';

class LoadingSmall extends StatelessWidget {
  final String? title;
  const LoadingSmall({super.key, this.title});

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        type: MaterialType.transparency,
        child: Row(
          children: [
            const LoadingCircular(
              size: 64,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title ?? context.l10n.loading,
                  style: context.textStyle.headingS.copyWith(
                      fontSize: 16,
                      color: context.color.text_and_icons_base_primary),
                ),
                Text(
                  context.l10n.loading_in_progress,
                  style: context.textStyle.textS.copyWith(
                      color: context.color.text_and_icons_base_primary),
                ),
              ],
            )
          ],
        ),
      );
}
