import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/friends_on_map/models/invite_resolution.dart';
import 'package:mapness/features/friends_on_map/providers/blocked_users.dart';
import 'package:mapness/features/friends_on_map/providers/friend_request_repository.dart';
import 'package:mapness/features/friends_on_map/providers/friends_on_map_invite_link.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/deeplink_functions.dart';

/// R-29/R-33-35: the single resolution path for a scanned or opened invite
/// — used by both `ui/widgets/scan_qr_view.dart` (has a real [BuildContext])
/// and `entry_point.dart`'s deep-link handler (uses
/// `rootNavigatorKey.currentContext`). [rawValue] is whatever a QR decode or
/// a tapped link hands over — a full URL, not a bare token; parsed here so
/// there is exactly one place that decides what counts as a valid Balady
/// invite link.
Future<void> resolveInviteAndShowResult(BuildContext context, WidgetRef ref, String rawValue) async {
  final token = _extractInviteToken(rawValue);
  if (token == null) {
    if (context.mounted) {
      await _showResultDialog(context, InviteResolution.invalidOrBlocked);
    }
    return;
  }

  // R-44/BR-02 of S-12: a blocked identity's invite must resolve exactly
  // like an unknown token — checked here (not inside the repository) for
  // the same reason `ownToken` is fetched externally, per
  // features/friends_on_map/AGENTS.md's story-boundary note: keeps
  // FakeFriendRequestRepository dependency-free.
  final blockedUsers = await ref.read(blockedUsersProvider.future);
  if (blockedUsers.any((u) => u.id == token)) {
    if (context.mounted) {
      await _showResultDialog(context, InviteResolution.invalidOrBlocked);
    }
    return;
  }

  final ownToken = _extractInviteToken(await ref.read(friendsOnMapInviteLinkProvider.future));
  final resolution = await ref
      .read(friendRequestRepositoryProvider)
      .resolveInvite(token: token, ownToken: ownToken ?? '');

  if (!context.mounted) {
    return;
  }
  await _showResultDialog(context, resolution);
}

String? _extractInviteToken(String rawValue) {
  final uri = Uri.tryParse(rawValue);
  if (uri == null || uri.host != BaldayDeeplink.baseAuthority) {
    return null;
  }
  if (uri.pathSegments.length != 2 || uri.pathSegments.first != 'invite') {
    return null;
  }
  return uri.pathSegments.last;
}

Future<void> _showResultDialog(BuildContext context, InviteResolution resolution) {
  final (title, body) = switch (resolution) {
    InviteResolution.success => (context.l10n.addFriendRequestSentTitle, context.l10n.addFriendRequestSentBody),
    InviteResolution.selfRequest => (context.l10n.addFriendSelfRequestTitle, context.l10n.addFriendSelfRequestBody),
    InviteResolution.invalidOrBlocked => (
      context.l10n.addFriendInvalidCodeTitle,
      context.l10n.addFriendInvalidCodeBody,
    ),
  };
  // Captured from the outer context, not re-derived inside the builder: this
  // app nests a mapness-local Localizations/theme scope inside a host
  // MaterialApp, and showDialog's default useRootNavigator: true attaches
  // the dialog route above that inner scope — a dialogContext built there
  // has no AppLocalizations ancestor and AppLocalizations.of throws a null
  // check. useRootNavigator: false below keeps the dialog on the nearest
  // (correctly-scoped) Navigator instead; capturing these values here is
  // the belt-and-suspenders half of the fix.
  final titleStyle = context.textStyles.h4SemiBold;
  final bodyStyle = context.textStyles.bodyLargeRegular;
  final doneLabel = context.l10n.done;

  return showDialog<void>(
    context: context,
    useRootNavigator: false,
    builder: (dialogContext) => AlertDialog(
      title: Text(title, style: titleStyle),
      content: Text(body, style: bodyStyle),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: Text(doneLabel),
        ),
      ],
    ),
  );
}
