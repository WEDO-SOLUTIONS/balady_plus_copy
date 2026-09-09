import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

/// Renders whichever active/revoked variant applies once activation has
/// completed at least once (R-06 foreground-only warning, R-07 revoked
/// state). Exactly one of [backgroundActive] paths or [revoked] applies.
class FriendsOnMapStatusView extends StatelessWidget {
  final bool backgroundActive;
  final bool revoked;

  const FriendsOnMapStatusView({this.backgroundActive = false, this.revoked = false, super.key});

  @override
  Widget build(BuildContext context) {
    final String title;
    final String body;
    final Color bodyColor;
    if (revoked) {
      title = context.l10n.friendsOnMapRevokedTitle;
      body = context.l10n.friendsOnMapRevokedBody;
      bodyColor = context.colors.errorDefault;
    } else if (backgroundActive) {
      title = context.l10n.friendsOnMapTitle;
      body = context.l10n.friendsOnMapActiveWithBackgroundBody;
      bodyColor = context.colors.foregroundMuted;
    } else {
      title = context.l10n.friendsOnMapTitle;
      body = context.l10n.friendsOnMapActiveForegroundOnlyBody;
      bodyColor = context.colors.foregroundMuted;
    }

    return Padding(
      padding: const EdgeInsets.all(Spacing.$4x),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: context.textStyles.h3SemiBold.copyWith(color: context.colors.foregroundDefault),
          ),
          const SizedBox(height: Spacing.$2x),
          Text(
            body,
            textAlign: TextAlign.center,
            style: context.textStyles.bodyLargeRegular.copyWith(color: bodyColor),
          ),
          if (!revoked && !backgroundActive) ...[
            const SizedBox(height: Spacing.$1_5x),
            Text(
              context.l10n.friendsOnMapForegroundOnlyWarning,
              textAlign: TextAlign.center,
              style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundMuted),
            ),
          ],
        ],
      ),
    );
  }
}
