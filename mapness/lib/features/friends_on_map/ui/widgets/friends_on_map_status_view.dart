import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/friends_on_map/providers/active_shares_controller.dart';
import 'package:mapness/features/friends_on_map/providers/friends_on_map_activation.dart';
import 'package:mapness/features/friends_on_map/providers/friends_on_map_layer_visible.dart';
import 'package:mapness/features/friends_on_map/providers/friends_on_map_paused.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/active_shares_sheet.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/share_duration_sheet.dart';
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

    if (revoked) {
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
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(Spacing.$4x),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ContentWrapper(
            color: context.colors.backgroundSurface1,
            children: [
              // Temporary entry point ahead of BR-05's "friend list is the
              // single hub" restructuring — see friends_on_map/AGENTS.md.
              ContentRow(
                onTap: () => context.router.push(const FriendListRoute()),
                leading: Icon(GeneralIcons.user, color: context.colors.accentDefault, size: 24),
                text: ContentRowTextOptions(title: context.l10n.friendsOnMapFriendsCta),
                trailing: ContentRowTextTrailingOptions(
                  icon: SystemIcons.arrowCornerRightLarge,
                  iconColor: context.colors.foregroundMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.$3x),
          Text(
            body,
            style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
          ),
          const SizedBox(height: Spacing.$3x),
          Text(
            context.l10n.sharing,
            style: context.textStyles.h4SemiBold.copyWith(color: context.colors.foregroundDefault),
          ),
          const SizedBox(height: Spacing.$3x),
          ContentWrapper(
            color: context.colors.backgroundSurface1,
            children: [
              ContentRow(
                isDividerEnabled: true,
                text: ContentRowTextOptions(title: context.l10n.friendsOnMapPauseToggleLabel),
                trailing: ContentRowToggleTrailingOptions(
                  value: ref.watch(friendsOnMapPausedProvider),
                  onChanged: (value) => ref.read(friendsOnMapPausedProvider.notifier).setPaused(paused: value),
                ),
              ),
              // R-97/R-98 (D-13 fallback): display-only — doesn't touch
              // reporting, visibility rules, links, or notifications.
              ContentRow(
                isDividerEnabled: true,
                text: ContentRowTextOptions(title: context.l10n.friendsOnMapLayerToggleLabel),
                trailing: ContentRowToggleTrailingOptions(
                  value: ref.watch(friendsOnMapLayerVisibleProvider),
                  onChanged: (value) => ref.read(friendsOnMapLayerVisibleProvider.notifier).setVisible(visible: value),
                ),
              ),
              // S-19 (R-78/R-80): temporary placement alongside the toggles
              // above — same "no real hub yet" convention as every other
              // row in this file (see the BR-05 tension note in
              // friends_on_map/AGENTS.md).
              ContentRow(
                isDividerEnabled: true,
                onTap: () => showModalBottomSheet<void>(
                  backgroundColor: Colors.transparent,
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => const ShareDurationSheet(),
                ),
                text: ContentRowTextOptions(title: context.l10n.friendsOnMapShareLocationCta),
                trailing: ContentRowTextTrailingOptions(
                  icon: SystemIcons.arrowCornerRightLarge,
                  iconColor: context.colors.foregroundMuted,
                ),
              ),
              ContentRow(
                onTap: () => showModalBottomSheet<void>(
                  backgroundColor: Colors.transparent,
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => const ActiveSharesSheet(),
                ),
                text: ContentRowTextOptions(
                  title: context.l10n.friendsOnMapMyActiveSharesCta(
                    ref.watch(activeSharesControllerProvider).value?.length ?? 0,
                  ),
                ),
                trailing: ContentRowTextTrailingOptions(
                  icon: SystemIcons.arrowCornerRightLarge,
                  iconColor: context.colors.foregroundMuted,
                ),
              ),
            ],
          ),
          if (!backgroundActive) ...[
            const SizedBox(height: Spacing.$1_5x),
            Text(
              context.l10n.friendsOnMapForegroundOnlyWarning,
              style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundMuted),
            ),
          ],
          const SizedBox(height: Spacing.$5x),
          AppButton(
            buttonColorScheme: ButtonColorScheme.accent,
            buttonType: ButtonType.secondary,
            size: ButtonSize.large,
            borderRadius: RadiusBorder.xs,
            primaryLabel: context.l10n.friendsOnMapDeactivateCta,
            onTap: () => ref.read(friendsOnMapActivationProvider.notifier).deactivate(),
          ),
        ],
      ),
    );
  }
}
