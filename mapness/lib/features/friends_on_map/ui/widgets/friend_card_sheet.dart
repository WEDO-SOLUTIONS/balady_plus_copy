import 'dart:async';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/friends_on_map/models/friend.dart';
import 'package:mapness/features/friends_on_map/providers/friends_controller.dart';
import 'package:mapness/features/friends_on_map/ui/friends_on_map_error_dialog.dart';
import 'package:mapness/features/friends_on_map/ui/meetup_share_flow.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/friend_marker_avatar.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/friend_confirm_sheet.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/widgets/routing/lib/duration_distance_fmt.dart';

/// S-15 (R-52/R-53/R-54/R-55, plus R-56's remove/block rows): opens on a
/// friend marker tap. Laid out per the dark-theme design: drag handle, one
/// card (avatar + name + distance, then the action rows), "See on map" CTA
/// — no title/close header, so this no longer reuses `EtaShareSheet`.
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
    final cameraPosition = ref.watch(cameraPositionProvider);

    return Container(
      decoration: BoxDecoration(
        color: context.colors.backgroundSurface4,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(RadiusBorder.xl),
          topRight: Radius.circular(RadiusBorder.xl),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.$4x).copyWith(top: 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Center(child: SheetDragger()),
            ContentWrapper(
              color: context.colors.backgroundSurface1,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.$3x, vertical: Spacing.$2x),
                  child: Row(
                    children: [
                      FriendMarkerAvatar(friendId: friend.id, size: 40),
                      const SizedBox(width: Spacing.$3x),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              friend.displayName,
                              overflow: TextOverflow.ellipsis,
                              style: context.textStyles.bodyLargeMedium.copyWith(
                                color: context.colors.foregroundDefault,
                              ),
                            ),
                            if (distanceMeters != null)
                              Text(
                                distanceMeters.formatDistance(context.l10n),
                                style: context.textStyles.bodySmallRegular.copyWith(
                                  color: context.colors.foregroundSoft,
                                ),
                              )
                            else if (!hasPosition)
                              // R-54: not currently reachable via marker tap (a
                              // marker only ever exists for a friend with a known
                              // position — see friends_on_map/AGENTS.md), kept for
                              // correctness and for a future non-marker entry point.
                              Text(
                                context.l10n.friendCardPositionUnavailable,
                                style: context.textStyles.bodySmallRegular.copyWith(
                                  color: context.colors.foregroundSoft,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                ContentRow(
                  isDividerEnabled: true,
                  onTap: () => _openChat(context, ref),
                  leading: Icon(Icons.chat_bubble_outline, color: context.colors.foregroundMuted),
                  text: ContentRowTextOptions(title: context.l10n.friendCardMessageCta),
                ),
                ContentRow(
                  isDividerEnabled: true,
                  onTap: () => _shareMeetup(context),
                  leading: Icon(SystemIcons.share, color: context.colors.foregroundMuted),
                  text: ContentRowTextOptions(title: context.l10n.friendCardShareMeetupCta),
                ),
                ContentRow(
                  isDividerEnabled: true,
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
            ),
            if (hasPosition)
              Padding(
                padding: const EdgeInsets.only(top: Spacing.$4x),
                child: SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    buttonColorScheme: ButtonColorScheme.accentSecondary,
                    size: ButtonSize.large,
                    primaryLabel: context.l10n.friendCardCenterOnMapCta,
                    onTap: () {
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
                    },
                  ),
                ),
              ),
            const SizedBox(height: Spacing.$8x),
          ],
        ),
      ),
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
  // S-17: skips the friend-picker entirely — the recipient is already this
  // one friend. Pops the card first, same reasoning as _confirmRemove below
  // (the place-picker/confirm sheets that follow live off the root
  // navigator's context, not this card's).
  void _shareMeetup(BuildContext context) {
    Navigator.of(context).pop();
    unawaited(startMeetupShareFlow(rootNavigatorKey.currentContext!, [friend]));
  }

  // S-21 (R-94): opens the in-app conversation. Resolves the nested MapRoute
  // router from the root (same reasoning as open_meetup_on_map.dart) before
  // popping, since the card is opened off the root navigator's context where
  // `context.router` doesn't reach the stack the chat route lives in.
  void _openChat(BuildContext context, WidgetRef ref) {
    final router = ref.read(appRouterProvider).innerRouterOf<StackRouter>(MapRoute.name);
    Navigator.of(context).pop();
    unawaited(router?.push(ChatRoute(friendId: friend.id, displayName: friend.displayName)));
  }

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
      onConfirm: () => runFriendsOnMapAction(
        rootNavigatorKey.currentContext!,
        () => ProviderScope.containerOf(
          rootNavigatorKey.currentContext!,
          listen: false,
        ).read(friendsControllerProvider.notifier).removeFriend(friend.id),
      ),
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
      onConfirm: () => runFriendsOnMapAction(
        rootNavigatorKey.currentContext!,
        () => ProviderScope.containerOf(
          rootNavigatorKey.currentContext!,
          listen: false,
        ).read(friendsControllerProvider.notifier).blockFriend(friend),
      ),
    );
  }
}
