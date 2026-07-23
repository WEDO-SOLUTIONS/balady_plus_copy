import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/friends_on_map/helpers/construct_friend_marker.dart';
import 'package:mapness/features/friends_on_map/model/friend_location_event.dart';
import 'package:mapness/features/friends_on_map/providers/friends_data_source_provider.dart';
import 'package:mapness/features/friends_on_map/providers/friends_layer_visible_provider.dart';
import 'package:mapness/features/lifestyle_layers/configs/layers_consts.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friends_markers_provider.g.dart';

// Above this the SDK shows individual markers again; below it, nearby
// friends collapse into a single cluster bubble. Matches the value used by
// the map-search clustering (`map_search_sheet.dart`) for consistency.
const _kClusterMaxZoom = 17.0;

/// Syncs friend markers to the native map: paints the initial snapshot in
/// bulk, then applies each subsequent event to a single marker (upsert or
/// remove) instead of redrawing everything on every update. Markers cluster
/// at lower zoom levels so a large debug-panel point count doesn't turn into
/// an unreadable pile of overlapping pins.
///
/// Watched (kept alive) from `LandingPage.build()` alongside the other
/// marker-provider activators.
@riverpod
class FriendsMarkers extends _$FriendsMarkers {
  StreamSubscription<FriendLocationEvent>? _subscription;

  // Built once and reused across rebuilds: `mapObjectManagerProvider` keys
  // its family on this instance by identity, so a fresh one every build()
  // would spawn a brand-new native manager (and orphan the old one) on
  // every rebuild instead of reusing the same clustered manager.
  ClusteringMapObjectManager? _clustering;

  @override
  Future<void> build() async {
    final isVisible = ref.watch(friendsLayerVisibleProvider);
    final settings = MapObjectManagerSettings.friends();
    _clustering ??= ClusteringMapObjectManager(
      options: ClusteringMapObjectManagerOptionsMessage(logicalPixel: 80, maxZoom: _kClusterMaxZoom),
      renderCluster: _renderCluster,
    );
    final mapObjectManager = ref.watch(
      mapObjectManagerProvider(named: settings.name, layerId: settings.layerId, clustering: _clustering).notifier,
    );

    await _subscription?.cancel();
    _subscription = null;

    if (!isVisible) {
      await mapObjectManager.removeAllMarkers();
      return;
    }

    final dataSource = ref.watch(friendsDataSourceProvider);

    final initial = await dataSource.getFriendLocations();
    await mapObjectManager.removeAllMarkers();
    await mapObjectManager.addMarkers(initial.map(constructFriendMarker).toList());

    _subscription = dataSource.watchFriendLocationUpdates().listen((event) => _applyEvent(mapObjectManager, event));
    ref.onDispose(() => _subscription?.cancel());
  }

  Future<void> _applyEvent(MapObjectManager mapObjectManager, FriendLocationEvent event) async {
    switch (event) {
      case FriendLocationUpdated(:final location):
        // Recreate rather than move-in-place so a tap always logs fresh data
        // (the marker's onTap closure captures the location at creation time).
        if (mapObjectManager.markerById(location.userId) != null) {
          await mapObjectManager.removeMarkerById(location.userId);
        }
        await mapObjectManager.addMarker(constructFriendMarker(location));
      case FriendLocationRemoved(:final userId):
        await mapObjectManager.removeMarkerById(userId);
    }
  }

  // Placeholder cluster bubble — reuses the same pin as individual markers
  // with a count overlay, until a dedicated cluster asset is designed.
  SimpleClusterOptionsMessage _renderCluster(int objectCount) => SimpleClusterOptionsMessage(
    icon: Assets.icons.svg.layers.icClusterPin.keyName.markerIcon(),
    text: '$objectCount',
    anchor: MarkerAnchorMessage(x: 0, y: 0),
    textStyle: MarkerTextStyleMessage(
      textPlacement: MarkerTextPlacementMessage(placement: TextPlacementMessage.centerCenter),
      color: 0xFF000000,
      strokeColor: 0xFF000000,
      fontSize: 12,
      suppressOnOverlap: false,
    ),
  );
}
