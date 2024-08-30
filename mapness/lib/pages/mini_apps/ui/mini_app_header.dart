// ignore_for_file: prefer_expression_function_bodies

import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/icons/system_icons.dart';
import 'package:balady_uikit/core/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MiniAppHeader extends ConsumerWidget {
  const MiniAppHeader({
    required this.title,
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ColoredBox(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 8,
        ),
        child: Row(
          children: [
            SizedBox(
              height: 40,
              width: 40,
              child: Material(
                borderRadius: BorderRadius.circular(8),
                color: context.color.surfaceBaseSecondary,
                child: InkWell(
                  onTap: () {
                    context.pop();
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      SystemIcons.arrowCornerLeftLarge,
                      size: 24,
                      color: context.color.textAndIconsBasePrimary,
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            Text(
              title,
              style: Theme.of(context)
                  .extension<ThemeTextStyles>()!
                  .heading2
                  .copyWith(color: context.color.textAndIconsBasePrimary),
            ),
            const Spacer(),
            const SizedBox(
              width: 40,
            ),
          ],
        ),
      ),
    );
  }
}
