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
/// [path] changes on every mutation because the 2GIS SDK (12.8.0) caches
/// decoded resources by archive-path and re-loading the same absolute path
/// does not force a re-read — see [MapStyleStore]. [revision] mirrors the
/// numeric suffix inside [path] and monotonically increases.
@immutable
class StyleFile {
  const StyleFile({required this.path, required this.revision});

  final String path;
  final int revision;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is StyleFile && other.path == path && other.revision == revision;

  @override
  int get hashCode => Object.hash(path, revision);

  @override
  String toString() => 'StyleFile(path=$path, rev=$revision)';
}

/// Owns the canonical `.2gis` file that the 2GIS SDK loads.
///
/// Design:
/// * The rotating filename is `current-<N>.2gis`. Every mutation writes to
///   the next N and then hands the SDK the new absolute path. This is a
///   workaround for a 2GIS SDK 12.8.0 limitation: `loadStylesFromPath` on
///   the same absolute path returns cached decoded resources (in particular
///   GLB car models keyed by internal archive path like
///   `zmap/vidoc/models/day_LIGHT_THEME_CAR_MODEL.glb`). No public
///   invalidate/unload API exists, so we force a fresh identity on-disk.
/// * On first build the bundled asset ([MapnessConstants.mapStylesPath]) is
///   copied to `current-0.2gis`. On subsequent boots the highest-N file is
///   picked up.
/// * The SDK is **always** handed the same absolute file path — never an
///   asset key.
/// * Mutations (repack, network download, file picker) allocate the next
///   filename, write it atomically, then bump state. The previous file is
///   deleted once the swap is committed.
/// * A [_mutatedFlag] file marks the archive as user-mutated so app updates
///   that ship a new bundled asset do not clobber it. Reset explicitly
///   clears every rotated file plus the flag and marker.
@Riverpod(keepAlive: true)
class MapStyleStore extends _$MapStyleStore {
  static const _fileNamePrefix = 'current-';
  static const _fileNameSuffix = '.2gis';

  /// Sidecar file storing the bundled asset's byte length that was used on
  /// the last copy. Used to detect app updates that ship a new bundled asset.
  static const _bundleLengthMarker = 'bundle_length.txt';

  /// Sentinel file that, when present, signals the current rotated file
  /// holds a user-mutated archive. Kept across app updates until explicit
  /// reset.
  static const _mutatedFlag = 'mutated.flag';

  late final Directory _dir;
  late final File _lengthMarker;
  late final File _flag;
  int _revision = 0;
  late File _target;

  @override
  Future<StyleFile> build() async {
    final sw = Stopwatch()..start();
    final base = await getApplicationSupportDirectory();
    _dir = Directory('${base.path}/map_styles');
    if (!await _dir.exists()) {
      await _dir.create(recursive: true);
    }
    _lengthMarker = File('${_dir.path}/$_bundleLengthMarker');
    _flag = File('${_dir.path}/$_mutatedFlag');

    // Pick up the highest existing rotation on boot; delete any stragglers.
    _revision = await _collectRevisions(deleteAllButLatest: true);
    _target = _pathForRevision(_revision);

    await _ensureCurrentFile();
    logger.log('$_logTag ready at ${_target.path} rev=$_revision in ${sw.elapsedMilliseconds}ms');
    return StyleFile(path: _target.path, revision: _revision);
  }

  /// Absolute path of the currently-live style file.
  String get currentPath => _target.path;

  /// Absolute path allocated for the next mutation. Callers that write
  /// externally (e.g. [DynamicStyleService.repackInto]) target this path and
  /// then call [publishExternallyWritten] to commit.
  ///
  /// Idempotent: repeated calls without a commit return the same path.
  String allocateNextPath() => _pathForRevision(_revision + 1).path;

  /// Revision number that will be assigned to the next mutation. Used by the
  /// repack service as a suffix when renaming overridden entries inside the
  /// archive (see [DynamicStyleService.repackInto]) so the SDK's per-name GLB
  /// cache misses on each swap.
  int get nextRevision => _revision + 1;

  /// Commit a mutation written externally to [newPath]. [newPath] must equal
  /// the value returned by the most recent [allocateNextPath] call.
  Future<void> publishExternallyWritten(String newPath) async {
    final expected = allocateNextPath();
    if (newPath != expected) {
      throw StateError('publishExternallyWritten: got $newPath, expected $expected');
    }
    logger.log('$_logTag publishExternallyWritten: $newPath');
    await _swapTargetTo(File(newPath));
    await _markMutated();
  }

  /// Replace the current file with an in-memory blob. Writes to the next
  /// rotation slot atomically, then commits.
  Future<void> replaceWithBytes(Uint8List bytes) async {
    logger.log('$_logTag replaceWithBytes: ${bytes.length}B');
    final next = _pathForRevision(_revision + 1);
    final tmp = File('${next.path}.tmp');
    await tmp.writeAsBytes(bytes);
    await tmp.rename(next.path);
    await _swapTargetTo(next);
    await _markMutated();
  }

