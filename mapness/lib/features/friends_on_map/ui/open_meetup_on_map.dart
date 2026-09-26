import 'package:auto_route/auto_route.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/friends_on_map/models/meetup.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/meetup_marker_info_sheet.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';
import 'package:mapness/shared/ui/markers/markers.dart';

const _kMeetupMarkerId = 'meetup-place-marker';

/// R-55-style "center on map" (same call shape as friend_card_sheet.dart),
/// plus a temporary pin — reuses shared/providers/map/selected_marker.dart,
/// the same generic single-marker mechanism already used when a POI is
/// tapped/selected, rather than building a new marker manager for one
/// ephemeral pin.
///
/// Shared between `meetup_list_page.dart`'s own row tap and the
/// "new meetup received" toast's View action (`pages/map/map_page.dart`) —
/// both need the exact same "go look at this shared place" behavior.
///
/// Only needs [ref] — deliberately takes no `BuildContext`. `MapRoute` (the
/// app's root/initial route, `MapPage`) hosts its OWN nested `AutoRouter`
/// whose routes include `BottomMenuRoute` *and* `FriendsOnMapRoute`/
/// `FriendListRoute`/`MeetupListRoute` as flat siblings (see
/// `app/auto_route/app_routes.dart`'s `MapRoute` children list) — a page
/// nested inside that router (like `MeetupListPage`) has a `context.router`
/// that correctly resolves to it, but `MapPage`'s own top-level context
/// does NOT (it sits above/outside that nested router, so `context.router`
/// there resolves to the ROOT router instead, whose stack is just
/// `[MapRoute]`). A real crash was caused by exactly this: calling
/// `context.router.popUntil(name == BottomMenuRoute.name)` with `MapPage`'s
/// own context popped `MapRoute` itself (never finding `BottomMenuRoute` in
/// the root stack), disposing `MapPage`'s State and, with it, the provider
/// watches keeping `mapObjectManagerProvider(... named: selected-marker)`
/// alive — the subsequent marker mutation then hit a disposed `Ref`. Fixed
/// by resolving the nested router explicitly from the root
/// (`appRouterProvider.innerRouterOf<StackRouter>(MapRoute.name)`) instead
/// of the ambient, context-level-dependent `context.router` — this is
/// correct regardless of which screen is visible when this runs, so both
/// call sites (this toast's View action, and `MeetupListPage`'s own row
/// tap) now share the identical, context-independent code path.
void openMeetupOnMap(WidgetRef ref, Meetup meetup) {
  // popUntil(BottomMenuRoute), not a single pop(): FriendsOnMapRoute /
  // FriendListRoute / MeetupListRoute are all flat children of MapRoute's
  // own nested stack, so a single pop only closes the calling page, leaving
  // whatever's above it covering the map underneath. BottomMenuRoute is that
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
  // walk. Index 0 is LandingRoute (the map tab), per bottom_menu_page.dart's
  // own AutoTabsRouter.builder routes.
  final mapRouter = ref.read(appRouterProvider).innerRouterOf<StackRouter>(MapRoute.name);
  mapRouter?.popUntil((route) => route.settings.name == BottomMenuRoute.name);
  mapRouter?.innerRouterOf<TabsRouter>(BottomMenuRoute.name)?.setActiveIndex(0);
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
  // uses rootNavigatorKey.currentContext!, not the context/ref passed in
  // above: by the time it fires, the page that called openMeetupOnMap may
  // already be popped off and its State disposed.
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
