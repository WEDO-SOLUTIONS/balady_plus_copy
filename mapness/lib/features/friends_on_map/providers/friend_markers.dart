import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:image/image.dart' as img;
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/features/friends_on_map/friend_elapsed_time.dart';
import 'package:mapness/features/friends_on_map/models/friend.dart';
import 'package:mapness/features/friends_on_map/providers/friends_list.dart';
import 'package:mapness/features/friends_on_map/providers/friends_on_map_layer_visible.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/friend_card_sheet.dart';
import 'package:mapness/features/share_eta/helpers/utils.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friend_markers.g.dart';

const int _kMarkerSizePx = 48;
const double _kMarkerSize = 48;

// R-49/R-50 (Appendix B's 15-minute freshness threshold, applied via
// friendPositionIsStale): a neutral caption color while fresh, an amber one
// once stale — the caption's own changing text ("Just now" -> "18 min ago")
// is the primary staleness signal (N-12: distinguishable by more than
// colour alone), this is only a secondary cue. Same hex-literal convention
// features/founding_day/founding_day.dart's _markerAnchorTextStyle uses.
const int _kFreshTextColor = 0xFF4A4A4A;
const int _kStaleTextColor = 0xFFB26A00;

// TODO(BE-213): 60s is a placeholder refresh interval, not tied to any BRD
// adaptive-interval requirement — see the same standing note on
// friends_on_map_position_reporter.dart's own interval.
const Duration _kLabelRefreshInterval = Duration(seconds: 60);

// keepAlive: must keep drawing/clearing markers regardless of which screen
// is focused — same rationale as `friends_on_map_position_reporter.dart`.
// Watched from `pages/map/map_page.dart` (the always-mounted root route) so
// it's actually alive to do that.
@Riverpod(keepAlive: true)
class FriendMarkers extends _$FriendMarkers {
  Timer? _labelRefreshTimer;

  @override
  Future<void> build() async {
    // Same cancel-then-recreate-in-build guard as
    // friends_on_map_position_reporter.dart, so a rebuild (e.g. the layer
    // toggle, or a friend being added/removed) never leaves two timers
    // running.
    _labelRefreshTimer?.cancel();
    _labelRefreshTimer = null;
    ref.onDispose(() => _labelRefreshTimer?.cancel());

    try {
      final visible = ref.watch(friendsOnMapLayerVisibleProvider);
      final settings = MapObjectManagerSettings.friends();
      // Must be `ref.watch`, not `ref.read` — `mapObjectManagerProvider` is
      // auto-dispose, and `read` doesn't create a keep-alive listener edge.
      // Reading it here let it get disposed mid-flight, causing every build
      // to throw "Cannot use the Ref of ... after it has been disposed."
      // `watch` matches the working pattern in `pages/map/map_page.dart`'s
      // `selectedMarker` layer.
      final manager = ref.watch(mapObjectManagerProvider(named: settings.name, layerId: settings.layerId).notifier);
      // Wait for the manager — and, transitively, dgisControllerProvider —
      // to be fully ready before mutating it. Without this,
      // object_manager.dart's `ref.read(dgisControllerProvider).value?.foo(
      // ...)` calls silently no-op (standard Dart null-aware short-circuit:
      // the receiver is checked before any argument, including `await
      // future`, is even evaluated) whenever the native map hasn't fired
      // onMapCreated yet — guaranteed true the very first time this
      // provider builds, since that happens during MapPage's first build,
      // before DgisMap can have created its controller.
      await ref.watch(mapObjectManagerProvider(named: settings.name, layerId: settings.layerId).future);
      // Dart futures aren't cancellable — if something invalidates this
      // provider again (e.g. friend_requests.dart's accept() invalidating
      // friendsListProvider) while this build() is still awaiting, a stale
      // execution must not go on to mutate the same still-live
      // MapObjectManager alongside the newer one, or both add their own
      // markers with duplicate ids and independent onTap closures — one tap
      // then fires every leftover marker's sheet. Same guard shape as
      // friends_on_map_position_reporter.dart.
      if (!ref.mounted) {
        return;
      }

      if (!visible) {
        await manager.removeAllMarkers();
        return;
      }

      final friends = await ref.watch(friendsListProvider.future);
      if (!ref.mounted) {
        return;
      }
      final visibleFriends = friends.where((f) => f.latitude != null && f.longitude != null).toList();

      final markers = await Future.wait(visibleFriends.map(_buildMarker));
      if (!ref.mounted) {
        return;
      }

      await manager.removeAllMarkers();
      await manager.addMarkers(markers);

      // R-49: keeps each marker's "N min ago" caption current between
      // structural rebuilds (which only happen when the friend list or the
      // layer toggle actually changes) — patches text/colour in place via
      // setMarkerOptions rather than another remove-all/add-all cycle, so
      // markers don't visibly re-pop every refresh tick. No need to fire
      // immediately here (unlike friends_on_map_position_reporter.dart) —
      // _buildMarker just set an accurate label for every marker above.
      _labelRefreshTimer = Timer.periodic(_kLabelRefreshInterval, (_) => unawaited(_refreshLabels()));
    } catch (ex, stackTrace) {
      // No ProviderObserver exists in this app, and this provider is only
      // ever bare-`ref.watch`'d (never `.when()`'d) — without this, a
      // failure here becomes a silent, unread AsyncError indistinguishable
      // from "markers just aren't rendering." Rethrow so the AsyncError
      // state is unchanged; this only adds visibility.
      logger.log('Error building friend markers: $ex\n$stackTrace');
      rethrow;
    }
  }

