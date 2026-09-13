import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/features/friends_on_map/models/blocked_user.dart';
import 'package:mapness/features/friends_on_map/providers/blocked_users.dart';
import 'package:mapness/features/friends_on_map/providers/blocked_users_controller.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/friend_avatar.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/friend_confirm_sheet.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

/// R-45: lists blocked users, each with an unblock action.
@RoutePage()
class BlockedUsersPage extends ConsumerWidget {
  const BlockedUsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blockedUsersAsync = ref.watch(blockedUsersProvider);

    return Directionality(
      textDirection: ref.watch(uiDirectionProvider),
      child: Material(
        color: context.colors.backgroundSurface4,
        child: Scaffold(
          appBar: BaladyTopBar.iconAndText(
            title: context.l10n.blockedUsersTitle,
            colorEnabled: context.colors.accentDefault,
            leading: ActionModel(onPressed: () => context.router.pop(), icon: SystemIcons.arrowCornerLeftLarge),
          ),
          body: SafeArea(
            child: blockedUsersAsync.when(
              data: (blockedUsers) => blockedUsers.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(Spacing.$4x),
                        child: Text(
                          context.l10n.blockedUsersEmptyBody,
                          textAlign: TextAlign.center,
                          style: context.textStyles.bodyLargeRegular.copyWith(color: context.colors.foregroundMuted),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: blockedUsers.length,
                      itemBuilder: (context, index) => _BlockedUserItem(user: blockedUsers[index]),
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }
}

class _BlockedUserItem extends ConsumerWidget {
  final BlockedUser user;

  const _BlockedUserItem({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
    padding: const EdgeInsets.symmetric(vertical: Spacing.$2x, horizontal: Spacing.$4x),
    child: Row(
      children: [
        FriendAvatar(displayName: user.displayName, profilePictureUrl: user.profilePictureUrl),
        const SizedBox(width: Spacing.$3x),
        Expanded(
          child: Text(
            user.displayName,
            overflow: TextOverflow.ellipsis,
            style: context.textStyles.bodyLargeMedium.copyWith(color: context.colors.foregroundDefault),
          ),
        ),
        const SizedBox(width: Spacing.$2x),
        AppButton(
          buttonColorScheme: ButtonColorScheme.accentSecondary,
          buttonType: ButtonType.secondary,
          size: ButtonSize.small,
          primaryLabel: context.l10n.blockedUsersUnblockCta,
          onTap: () => showFriendConfirmSheet(
            context,
            title: context.l10n.blockedUsersUnblockConfirmTitle,
            body: context.l10n.blockedUsersUnblockConfirmBody(user.displayName),
            confirmLabel: context.l10n.blockedUsersUnblockCta,
            // Reads via a container from the root navigator's context
            // rather than this row's own `ref` — see the fix note in
            // friend_card_sheet.dart for the bug this avoids.
            onConfirm: () => ProviderScope.containerOf(
              rootNavigatorKey.currentContext!,
              listen: false,
            ).read(blockedUsersControllerProvider.notifier).unblock(user.id),
          ),
        ),
      ],
    ),
  );
}
