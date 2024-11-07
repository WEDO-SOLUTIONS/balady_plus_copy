import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class SearchHistoryEmpty extends ConsumerWidget {
  const SearchHistoryEmpty({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Spacing.$4x,
          horizontal: Spacing.$6x,
        ),
        child: Text(
          context.l10n.lookForUsefulPlacesCafesMallsForExampleMallNearby,
          style: context.textStyleV3.h4Medium,
          textAlign: TextAlign.center,
        ),
      );
}
