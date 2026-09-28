import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/friends_on_map/data/friends_on_map_api_exception.dart';
import 'package:mapness/features/friends_on_map/friends_on_map_retry_after.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

/// Runs [action] and, on a [FriendsOnMapApiException], shows
/// [showFriendsOnMapLimitDialog] instead of letting the error propagate as
/// an unhandled async error — the failure mode every mutation call site in
/// this feature had before this file existed (a bare `VoidCallback`
/// discarding the returned `Future`).
///
/// [onSuccess], if given, only runs when [action] completes without
/// throwing a [FriendsOnMapApiException].
Future<void> runFriendsOnMapAction(
  BuildContext context,
  Future<void> Function() action, {
  VoidCallback? onSuccess,
}) async {
  try {
    await action();
    onSuccess?.call();
  } on FriendsOnMapApiException catch (e) {
    if (context.mounted) {
      await showFriendsOnMapLimitDialog(context, e);
    }
  }
}

/// Same `AlertDialog` shell as `providers/invite_resolution_flow.dart`'s
/// `_showResultDialog` — see that file's comment for why style/l10n values
/// are captured from [context] before the dialog builds, and why
/// `useRootNavigator: false` is required in this app's nested-Localizations
/// setup.
Future<void> showFriendsOnMapLimitDialog(BuildContext context, FriendsOnMapApiException e) {
  final l10n = context.l10n;
  final (title, body) = switch (e.limitCode) {
    FriendsOnMapLimitCode.friendLimitReached =>
      e.subject == FriendsOnMapLimitSubject.peer
          ? (l10n.friendsOnMapLimitFriendCountPeerTitle, l10n.friendsOnMapLimitFriendCountPeerBody)
          : (l10n.friendsOnMapLimitFriendCountSelfTitle, l10n.friendsOnMapLimitFriendCountSelfBody(e.limit ?? 0)),
    FriendsOnMapLimitCode.pendingRequestLimitReached => (
      l10n.friendsOnMapLimitPendingRequestsTitle,
      l10n.friendsOnMapLimitPendingRequestsBody(e.limit ?? 0),
    ),
    FriendsOnMapLimitCode.requestCreationLimitReached => (
      l10n.friendsOnMapLimitRequestCreationTitle,
      l10n.friendsOnMapLimitRequestCreationBody(e.limit ?? 0, _retryLabel(l10n, e)),
    ),
    FriendsOnMapLimitCode.inviteResetLimitReached => (
      l10n.friendsOnMapLimitInviteResetTitle,
      l10n.friendsOnMapLimitInviteResetBody(e.limit ?? 0, _retryLabel(l10n, e)),
    ),
    FriendsOnMapLimitCode.inviteResolutionRateLimited => (
      l10n.friendsOnMapLimitInviteResolutionTitle,
      l10n.friendsOnMapLimitInviteResolutionBody(_retryLabel(l10n, e)),
    ),
    FriendsOnMapLimitCode.listLimitReached => (
      l10n.friendsOnMapLimitListCountTitle,
      l10n.friendsOnMapLimitListCountBody(e.limit ?? 0),
    ),
    FriendsOnMapLimitCode.listMemberLimitReached => (
      l10n.friendsOnMapLimitListMemberCountTitle,
      l10n.friendsOnMapLimitListMemberCountBody(e.limit ?? 0),
    ),
    FriendsOnMapLimitCode.listItemLimitReached => (
      l10n.friendsOnMapLimitListItemCountTitle,
      l10n.friendsOnMapLimitListItemCountBody(e.limit ?? 0),
    ),
    FriendsOnMapLimitCode.shareLimitReached => (
      l10n.friendsOnMapLimitShareCountTitle,
      l10n.friendsOnMapLimitShareCountBody(e.limit ?? 0),
    ),
    // Not a recognized Appendix-B limit (network error, unrelated 4xx/5xx) —
    // this feature's dialogs never show raw backend text (server-side
    // English debug strings), so fall back to the app-wide generic copy
    // already used by `shared/ui/error_widget/fullscreen_error_widget.dart`.
    null => (l10n.somethingWentWrong, l10n.pleaseTryAgainLater),
  };

  final titleStyle = context.textStyles.h4SemiBold;
  final bodyStyle = context.textStyles.bodyLargeRegular;
  final doneLabel = l10n.done;

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

String _retryLabel(AppLocalizations l10n, FriendsOnMapApiException e) =>
    e.retryAfter == null ? '' : friendsOnMapRetryAfterLabel(l10n, e.retryAfter!);
