import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/features/friends_on_map/friend_elapsed_time.dart';
import 'package:mapness/features/friends_on_map/models/friend.dart';
import 'package:mapness/features/friends_on_map/providers/friends_controller.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/friend_avatar.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/friend_confirm_sheet.dart';
import 'package:mapness/features/share_eta/ui/eta_share_control_sheet/eta_share_sheet.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/widgets/routing/lib/duration_distance_fmt.dart';

/// S-15 (R-52/R-53/R-54/R-55, plus R-56's remove/block rows): opens on a
/// friend marker tap. Reuses [EtaShareSheet] as a plain presentational
/// shell (drag handle, title, close button, content rows, optional confirm
/// button) — it carries no eta-specific logic despite living in
/// `share_eta/`.
bool _isFriendCardSheetOpen = false;

void showFriendCardSheet(BuildContext context, Friend friend) {
  // Defensive re-entrancy guard, same shape as scan_qr_view.dart's
  // `_handlingDetection` flag — belt-and-suspenders against any duplicate
  // tap event (e.g. leftover markers from a race in FriendMarkers.build(),
  // now guarded separately) opening more than one stacked sheet.
  if (_isFriendCardSheetOpen) {
    return;
  }
  _isFriendCardSheetOpen = true;
  showModalBottomSheet<void>(
    backgroundColor: Colors.transparent,
    context: context,
    isScrollControlled: true,
    builder: (context) => Consumer(
      builder: (_, ref, __) => FriendCardSheet(friend: friend),
    ),
  ).whenComplete(() => _isFriendCardSheetOpen = false);
}

class FriendCardSheet extends ConsumerWidget {
  final Friend friend;

  const FriendCardSheet({required this.friend, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasPosition = friend.latitude != null && friend.longitude != null;
    final ownPosition = ref.watch(locationProvider);
    final distanceMeters = (hasPosition && ownPosition != null)
        ? CommonFunctions.distance(ownPosition.latitude, ownPosition.longitude, friend.latitude!, friend.longitude!) *
              1000
        : null;
    final elapsedLabel = friend.lastPositionAt == null
        ? null
        : friendElapsedTimeLabel(context.l10n, friend.lastPositionAt!);
    final cameraPosition = ref.watch(cameraPositionProvider);

    return EtaShareSheet(
      title: friend.displayName,
      confirmBtnTitle: hasPosition ? context.l10n.friendCardCenterOnMapCta : null,
      onConfirmTap: hasPosition
          ? () {
              Navigator.of(context).pop();
              ref
                  .read(cameraPositionProvider.notifier)
                  .animateTo(
                    CameraPositionMessage(
                      point: GeoPointMessage(latitude: friend.latitude!, longitude: friend.longitude!),
                      zoom: cameraPosition?.zoom ?? 17,
                      tilt: cameraPosition?.tilt ?? 0,
                      bearing: cameraPosition?.bearing ?? 0,
                    ),
                  );
            }
          : null,
      contentBuilder: (context) => [
        Row(
          children: [
            FriendAvatar(displayName: friend.displayName, profilePictureUrl: friend.profilePictureUrl, radius: 32),
            const SizedBox(width: Spacing.$3x),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (elapsedLabel != null)
                    Text(
                      elapsedLabel,
                      style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundMuted),
                    ),
                  if (distanceMeters != null)
                    Text(
                      distanceMeters.formatDistance(context.l10n),
                      style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundMuted),
                    )
                  else if (!hasPosition)
                    // R-54: not currently reachable via marker tap (a
                    // marker only ever exists for a friend with a known
                    // position — see friends_on_map/AGENTS.md), kept for
                    // correctness and for a future non-marker entry point.
                    Text(
                      context.l10n.friendCardPositionUnavailable,
                      style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundMuted),
                    ),
                ],
              ),
            ),
          ],
        ),
        ContentRow(
          onTap: () => _confirmRemove(context),
          leading: Icon(GeneralIcons.trash, color: context.colors.errorDefault),
          text: ContentRowTextOptions(
            title: context.l10n.friendCardRemoveCta,
            titleOptions: ContentRowTextOption(baseColor: context.colors.errorDefault),
          ),
        ),
        ContentRow(
          onTap: () => _confirmBlock(context),
          leading: Icon(GeneralIcons.block, color: context.colors.errorDefault),
          text: ContentRowTextOptions(
            title: context.l10n.friendCardBlockCta,
            titleOptions: ContentRowTextOption(baseColor: context.colors.errorDefault),
          ),
        ),
      ],
    );
  }

  // l10n strings are read before popping, then the confirm sheet is opened
  // off the root navigator's context — same reasoning `friend_markers.dart`
  // uses to open the card itself, avoids relying on a context mid-pop.
  //
  // Deliberately does NOT capture this widget's own `WidgetRef` for later
  // use in `onConfirm` — by the time the user actually taps confirm on the
  // second sheet, this card has long been popped/unmounted, and Riverpod's
  // `ref.read` throws `StateError('Using "ref" when a widget is about to or
  // has been unmounted is unsafe...')` at that point (silently swallowed by
  // Flutter's gesture-callback error handling — no crash, no visible
  // effect, which is exactly the bug this was). Reading via
  // `ProviderScope.containerOf` on the root navigator's context instead,
  // *inside* the onConfirm closure (evaluated at confirm-tap time, not
  // capture time), avoids depending on any widget's lifetime at all.
  void _confirmRemove(BuildContext context) {
    final title = context.l10n.friendCardRemoveConfirmTitle;
    final body = context.l10n.friendCardRemoveConfirmBody(friend.displayName);
    final confirmLabel = context.l10n.friendCardRemoveCta;
    Navigator.of(context).pop();
    showFriendConfirmSheet(
      rootNavigatorKey.currentContext!,
      title: title,
      body: body,
      confirmLabel: confirmLabel,
      onConfirm: () => ProviderScope.containerOf(
        rootNavigatorKey.currentContext!,
        listen: false,
      ).read(friendsControllerProvider.notifier).removeFriend(friend.id),
    );
  }

  void _confirmBlock(BuildContext context) {
    final title = context.l10n.friendCardBlockConfirmTitle;
    final body = context.l10n.friendCardBlockConfirmBody(friend.displayName);
    final confirmLabel = context.l10n.friendCardBlockCta;
    Navigator.of(context).pop();
    showFriendConfirmSheet(
      rootNavigatorKey.currentContext!,
      title: title,
      body: body,
      confirmLabel: confirmLabel,
      onConfirm: () => ProviderScope.containerOf(
        rootNavigatorKey.currentContext!,
        listen: false,
      ).read(friendsControllerProvider.notifier).blockFriend(friend),
    );
  }
}
