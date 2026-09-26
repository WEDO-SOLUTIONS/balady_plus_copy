import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/features/friends_on_map/models/friend.dart';
import 'package:mapness/features/friends_on_map/providers/meetups_controller.dart';
import 'package:mapness/features/friends_on_map/ui/friends_on_map_error_dialog.dart';
import 'package:mapness/features/share_eta/ui/eta_share_control_sheet/eta_share_sheet.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';

/// S-17's final "send?" step. Same `ProviderScope.containerOf`-in-onConfirm
/// pattern as `friend_confirm_sheet.dart` — never closes over a `WidgetRef`
/// captured before the confirm tap, since the sheet showing this one may
/// already be gone by the time the user actually taps send.
void showMeetupSendConfirmSheet(
  BuildContext context, {
  required List<Friend> recipients,
  required double latitude,
  required double longitude,
  String? label,
}) {
  final l10n = context.l10n;
  final recipientsSummary = recipients.length == 1
      ? recipients.first.displayName
      : l10n.meetupSendConfirmRecipientsCount(recipients.length);
  final recipientIds = recipients.map((f) => f.id).toList();

  showModalBottomSheet<void>(
    backgroundColor: Colors.transparent,
    context: context,
    isScrollControlled: true,
    builder: (context) => EtaShareSheet(
      title: l10n.meetupSendConfirmTitle,
      confirmBtnTitle: l10n.meetupSendCta,
      onConfirmTap: () {
        Navigator.of(context).pop();
        runFriendsOnMapAction(
          rootNavigatorKey.currentContext!,
          () => ProviderScope.containerOf(rootNavigatorKey.currentContext!, listen: false)
              .read(meetupsControllerProvider.notifier)
              .create(recipientIds: recipientIds, latitude: latitude, longitude: longitude, label: label),
          onSuccess: () => ToastOverlay.of(rootNavigatorKey.currentContext!).show(
            title: l10n.meetupSentToast(recipientIds.length),
            icon: const ToastIconData(GeneralIcons.checkmarkCircle),
          ),
        );
      },
      contentBuilder: (context) => [
        Text(
          l10n.meetupSendConfirmBody(recipientsSummary),
          style: context.textStyles.bodyLargeRegular.copyWith(color: context.colors.foregroundMuted),
        ),
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(top: Spacing.$2x),
            child: Text(
              label,
              style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundMuted),
            ),
          ),
      ],
    ),
  );
}
