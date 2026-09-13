import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/friends_on_map/models/friend.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/friend_avatar.dart';
import 'package:mapness/features/share_eta/ui/eta_share_control_sheet/eta_share_sheet.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/widgets/routing/lib/duration_distance_fmt.dart';

/// S-15 (R-52/R-53/R-54/R-55): opens on a friend marker tap. Reuses
/// [EtaShareSheet] as a plain presentational shell (drag handle, title,
/// close button, content rows, optional confirm button) — it carries no
/// eta-specific logic despite living in `share_eta/`.
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
    final elapsedLabel = _elapsedLabel(context, friend.lastPositionAt);
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
      ],
    );
  }

  // "Just now" / "N min ago" / "N hr ago" / "N days ago" — mirrors
  // features/tifo/leaderboard_sheet.dart's private _relativeTime shape,
  // scoped to this feature with its own friendCardTime* l10n keys.
  String? _elapsedLabel(BuildContext context, DateTime? at) {
    if (at == null) {
      return null;
    }
    final l10n = context.l10n;
    final diff = DateTime.now().difference(at);
    if (diff.inMinutes < 1) {
      return l10n.friendCardTimeJustNow;
    }
    if (diff.inHours < 1) {
      return l10n.friendCardTimeMinutesAgo(diff.inMinutes);
    }
    if (diff.inDays < 1) {
      return l10n.friendCardTimeHoursAgo(diff.inHours);
    }
    return l10n.friendCardTimeDaysAgo(diff.inDays);
  }
}