  /// Copy an existing file into the next rotation slot and commit. The
  /// source at [srcPath] is left untouched.
  Future<void> replaceWithFile(String srcPath) async {
    final src = File(srcPath);
    if (!await src.exists()) {
      throw StateError('Source style file not found: $srcPath');
    }
    logger.log('$_logTag replaceWithFile: $srcPath (${await src.length()}B)');
    final next = _pathForRevision(_revision + 1);
    await src.copy(next.path);
    await _swapTargetTo(next);
    await _markMutated();
  }

  /// Drop any user mutation, delete every rotated file, and re-seed
  /// `current-0.2gis` from the bundled asset.
  Future<void> resetToBundled() async {
    logger.log('$_logTag reset: clearing rotated files + markers');
    if (await _dir.exists()) {
      await for (final entity in _dir.list()) {
        if (entity is! File) {
          continue;
        }
        final name = _basename(entity.path);
        if (name.startsWith(_fileNamePrefix) && name.endsWith(_fileNameSuffix)) {
          try {
            await entity.delete();
          } catch (e) {
            logger.log('$_logTag reset: failed to delete ${entity.path}: $e');
          }
        }
      }
    }
    for (final f in [_flag, _lengthMarker]) {
      if (await f.exists()) {
        await f.delete();
      }
    }
    _revision = 0;
    _target = _pathForRevision(_revision);
    await _ensureCurrentFile();
    _publish();
  }

  File _pathForRevision(int rev) => File('${_dir.path}/$_fileNamePrefix$rev$_fileNameSuffix');

  String _basename(String path) => path.split(Platform.pathSeparator).last;

  /// Scan the directory for `current-<N>.2gis` files. If [deleteAllButLatest]
  /// is true, keeps the highest N and deletes the rest. Returns the highest
  /// N found (or 0 if none).
  Future<int> _collectRevisions({required bool deleteAllButLatest}) async {
    if (!await _dir.exists()) {
      return 0;
    }
    final revs = <int, File>{};
    await for (final entity in _dir.list()) {
      if (entity is! File) {
        continue;
      }
      final name = _basename(entity.path);
      if (!name.startsWith(_fileNamePrefix) || !name.endsWith(_fileNameSuffix)) {
        continue;
      }
      final numPart = name.substring(_fileNamePrefix.length, name.length - _fileNameSuffix.length);
      final n = int.tryParse(numPart);
      if (n != null) {
        revs[n] = entity;
      }
    }
    if (revs.isEmpty) {
      return 0;
    }
    final highest = revs.keys.reduce((a, b) => a > b ? a : b);
    if (deleteAllButLatest) {
      for (final entry in revs.entries) {
        if (entry.key == highest) {
          continue;
        }
        try {
          await entry.value.delete();
          logger.log('$_logTag pruned stray ${entry.value.path}');
        } catch (e) {
          logger.log('$_logTag failed to prune ${entry.value.path}: $e');
        }
      }
    }
    return highest;
  }

  Future<void> _swapTargetTo(File newTarget) async {
    final oldTarget = _target;
    _target = newTarget;
    _revision += 1;
    _publish();
    if (oldTarget.path != newTarget.path && await oldTarget.exists()) {
      try {
        await oldTarget.delete();
      } catch (e) {
        logger.log('$_logTag warn: failed to delete old file ${oldTarget.path}: $e');
      }
    }
  }

  Future<void> _ensureCurrentFile() async {
    final data = await rootBundle.load(MapnessConstants.mapStylesPath);
    final assetLen = data.lengthInBytes;

    final targetExists = await _target.exists();
    final flagExists = await _flag.exists();
    final markerText = await _lengthMarker.exists() ? await _lengthMarker.readAsString() : null;

    if (!targetExists) {
      await _copyBundled(data, assetLen);
      if (flagExists) {
        // Stale mutation flag without an actual file — clear it.
        await _flag.delete();
      }
      return;
    }
    if (flagExists) {
      // User mutation — keep it, even if the bundled asset has changed.
      logger.log('$_logTag ensure: user mutation persisted, keeping ${_target.path}');
      return;
    }
    if (markerText != '$assetLen') {
      // Bundled asset changed on app update — refresh.
      logger.log('$_logTag ensure: bundle changed (marker=$markerText, asset=$assetLen), refreshing');
      await _copyBundled(data, assetLen);
      return;
    }
    logger.log('$_logTag ensure: ${_target.path} up to date (${assetLen}B)');
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
    state = AsyncData(StyleFile(path: _target.path, revision: _revision));
  }
}
