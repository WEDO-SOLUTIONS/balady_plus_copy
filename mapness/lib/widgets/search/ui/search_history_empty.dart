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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: Spacing.$12x),
            Text(
              context.l10n.lookForPlaces,
              style: context.textStyleV3.h4SemiBold,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Spacing.$3x),
            Text(
              context.l10n.likeShoppingMalls,
              textAlign: TextAlign.center,
              style: context.textStyleV3.bodySmallRegular,
            ),
          ],
        ),
      );
}
