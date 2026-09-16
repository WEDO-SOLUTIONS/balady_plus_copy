import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

/// AC-12: shown when the user owns and belongs to no shared list — an
/// explanatory empty state with a create action, mirroring
/// `friend_list_empty_state.dart`'s shape.
class SharedListsEmptyState extends StatelessWidget {
  final VoidCallback onCreate;

  const SharedListsEmptyState({required this.onCreate, super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(Spacing.$4x),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.l10n.sharedListsEmptyTitle,
          textAlign: TextAlign.center,
          style: context.textStyles.h4SemiBold.copyWith(color: context.colors.foregroundDefault),
        ),
        const SizedBox(height: Spacing.$2x),
        Text(
          context.l10n.sharedListsEmptyBody,
          textAlign: TextAlign.center,
          style: context.textStyles.bodyLargeRegular.copyWith(color: context.colors.foregroundMuted),
        ),
        const SizedBox(height: Spacing.$4x),
        AppButton(
          buttonColorScheme: ButtonColorScheme.accentSecondary,
          size: ButtonSize.large,
          primaryLabel: context.l10n.sharedListsEmptyCreateCta,
          onTap: onCreate,
        ),
      ],
    ),
  );
}
