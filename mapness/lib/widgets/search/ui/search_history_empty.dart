import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/search/models/search_scope.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:provider/provider.dart';

class SearchHistoryEmpty extends ConsumerWidget {
  const SearchHistoryEmpty({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scope = context.read<SearchScope>();
    final isDGADark = context.read<ThemeController>().currentTheme == BaladyAppThemes.darkDGA;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
      child: SizedBox(
        width: double.infinity,
        child: ContentWrapper.single(
          color: isDGADark?context.colors.neutralMuted : context.colors.backgroundSurface1,
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
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        ref.read(searchProvider(scope.value).notifier).searchByText(context.l10n.mallNearby);
                      },
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
}
