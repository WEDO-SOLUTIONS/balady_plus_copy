import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class SearchHistoryEmpty extends ConsumerWidget {
  const SearchHistoryEmpty({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
    child: SizedBox(
      width: double.infinity,
      child: ContentWrapper.single(
        color: context.colors.backgroundSurface1,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x, vertical: Spacing.$4x),
          child: Text.rich(
            TextSpan(
              text: context.l10n.lookForUsefulPlacesCafesMallsForExampleMallNearby,
              style: context.textStyles.bodyLargeRegular.copyWith(color: context.colors.foregroundDefault),
              children: [
                TextSpan(
                  text: context.l10n.mallNearby,
                  style: context.textStyles.bodyLargeMedium.copyWith(color: context.colors.accentDefault),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  );
}
