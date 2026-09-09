import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/friends_on_map/providers/friends_on_map_activation.dart';
import 'package:mapness/features/friends_on_map/providers/friends_on_map_paused.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

/// Renders whichever active/revoked variant applies once activation has
/// completed at least once (R-06 foreground-only warning, R-07 revoked
/// state). Exactly one of [backgroundActive] paths or [revoked] applies.
///
/// Also carries the R-23/R-24 pause toggle and the S-06 deactivate action —
/// a deliberate, temporary placement ahead of the real privacy screen
/// (R-95), which depends on the friend list hub from a later slice. Moving
/// these onto that screen later is a pure relocation, not a rework.
class FriendsOnMapStatusView extends ConsumerWidget {
  final bool backgroundActive;
  final bool revoked;

  const FriendsOnMapStatusView({this.backgroundActive = false, this.revoked = false, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          if (!revoked) ...[
            const SizedBox(height: Spacing.$4x),
            ContentWrapper(
              color: context.colors.backgroundSurface1,
              children: [
                ContentRow(
                  text: ContentRowTextOptions(title: context.l10n.friendsOnMapPauseToggleLabel),
                  trailing: ContentRowToggleTrailingOptions(
                    value: ref.watch(friendsOnMapPausedProvider),
                    onChanged: (value) => ref.read(friendsOnMapPausedProvider.notifier).setPaused(paused: value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.$3x),
            AppButton(
              buttonColorScheme: ButtonColorScheme.accentSecondary,
              buttonType: ButtonType.secondary,
              size: ButtonSize.large,
              primaryLabel: context.l10n.friendsOnMapDeactivateCta,
              onTap: () => ref.read(friendsOnMapActivationProvider.notifier).deactivate(),
            ),
          ],
        ],
      ),
    );
  }
}
