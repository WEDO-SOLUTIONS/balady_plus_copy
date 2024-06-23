import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class SearchHistoryEmpty extends ConsumerWidget {
  const SearchHistoryEmpty({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 38,
            vertical: 20,
          ),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: context.l10n.lookForUsefulPlacesCafesMallsForExampleMallNearby,
                  style: Theme.of(context)
                      .extension<ThemeTextStyles>()!
                      .heading2
                      .copyWith(color: context.color.textAndIconsBasePrimary),
                ),
              ],
            ),
          ),
        ),
      );
}
