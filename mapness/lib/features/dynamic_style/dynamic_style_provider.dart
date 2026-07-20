import 'package:flutter/services.dart';
import 'package:mapness/features/dynamic_style/dynamic_style_service.dart';
import 'package:mapness/features/dynamic_style/map_style_store.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/map_recreation.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dynamic_style_provider.g.dart';

const _logTag = '[dynamic_style]';

/// Facade over [MapStyleStore] that groups the higher-level mutation flows
/// (repack with overrides, download from URL, apply picker file).
///
/// The store owns the rotating `current-<N>.2gis` files on disk; this
/// controller orchestrates source-specific work (download bytes, run repack
/// in an isolate) and hands the result off to the store, which commits it
/// so [DgisController] can reload the SDK's style at a fresh path.
///
/// keepAlive: the controller is stateless, but Riverpod codegen still emits a
/// class; keepAlive avoids needless rebuild-and-disposal churn when nothing
/// is listening.
@Riverpod(keepAlive: true)
class DynamicStyleController extends _$DynamicStyleController {
  @override
  void build() {}

  /// Apply [overrides] on top of the store's current `.2gis`.
  ///
  /// Accumulative: reads the current on-disk archive, applies the listed
  /// entry overrides, writes to the store's next rotation slot, then commits.
  /// A fresh absolute path is required on every mutation because the 2GIS
  /// SDK (12.8.0) caches decoded GLB resources by archive path and refuses
  /// to reload them from the same file — see [MapStyleStore] for detail.
  ///
  /// To start from a clean bundled archive, call [resetToBundled] first (or
  /// pass empty [overrides], which shortcuts to reset).
  Future<void> applyOverrides(List<StyleEntryOverride> overrides) async {
    if (overrides.isEmpty) {
      return resetToBundled();
    }
    final service = ref.read(dynamicStyleServiceProvider);
    final store = ref.read(mapStyleStoreProvider.notifier);
    final styleFile = await ref.read(mapStyleStoreProvider.future);
    final nextPath = store.allocateNextPath();
    final suffix = store.nextRevision;

    // Snapshot the live camera BEFORE the native MapView is torn down.
    // On 2GIS SDK 12.8.0 the process-scoped GLB mesh cache survives
    // `loadStylesFromPath`, so swapping a car model requires recreating the
    // MapView entirely. See [MapRecreationCounter] for the recreate protocol.
    final currentController = activeDgisController;
    if (currentController != null) {
      try {
        final position = await currentController.getCameraPosition();
        ref.read(pendingCameraSnapshotProvider.notifier).set(position);
      } on PlatformException catch (e) {
        logger.log('$_logTag applyOverrides: failed to snapshot camera: $e');
      }
    }

    await service.repackInto(
      sourcePath: styleFile.path,
      targetPath: nextPath,
      overrides: overrides,
      renameSuffix: suffix,
    );

    // Invalidate BEFORE publish. `DgisController._setupControllerItself`
    // subscribes to `mapStyleStoreProvider` and fires
    // `controller.loadStylesFromPath` on any revision bump. If we publish
    // first, that listener kicks off `StyleBuilder.loadStyle` on the
    // native side, and its Future resolves AFTER we've called
    // `Map.close()` (via the counter bump below) — which crashes with
    // `IllegalStateException: Access to closed Java object`. Dropping the
    // provider tears the listener down synchronously so the publish
    // reaches no one.
    ref.invalidate(dgisControllerProvider);

    await store.publishExternallyWritten(nextPath);
    logger.log('$_logTag applyOverrides: applied ${overrides.length} override(s) suffix=_v$suffix → $nextPath');

    // Bump the recreation counter to remount DgisMap. The native
    // `Map.close()` releases the SDK's mesh cache; the fresh MapView
    // cold-decodes the already-published new archive on its first
    // `onMapCreated → _loadActiveStyle` pass.
    ref.read(mapRecreationCounterProvider.notifier).bump();
  }

  /// Download a compiled `.2gis` from [url] and swap it in.
  Future<void> applyNetworkStyle(String url) async {
    final service = ref.read(dynamicStyleServiceProvider);
    final bytes = await service.downloadStyleBytes(url);
    await ref.read(mapStyleStoreProvider.notifier).replaceWithBytes(bytes);
    logger.log('$_logTag applyNetworkStyle: swapped to network style ($url)');
  }

  /// Adopt a `.2gis` that already exists on disk (e.g. from a file picker
  /// cache path). The store copies the bytes into its own canonical file so
  /// the source can safely be a transient path.
  Future<void> applyStyleFromPath(String absolutePath) async {
    await ref.read(mapStyleStoreProvider.notifier).replaceWithFile(absolutePath);
    logger.log('$_logTag applyStyleFromPath: swapped to $absolutePath');
  }

  /// Drop any mutations and re-seed the store from the bundled asset.
  ///
  /// Runs the same MapView-recreate protocol as [applyOverrides]: without it
  /// the 2GIS SDK returns the last-cached car model even after the archive
  /// on disk is back to the bundled state — the mesh cache is keyed by the
  /// last name the SDK saw at that archive slot, not by the current archive
  /// contents.
  Future<void> resetToBundled() async {
    // Snapshot the live camera before we tear the MapView down.
    final currentController = activeDgisController;
    if (currentController != null) {
      try {
        final position = await currentController.getCameraPosition();
        ref.read(pendingCameraSnapshotProvider.notifier).set(position);
      } on PlatformException catch (e) {
        logger.log('$_logTag resetToBundled: failed to snapshot camera: $e');
      }
    }

    // Invalidate BEFORE the store publishes — see [applyOverrides] for the
    // reason (avoids a StyleBuilder Future racing against Map.close()).
    ref.invalidate(dgisControllerProvider);

    await ref.read(mapStyleStoreProvider.notifier).resetToBundled();
    logger.log('$_logTag resetToBundled: restored bundled asset');

    ref.read(mapRecreationCounterProvider.notifier).bump();
  }
}

@Riverpod(keepAlive: true)
DynamicStyleService dynamicStyleService(Ref ref) => const DynamicStyleService();
