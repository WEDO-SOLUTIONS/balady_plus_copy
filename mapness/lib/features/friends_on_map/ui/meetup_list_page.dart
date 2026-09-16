import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/friends_on_map/models/meetup.dart';
import 'package:mapness/features/friends_on_map/providers/meetups_controller.dart';
import 'package:mapness/features/friends_on_map/providers/meetups_list.dart';
import 'package:mapness/features/friends_on_map/ui/friends_on_map_error_dialog.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/meetup_list_item.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/meetup_marker_info_sheet.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';
import 'package:mapness/shared/ui/markers/markers.dart';

const _kMeetupMarkerId = 'meetup-place-marker';

/// R-69: places friends have shared, newest first. Tap opens the place on
/// the map; swipe dismisses the current user's own copy (`onDismiss`).
@RoutePage()
class MeetupListPage extends ConsumerStatefulWidget {
  const MeetupListPage({super.key});

  @override
  ConsumerState<MeetupListPage> createState() => _MeetupListPageState();
}

class _MeetupListPageState extends ConsumerState<MeetupListPage> {
  // Optimistic local hide for swipe-to-dismiss: `Dismissible` requires the
  // item gone from the tree by the next frame, but the real removal is a
  // network round-trip (`MeetupsController.dismiss`). Hiding synchronously
  // here satisfies that contract; `_dismiss` below reconciles against the
  // real list once the call resolves either way.
  final Set<String> _dismissedIds = {};

  @override
  Widget build(BuildContext context) {
    final meetupsAsync = ref.watch(receivedMeetupsProvider);

    return Directionality(
      textDirection: ref.watch(uiDirectionProvider),
      child: Material(
        color: context.colors.backgroundSurface4,
        child: Scaffold(
          appBar: BaladyTopBar.iconAndText(
            title: context.l10n.meetupListTitle,
            colorEnabled: context.colors.accentDefault,
            leading: ActionModel(onPressed: () => context.router.pop(), icon: SystemIcons.arrowCornerLeftLarge),
          ),
          body: SafeArea(
            child: meetupsAsync.when(
              data: (meetups) {
                final visible = meetups.where((m) => !_dismissedIds.contains(m.id)).toList();
                return visible.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(Spacing.$4x),
                          child: Text(
                            context.l10n.meetupListEmpty,
                            textAlign: TextAlign.center,
                            style: context.textStyles.bodyLargeRegular.copyWith(
                              color: context.colors.foregroundMuted,
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: visible.length,
                        itemBuilder: (context, index) {
                          final meetup = visible[index];
                          return MeetupListItem(
                            meetup: meetup,
                            onTap: () => _openOnMap(meetup),
                            onDismiss: () => _dismiss(meetup),
                          );
                        },
                      );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }

  void _dismiss(Meetup meetup) {
    setState(() => _dismissedIds.add(meetup.id));
    runFriendsOnMapAction(
      context,
      () => ref.read(meetupsControllerProvider.notifier).dismiss(meetup.id),
    ).then((_) {
      // Success: redundant, the item is already gone from the source list.
      // Failure (error dialog already shown by runFriendsOnMapAction):
      // reveals the item again so the user can retry, instead of it staying
      // hidden despite the dismiss never actually happening server-side.
      if (mounted) {
        setState(() => _dismissedIds.remove(meetup.id));
      }
    });
  }

  // R-55-style "center on map" (same call shape as friend_card_sheet.dart),
  // plus a temporary pin — reuses shared/providers/map/selected_marker.dart,
  // the same generic single-marker mechanism already used when a POI is
  // tapped/selected, rather than building a new marker manager for one
  // ephemeral pin.
  //
  // popUntil(BottomMenuRoute), not a single pop(): FriendsOnMapRoute /
  // FriendListRoute / MeetupListRoute are all flat children of MapRoute's
  // own nested stack, so a single pop only closes this page, leaving
  // FriendListRoute covering the map underneath. BottomMenuRoute is that
  // stack's base/landing entry — same working precedent already used by
  // pages/feedback/feedback_sheet_widget.dart's popNavigation.
  //
  // popUntil alone isn't enough: BottomMenuRoute hosts its OWN AutoTabsRouter
  // (landing/routing/services/profile — pages/bottom_menu/bottom_menu_page.dart),
  // and Friends on Map is normally reached from the Profile tab, so without
  // this the user lands back on Profile, not the map. BottomMenuRoute is a
  // SIBLING of FriendsOnMapRoute/FriendListRoute/MeetupListRoute (all flat
  // children of MapRoute), not their ancestor, so reaching its tabs router
  // needs innerRouterOf's cross-tree lookup rather than a simple ancestor
  // walk — same call shape already used by
  // pages/lifestyle_layers/layers_sheet.dart. Index 0 is LandingRoute (the
  // map tab), per bottom_menu_page.dart's own AutoTabsRouter.builder routes.
  void _openOnMap(Meetup meetup) {
    context.router.popUntil((route) => route.settings.name == BottomMenuRoute.name);
    context.innerRouterOf<TabsRouter>(BottomMenuRoute.name)?.setActiveIndex(0);
    final cameraPosition = ref.read(cameraPositionProvider);
    ref
        .read(cameraPositionProvider.notifier)
        .animateTo(
          CameraPositionMessage(
            point: GeoPointMessage(latitude: meetup.latitude, longitude: meetup.longitude),
            zoom: cameraPosition?.zoom ?? 17,
            tilt: cameraPosition?.tilt ?? 0,
            bearing: cameraPosition?.bearing ?? 0,
          ),
        );
    final pin = Markers.pinMarker(
      GeoPointWithElevationMessage(latitude: meetup.latitude, longitude: meetup.longitude, elevation: 1),
      id: _kMeetupMarkerId,
      text: meetup.label ?? meetup.senderDisplayName,
    );
    // Markers.pinMarker itself takes no onTap (shared by several unrelated
    // features, not worth widening) — wrap its result instead. The closure
    // uses rootNavigatorKey.currentContext!, not this page's own
    // context/ref: by the time it fires, MeetupListPage has already been
    // popped off (see above) and its State is disposed.
    ref
        .read(selectedMarkerProvider.notifier)
        .showMarker(
          Marker(
            id: pin.id,
            options: pin.options,
            onTap: () => showMeetupMarkerInfoSheet(rootNavigatorKey.currentContext!, meetup),
          ),
        );
  }
}