  Future<Marker> _buildMarker(Friend friend) async {
    final position = GeoPointWithElevationMessage(
      latitude: friend.latitude!,
      longitude: friend.longitude!,
      elevation: 0,
    );
    final pictureUrl = friend.profilePictureUrl;

    final icon = pictureUrl == null
        ? SvgMarkerIcon(svgPath: Assets.icons.svg.icProfile2.keyName, width: _kMarkerSize)
        : PngBytesMarkerIcon(
            pngData: img.encodePng(await EtaUtils.processImage(pictureUrl, _kMarkerSizePx)),
            width: _kMarkerSize,
          );

    return Marker(
      id: 'friend_marker_${friend.id}',
      // S-15: no per-marker friend data flows through the map's own tap
      // event, so the card is opened directly off this closure's captured
      // `friend`, using the root navigator's context the same way
      // share_eta's marker onTap does.
      onTap: () => showFriendCardSheet(rootNavigatorKey.currentContext!, friend),
      options: MarkerOptionsMessage(
        position: position,
        icon: icon,
        animatedAppearance: true,
        zIndex: 50,
        text: _markerText(friend),
        textStyle: _markerTextStyle(friend),
      ),
    );
  }

  // R-49/R-50: a caption under the marker showing elapsed time since the
  // friend's last known position, refreshed in place by _refreshLabels
  // without needing a BuildContext — this is a provider, not a widget, so
  // AppLocalizations is looked up directly off the current app language
  // (same `ref.read(appLanguageProvider)` source features/founding_day/
  // founding_day.dart already reads for its own marker text style).
  String? _markerText(Friend friend) {
    final lastPositionAt = friend.lastPositionAt;
    if (lastPositionAt == null) {
      return null;
    }
    final l10n = lookupAppLocalizations(ref.read(appLanguageProvider).locale);
    return friendElapsedTimeLabel(l10n, lastPositionAt);
  }

  MarkerTextStyleMessage? _markerTextStyle(Friend friend) {
    final lastPositionAt = friend.lastPositionAt;
    if (lastPositionAt == null) {
      return null;
    }
    return MarkerTextStyleMessage(
      fontSize: 11,
      color: friendPositionIsStale(lastPositionAt) ? _kStaleTextColor : _kFreshTextColor,
      strokeWidth: 1,
      strokeColor: 0xFFFFFFFF,
    );
  }

  // Patches only the caption/colour on each already-drawn marker — see the
  // comment where this is scheduled in build() for why this uses
  // setMarkerOptions instead of another removeAllMarkers()/addMarkers()
  // cycle.
  Future<void> _refreshLabels() async {
    if (!ref.mounted) {
      return;
    }
    if (!ref.read(friendsOnMapLayerVisibleProvider)) {
      return;
    }
    final friends = await ref.read(friendsListProvider.future);
    if (!ref.mounted) {
      return;
    }
    final settings = MapObjectManagerSettings.friends();
    final manager = ref.read(mapObjectManagerProvider(named: settings.name, layerId: settings.layerId).notifier);
    for (final friend in friends) {
      if (friend.latitude == null || friend.longitude == null) {
        continue;
      }
      // Isolated per-friend: without this, one marker's setMarkerOptions
      // call throwing (id no longer present natively, a transient platform-
      // channel error, etc.) would abort the whole loop via the unawaited
      // Future in build(), silently skipping every friend after it — which
      // would look exactly like "only one marker's caption ever updates."
      // Logged, not swallowed silently, same reasoning as build()'s own
      // try/catch.
      try {
        await manager.setMarkerOptions(
          'friend_marker_${friend.id}',
          ChangeMarkerOptionsMessage(text: _markerText(friend), textStyle: _markerTextStyle(friend)),
        );
      } catch (ex, stackTrace) {
        logger.log('Error refreshing marker label for friend ${friend.id}: $ex\n$stackTrace');
      }
    }
  }
}
