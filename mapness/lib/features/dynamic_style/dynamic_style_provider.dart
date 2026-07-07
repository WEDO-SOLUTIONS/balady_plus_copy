import 'package:mapness/features/dynamic_style/dynamic_style_service.dart';
import 'package:mapness/features/dynamic_style/map_style_store.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dynamic_style_provider.g.dart';

const _logTag = '[dynamic_style]';

/// Facade over [MapStyleStore] that groups the higher-level mutation flows
/// (repack with overrides, download from URL, apply picker file).
///
/// The store owns the actual `current.2gis` file on disk; this controller
/// just orchestrates the source-specific work (download bytes, run repack in
/// an isolate) and hands the result off to the store, which performs the
/// atomic in-place write and bumps its revision so [DgisController] can
/// reload the SDK's style.
///
/// keepAlive: the controller is stateless, but Riverpod codegen still emits a
/// class; keepAlive avoids needless rebuild-and-disposal churn when nothing
/// is listening.
@Riverpod(keepAlive: true)
class DynamicStyleController extends _$DynamicStyleController {
  @override
  void build() {}

  /// Apply [overrides] on top of the store's current `.2gis` in place.
  ///
  /// Accumulative: reads the current on-disk archive, overwrites the listed
  /// entries, writes back atomically. To start from a clean bundled archive,
  /// call [resetToBundled] first (or pass empty [overrides], which shortcuts
  /// to reset).
  Future<void> applyOverrides(List<StyleEntryOverride> overrides) async {
    if (overrides.isEmpty) {
      return resetToBundled();
    }
    final service = ref.read(dynamicStyleServiceProvider);
    final styleFile = await ref.read(mapStyleStoreProvider.future);
    await service.repackInto(targetPath: styleFile.path, overrides: overrides);
    await ref.read(mapStyleStoreProvider.notifier).notifyMutated();
    logger.log('$_logTag applyOverrides: applied ${overrides.length} override(s)');
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
  Future<void> resetToBundled() async {
    await ref.read(mapStyleStoreProvider.notifier).resetToBundled();
    logger.log('$_logTag resetToBundled: restored bundled asset');
  }
}

@Riverpod(keepAlive: true)
DynamicStyleService dynamicStyleService(Ref ref) => const DynamicStyleService();
