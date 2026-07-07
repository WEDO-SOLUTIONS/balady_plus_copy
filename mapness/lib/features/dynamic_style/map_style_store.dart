import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'map_style_store.g.dart';

const _logTag = '[style_store]';

/// Immutable snapshot of the resolved style file on disk.
///
/// [path] is stable across mutations (see [MapStyleStore]); [revision]
/// increments on every mutation so downstream listeners can force a reload
/// even though the path stays constant.
@immutable
class StyleFile {
  const StyleFile({required this.path, required this.revision});

  final String path;
  final int revision;

  StyleFile bumped() => StyleFile(path: path, revision: revision + 1);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is StyleFile && other.path == path && other.revision == revision;

  @override
  int get hashCode => Object.hash(path, revision);

  @override
  String toString() => 'StyleFile(path=$path, rev=$revision)';
}

/// Owns the single canonical `.2gis` file that the 2GIS SDK loads.
///
/// Design:
/// * On first build the bundled asset ([MapnessConstants.mapStylesPath]) is
///   copied to `${applicationSupportDirectory}/map_styles/current.2gis`.
/// * The SDK is **always** handed the same absolute path — never an asset key
///   (asset loading is kept in [DgisMapController.loadStyles] only for
///   CarPlay / legacy).
/// * Mutations (repack, network download, file picker) atomically overwrite
///   `current.2gis` in place. A [_mutatedFlag] file marks the archive as
///   user-mutated so subsequent app updates that ship a new bundled asset do
///   **not** clobber it. Reset explicitly clears both the file and the flag.
/// * [StyleFile.revision] is bumped after every mutation so consumers can
///   trigger a reload via `ref.listen`.
@Riverpod(keepAlive: true)
class MapStyleStore extends _$MapStyleStore {
  /// Filename of the canonical style file on disk. Kept constant so the SDK
  /// can be handed the same absolute path on every load.
  static const _fileName = 'current.2gis';

  /// Sidecar file storing the bundled asset's byte length that was used on
  /// the last copy. Used to detect app updates that ship a new bundled asset.
  static const _bundleLengthMarker = 'bundle_length.txt';

  /// Sentinel file that, when present, signals `current.2gis` holds a
  /// user-mutated archive. Kept across app updates until explicit reset.
  static const _mutatedFlag = 'mutated.flag';

  late final Directory _dir;
  late final File _target;
  late final File _lengthMarker;
  late final File _flag;

  @override
  Future<StyleFile> build() async {
    final sw = Stopwatch()..start();
    final base = await getApplicationSupportDirectory();
    _dir = Directory('${base.path}/map_styles');
    if (!await _dir.exists()) {
      await _dir.create(recursive: true);
    }
    _target = File('${_dir.path}/$_fileName');
    _lengthMarker = File('${_dir.path}/$_bundleLengthMarker');
    _flag = File('${_dir.path}/$_mutatedFlag');

    await _ensureCurrentFile();
    logger.log('$_logTag ready at ${_target.path} in ${sw.elapsedMilliseconds}ms');
    return StyleFile(path: _target.path, revision: 0);
  }

  /// Canonical absolute path of the style file. Stable across mutations.
  ///
  /// Prefer awaiting `future` for the async-initialised path; this getter is
  /// safe to call only after [build] has completed.
  String get currentPath => _target.path;

  /// Replace `current.2gis` with an in-memory blob (atomically) and mark the
  /// archive as user-mutated.
  Future<void> replaceWithBytes(Uint8List bytes) async {
    logger.log('$_logTag replaceWithBytes: ${bytes.length}B');
    final tmp = File('${_target.path}.tmp');
    await tmp.writeAsBytes(bytes);
    await tmp.rename(_target.path);
    await _markMutated();
    _publish();
  }

  /// Replace `current.2gis` with the file at [srcPath] (atomically) and mark
  /// the archive as user-mutated. Copies bytes — the source file is
  /// untouched and can safely be a picker/cache path.
  Future<void> replaceWithFile(String srcPath) async {
    final src = File(srcPath);
    if (!await src.exists()) {
      throw StateError('Source style file not found: $srcPath');
    }
    logger.log('$_logTag replaceWithFile: $srcPath (${await src.length()}B)');
    final tmp = File('${_target.path}.tmp');
    await src.copy(tmp.path);
    await tmp.rename(_target.path);
    await _markMutated();
    _publish();
  }

  /// Notify listeners after an in-place mutation performed by an external
  /// writer (e.g. [DynamicStyleService.repackInto], which writes directly to
  /// [currentPath] via an isolate).
  Future<void> notifyMutated() async {
    logger.log('$_logTag notifyMutated: external in-place write');
    await _markMutated();
    _publish();
  }

  /// Drop any user mutation and re-seed `current.2gis` from the bundled
  /// asset. Removes the mutated flag and the length marker so
  /// [_ensureCurrentFile] can re-run its first-copy path.
  Future<void> resetToBundled() async {
    logger.log('$_logTag reset: clearing current.2gis + markers');
    for (final f in [_target, _flag, _lengthMarker]) {
      if (await f.exists()) {
        await f.delete();
      }
    }
    await _ensureCurrentFile();
    _publish();
  }

  Future<void> _ensureCurrentFile() async {
    final data = await rootBundle.load(MapnessConstants.mapStylesPath);
    final assetLen = data.lengthInBytes;

    final targetExists = await _target.exists();
    final flagExists = await _flag.exists();
    final markerText = await _lengthMarker.exists() ? await _lengthMarker.readAsString() : null;

    if (!targetExists) {
      // First install (or file was manually deleted) — copy fresh from asset.
      await _copyBundled(data, assetLen);
      if (flagExists) {
        // Stale mutation flag without an actual file — clear it.
        await _flag.delete();
      }
      return;
    }
    if (flagExists) {
      // User mutation — keep it, even if the bundled asset has changed.
      logger.log('$_logTag ensure: user mutation persisted, keeping current.2gis');
      return;
    }
    if (markerText != '$assetLen') {
      // Bundled asset changed on app update — refresh.
      logger.log('$_logTag ensure: bundle changed (marker=$markerText, asset=$assetLen), refreshing');
      await _copyBundled(data, assetLen);
      return;
    }
    logger.log('$_logTag ensure: current.2gis up to date (${assetLen}B)');
  }

  Future<void> _copyBundled(ByteData data, int assetLen) async {
    final bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    final tmp = File('${_target.path}.tmp');
    await tmp.writeAsBytes(bytes);
    await tmp.rename(_target.path);
    await _lengthMarker.writeAsString('$assetLen');
    logger.log('$_logTag ensure: copied bundled asset (${assetLen}B) → ${_target.path}');
  }

  Future<void> _markMutated() async {
    if (!await _flag.exists()) {
      await _flag.writeAsString(DateTime.now().toIso8601String());
    }
  }

  void _publish() {
    final current = state.value;
    if (current != null) {
      state = AsyncData(current.bumped());
    }
  }
}
