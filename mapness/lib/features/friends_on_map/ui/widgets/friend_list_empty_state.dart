import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

/// R-46.
class FriendListEmptyState extends StatelessWidget {
  const FriendListEmptyState({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(Spacing.$4x),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.l10n.friendListEmptyTitle,
          textAlign: TextAlign.center,
          style: context.textStyles.h4SemiBold.copyWith(color: context.colors.foregroundDefault),
        ),
        const SizedBox(height: Spacing.$2x),
        Text(
          context.l10n.friendListEmptyBody,
          textAlign: TextAlign.center,
          style: context.textStyles.bodyLargeRegular.copyWith(color: context.colors.foregroundMuted),
        ),
        const SizedBox(height: Spacing.$4x),
        AppButton(
          buttonColorScheme: ButtonColorScheme.accentSecondary,
          size: ButtonSize.large,
          innerPadding: const EdgeInsets.symmetric(horizontal: Spacing.$16x),
          primaryLabel: context.l10n.friendListEmptyAddCta,
          onTap: () => context.router.push(const AddFriendRoute()),
        ),
      ],
    ),
  );
}
