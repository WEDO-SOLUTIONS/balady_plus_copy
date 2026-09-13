import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/share_eta/ui/eta_share_control_sheet/eta_share_sheet.dart';

/// Shared confirm-before-destructive-action sheet, reused for remove friend
/// (R-43), block (R-44, from both the friend card and an incoming request),
/// and unblock (R-45) — the first confirm dialog this app has, built fresh
/// since no reusable one existed anywhere (see
/// `features/friends_on_map/AGENTS.md`). Built on the same [EtaShareSheet]
/// shell already reused for the friend card, rather than a new container.
void showFriendConfirmSheet(
  BuildContext context, {
  required String title,
  required String body,
  required String confirmLabel,
  required VoidCallback onConfirm,
}) {
  showModalBottomSheet<void>(
    backgroundColor: Colors.transparent,
    context: context,
    isScrollControlled: true,
    builder: (context) => EtaShareSheet(
      title: title,
      confirmBtnTitle: confirmLabel,
      onConfirmTap: () {
        Navigator.of(context).pop();
        onConfirm();
      },
      contentBuilder: (context) => [
        Text(body, style: context.textStyles.bodyLargeRegular.copyWith(color: context.colors.foregroundMuted)),
      ],
    ),
  );
}
