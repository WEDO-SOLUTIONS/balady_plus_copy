import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class FeedbackAddressEmpty extends ConsumerWidget {
  final bool isInitial;
  const FeedbackAddressEmpty({
    required this.isInitial,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => SliverFillRemaining(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
          child: !isInitial
              ? Text(
                  context.l10n.searchCouldNotFindAnything,
                  style: context.textStyleV3.bodyLargeSemiBold,
                  textAlign: TextAlign.center,
                )
              : null,
        ),
      );
}
