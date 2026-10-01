import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/friends_on_map/providers/friends_on_map_account_id.dart';
import 'package:mapness/features/friends_on_map/providers/friends_on_map_invite_link.dart';
import 'package:mapness/features/friends_on_map/ui/friends_on_map_error_dialog.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/friend_marker_avatar.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// R-26: own picture + QR encoding the invite link, on a card. R-27 (reset) and R-28 (share) live here as the card's actions.
class InviteCard extends ConsumerWidget {
  const InviteCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final linkAsync = ref.watch(friendsOnMapInviteLinkProvider);
    // Same themed-illustration avatar friends see for each other (not a real
    // photo) — this card is reachable before login, when there's no real
    // profile photo/name to show at all. Keyed by this device's *account id*
    // on the Friends on Map backend — the exact id a friend's device
    // receives as `Friend.id` for this account — not the raw device UUID
    // (`uuidProviderProvider`), which is a different string (see
    // `friends_on_map_account_id.dart`'s doc comment for why those two
    // differ; using the UUID here previously made this device's own avatar
    // hash to a different illustration than the one friends actually see).
    final accountIdAsync = ref.watch(friendsOnMapAccountIdProvider);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 280),
      child: Column(
        children: [
          accountIdAsync.when(
            data: (accountId) => FriendMarkerAvatar(friendId: accountId, size: 40),
            loading: () => const SizedBox(
              width: 40,
              height: 40,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, _) => const SizedBox(width: 40, height: 40),
          ),
          const SizedBox(height: Spacing.$2x),
          linkAsync.when(
            data: (link) => _LinkContent(link: link),
            loading: () => const Padding(
              padding: EdgeInsets.all(Spacing.$4x),
              child: CircularProgressIndicator(),
            ),
            error: (_, _) => Text(
              context.l10n.addFriendLoadError,
              style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.errorDefault),
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkContent extends ConsumerWidget {
  final String link;

  const _LinkContent({required this.link});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
    children: [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(Spacing.$4x),
        decoration: BoxDecoration(
          color: context.colors.backgroundSurface1,
          borderRadius: BorderRadius.circular(RadiusBorder.l),
        ),
        child: Column(
          children: [
            // Kept dark-on-white (not the design's inverted white-on-dark
            // modules): inverted QR codes aren't reliably decoded by every
            // scanner, and this is the one thing here that has to scan.
            Container(
              padding: const EdgeInsets.all(Spacing.$2x),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(RadiusBorder.m),
              ),
              child: QrImageView(data: link, size: 180),
            ),
            const SizedBox(height: Spacing.$3x),
            Text(
              context.l10n.addFriendScanQrCaption,
              textAlign: TextAlign.center,
              style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
            ),
          ],
        ),
      ),
      const SizedBox(height: Spacing.$4x),
      SizedBox(
        width: double.infinity,
        child: AppButton(
          buttonColorScheme: ButtonColorScheme.accentSecondary,
          size: ButtonSize.large,
          primaryLabel: context.l10n.addFriendShareCta,
          onTap: () => safeShareText(link, context: context),
        ),
      ),
      const SizedBox(height: Spacing.$2x),
      SizedBox(
        width: double.infinity,
        child: AppButton(
          buttonColorScheme: ButtonColorScheme.accentSecondary,
          buttonType: ButtonType.secondary,
          size: ButtonSize.large,
          primaryLabel: context.l10n.addFriendResetCta,
          onTap: () => runFriendsOnMapAction(context, () => ref.read(friendsOnMapInviteLinkProvider.notifier).reset()),
        ),
      ),
    ],
  );
}
