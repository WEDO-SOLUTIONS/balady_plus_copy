import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/shared/utils/insets_utils.dart';

class PathNavWrapper extends ConsumerWidget {
  final Widget child;
  final Widget? indoorControl;
  final bool isPortrait;
  const PathNavWrapper({
    required this.child,
    required this.isPortrait,
    this.indoorControl,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isPortrait) {
      return Directionality(
        textDirection: ref.watch(uiDirectionProvider),
        child: child,
      );
    }
    return Positioned.fill(
      child: Align(
        alignment: AlignmentDirectional.bottomStart,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(
                bottom: InsetsUtils.platformAwareBottomInset(context, isLandscape: true) + Spacing.$3x,
              ),
              child: child,
            ),

            if (indoorControl != null) indoorControl!,
          ],
        ),
      ),
    );
  }
}
