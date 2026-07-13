import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

const _logTag = '[dynamic_style]';

/// Override for a single entry inside the `styles.2gis` archive.
///
/// [archivePath] keeps its original case and slashes — the compiled
/// `styles.zss` references models by exact path, so the filename must stay the
/// same (only the bytes change). Examples:
///   - `zmap/vidoc/models/day_LIGHT_THEME_CAR_MODEL.glb`
///   - `zenith_dynamic_models/foot_marker.zbm`
@immutable
class StyleEntryOverride {
  const StyleEntryOverride({
    required this.archivePath,
    required this.bytes,
  });

  final String archivePath;
  final Uint8List bytes;
}

/// Repack + network primitives around the `styles.2gis` archive.
///
/// Stateless file→file pipe: [repackInto] reads [sourcePath], applies
/// overrides, and writes the result to [targetPath] atomically. The two
/// paths must differ — same-path writes would defeat the SDK-cache
/// workaround (see [MapStyleStore]). [downloadStyleBytes] returns raw bytes.
///
/// The bundled asset is owned exclusively by [MapStyleStore] — this service
/// never touches [rootBundle]. Callers that want a clean "from bundled" repack
/// must call [MapStyleStore.resetToBundled] first, so a single asset key
/// exists in the whole feature.
class DynamicStyleService {
  const DynamicStyleService();

  /// Read the archive at [sourcePath], apply [overrides], and write the
  /// result atomically to [targetPath].
  ///
  /// Overrides accumulate across repacks because [sourcePath] is normally the
  /// store's latest rotation. To drop previous mutations first, callers must
  /// call [MapStyleStore.resetToBundled] before this method.
  ///
  /// [renameSuffix] is appended to every overridden entry's basename inside
  /// the archive (e.g. `day_LIGHT_THEME_CAR_MODEL.glb` →
  /// `day_LIGHT_THEME_CAR_MODEL_v42.glb`) and the matching references inside
  /// `zmap/vidoc/zss/styles.zss` are rewritten in lockstep. This is the actual
  /// SDK-cache-bust: the 2GIS runtime (12.8.0) caches decoded GLB resources by
  /// their archive-internal path, so a fresh basename is required on every
  /// swap. Pass a monotonically increasing value (usually
  /// `MapStyleStore.nextRevision`).
  Future<void> repackInto({
    required String sourcePath,
    required String targetPath,
    required List<StyleEntryOverride> overrides,
    required int renameSuffix,
  }) async {
    final sw = Stopwatch()..start();
    final overrideSummary = overrides.map((o) => '${o.archivePath} (${o.bytes.length}B)').join(', ');
    logger.log(
      '$_logTag repack: start, ${overrides.length} override(s) suffix=_v$renameSuffix '
      '$sourcePath → $targetPath: $overrideSummary',
    );

    if (sourcePath == targetPath) {
      throw StateError('repackInto requires distinct sourcePath and targetPath (both = $targetPath)');
    }
    final srcFile = File(sourcePath);
    if (!await srcFile.exists()) {
      throw StateError('Style file not found at $sourcePath — did MapStyleStore.build() run?');
    }
    final source = await srcFile.readAsBytes();
    logger.log('$_logTag repack: read source ${source.length}B in ${sw.elapsedMilliseconds}ms');

    // Do everything in the isolate — including writing the file. Returning a
    // 10 MB Uint8List back to the main isolate and then doing writeAsBytes on
    // the UI thread caused multi-second hangs on Android emulators (fsync on
    // slow IO, plus SQLite contention from other plugins). Now the main
    // isolate only awaits a small log payload.
    final result = await compute(
      _repackInIsolate,
      _RepackInput(
        source: source,
        overrides: overrides,
        targetPath: targetPath,
        renameSuffix: renameSuffix,
      ),
    );
    for (final line in result.logs) {
      logger.log(line);
    }
    sw.stop();
    logger.log('$_logTag repack: done in ${sw.elapsedMilliseconds}ms → $targetPath');
  }

  /// Download a compiled `.2gis` from [url] and return its raw bytes.
  ///
  /// The caller (typically the store) is responsible for writing the bytes
  /// atomically to `current.2gis` — this method has no file-system side
  /// effects.
  Future<Uint8List> downloadStyleBytes(String url) async {
    final sw = Stopwatch()..start();
    logger.log('$_logTag download: GET $url');

    final dio = Dio(
      BaseOptions(connectTimeout: const Duration(seconds: 30), receiveTimeout: const Duration(seconds: 60)),
    );
    final Response<List<int>> response;
    try {
      response = await dio.get<List<int>>(url, options: Options(responseType: ResponseType.bytes));
    } finally {
      dio.close(force: true);
    }

    final data = response.data;
    if (response.statusCode != 200 || data == null || data.isEmpty) {
      throw StateError('Download failed: HTTP ${response.statusCode}, ${data?.length ?? 0}B from $url');
    }
    final bytes = Uint8List.fromList(data);
    logger.log('$_logTag download: ${bytes.length}B in ${sw.elapsedMilliseconds}ms');

    // Sanity-check the payload magic. Bundled `.2gis` archives are ZIP
    // (magic `PK` = 0x50 0x4B); some server-generated ones use the native
    // 2GIS magic (`2GIS` = 0x32 0x47 0x49 0x53). Anything else is almost
    // certainly HTML/JSON error page, not a style archive.
    final looksZip = bytes.length > 2 && bytes[0] == 0x50 && bytes[1] == 0x4B;
    final looksNative =
        bytes.length > 4 && bytes[0] == 0x32 && bytes[1] == 0x47 && bytes[2] == 0x49 && bytes[3] == 0x53;
    if (!looksZip && !looksNative) {
      logger.log('$_logTag download: WARNING payload magic is not PK/2GIS — not a .2gis?');
    }
    sw.stop();
    return bytes;
  }
}

class _RepackInput {
  const _RepackInput({
    required this.source,
    required this.overrides,
    required this.targetPath,
    required this.renameSuffix,
  });
  final Uint8List source;
  final List<StyleEntryOverride> overrides;
  final String targetPath;
  final int renameSuffix;
}

/// Basename-only paths inside the archive that carry `model_filename` refs to
/// override targets and must be text-patched in lockstep with the entry
/// renames. Both are pure-text DSL (`model_filename: "<name>.glb";`).
const _kZssPatchPaths = {
  'zmap/vidoc/zss/styles.zss',
  'zmap/vidoc/zss/labeling_animation.zss',
};

/// Split an archive path into `(prefixWithSlash, basename)`. Basename never
/// contains a slash. Used by [_renameBasename] to keep the directory intact
/// while mutating just the file component.
List<String> _splitPath(String archivePath) {
  final slash = archivePath.lastIndexOf('/');
  if (slash < 0) {
    return ['', archivePath];
  }
  return [archivePath.substring(0, slash + 1), archivePath.substring(slash + 1)];
}

/// Rename `<stem>.<ext>` to `<stem>_v<suffix>.<ext>`. Files without an
/// extension get the suffix appended verbatim. The prefix is preserved so
/// `zmap/vidoc/models/day.glb` becomes `zmap/vidoc/models/day_v42.glb`, which
/// is what the zss text-patch is expecting.
String _renameBasename(String archivePath, int suffix) {
  final parts = _splitPath(archivePath);
  final basename = parts[1];
  final dot = basename.lastIndexOf('.');
  final stem = dot > 0 ? basename.substring(0, dot) : basename;
  final ext = dot > 0 ? basename.substring(dot) : '';
  return '${parts[0]}${stem}_v$suffix$ext';
}

final _kVersionSuffix = RegExp(r'_v\d+$');

/// Strip a trailing `_v<N>` from an archive path's stem, if present. Prefix
/// and extension are preserved. This gives every override a stable canonical
/// key even after prior repacks renamed the on-disk entry with a suffix — so
/// the second and later swaps in a session still match.
String _canonicalPath(String archivePath) {
  final parts = _splitPath(archivePath);
  final basename = parts[1];
  final dot = basename.lastIndexOf('.');
  final stem = dot > 0 ? basename.substring(0, dot) : basename;
  final ext = dot > 0 ? basename.substring(dot) : '';
  final match = _kVersionSuffix.firstMatch(stem);
  final canonicalStem = match != null ? stem.substring(0, match.start) : stem;
  return '${parts[0]}$canonicalStem$ext';
}

class _RepackResult {
  const _RepackResult({required this.logs});

  /// Diagnostic lines produced inside the isolate, flushed into the app
  /// logger by [DynamicStyleService.repackInto] once the isolate returns.
  final List<String> logs;
}

Future<_RepackResult> _repackInIsolate(_RepackInput input) async {
  final sw = Stopwatch()..start();
  final logs = <String>['$_logTag isolate: start (source ${input.source.length}B, suffix=_v${input.renameSuffix})'];

  final archive = ZipDecoder().decodeBytes(input.source);
  logs.add('$_logTag isolate: decoded ${archive.files.length} entries in ${sw.elapsedMilliseconds}ms');

  // Per-override, keyed by canonical archive path (no `_v<N>` suffix). Prior
  // repacks in this session may have renamed on-disk entries to `_v1`,
  // `_v2`, …; a second swap still arrives with the canonical override path,
  // so we normalise both sides before matching. Rename targets are computed
  // once from the canonical key + the current suffix.
  final overrideBytes = <String, Uint8List>{
    for (final o in input.overrides) _canonicalPath(o.archivePath): o.bytes,
  };
  final renameMap = <String, String>{
    for (final o in input.overrides)
      _canonicalPath(o.archivePath): _renameBasename(_canonicalPath(o.archivePath), input.renameSuffix),
  };
  final unmatched = overrideBytes.keys.toSet();
  final replaced = <String>[];
  final rebuilt = Archive();

  for (final file in archive.files) {
    if (!file.isFile) {
      rebuilt.addFile(file);
      continue;
    }
    final canonicalName = _canonicalPath(file.name);
    final replacement = overrideBytes[canonicalName];
    if (replacement != null) {
      unmatched.remove(canonicalName);
      final newName = renameMap[canonicalName]!;
      replaced.add('${file.name} → $newName (${file.size}B → ${replacement.length}B)');
      final entry = ArchiveFile.bytes(newName, replacement)
        ..mode = file.mode
        ..lastModTime = file.lastModTime
        ..compression = CompressionType.none;
      rebuilt.addFile(entry);
      continue;
    }
    // Non-override entry.
    //
    // Re-add uncompressed: pure-Dart deflate of the whole ~5 MB archive
    // (hundreds of entries) takes minutes on-device, which looks like a
    // hang. The 2GIS SDK reads stored zip entries fine, so we trade a
    // larger on-disk file for an effectively instant repack. readBytes()
    // returns the inflated content — inflate is cheap; it's deflate on
    // re-encode that was the bottleneck.
    final rawContent = file.readBytes() ?? const <int>[];
    final Uint8List content;
    if (_kZssPatchPaths.contains(file.name)) {
      // Rewrite every model reference in the zss DSL. On a repeated swap the
      // zss already refers to `stem_v1.glb` (from the previous session
      // repack); the regex catches both the original `stem.glb` and any
      // prior `stem_v\d+.glb` and rewrites them to `stem_v<renameSuffix>.glb`.
      //
      // Zss files are plain-text ASCII DSL. latin1 round-trip is 1:1 on
      // bytes so we never risk mangling non-ASCII content that might live
      // elsewhere in the payload.
      final rawBytes = rawContent is Uint8List ? rawContent : Uint8List.fromList(rawContent);
      var patchedStr = latin1.decode(rawBytes);
      final patchLog = <String>[];
      for (final e in renameMap.entries) {
        final origBasename = _splitPath(e.key)[1];
        final newBasename = _splitPath(e.value)[1];
        final dot = origBasename.lastIndexOf('.');
        final stem = dot > 0 ? origBasename.substring(0, dot) : origBasename;
        final ext = dot > 0 ? origBasename.substring(dot) : '';
        final pattern = RegExp('${RegExp.escape(stem)}(?:_v\\d+)?${RegExp.escape(ext)}');
        final hits = pattern.allMatches(patchedStr).length;
        if (hits > 0) {
          patchedStr = patchedStr.replaceAll(pattern, newBasename);
          patchLog.add('$origBasename×$hits');
        }
      }
      content = Uint8List.fromList(latin1.encode(patchedStr));
      if (patchLog.isNotEmpty) {
        logs.add('$_logTag isolate: patched ${file.name} refs [${patchLog.join(', ')}]');
      }
    } else {
      content = rawContent is Uint8List ? rawContent : Uint8List.fromList(rawContent);
    }
    final entry = ArchiveFile.bytes(file.name, content)
      ..mode = file.mode
      ..lastModTime = file.lastModTime
      ..compression = CompressionType.none;
    rebuilt.addFile(entry);
  }
  logs.add(
    '$_logTag isolate: replaced ${replaced.length} entr(ies) [${replaced.join('; ')}] at ${sw.elapsedMilliseconds}ms',
  );

  if (unmatched.isNotEmpty) {
    // Not every style ships every slot (e.g. some archives have day but no
    // night car model). Skip missing entries instead of failing — the styles
    // that do exist still get replaced.
    logs.add('$_logTag isolate: WARNING overrides not present in archive, skipped: ${unmatched.join(', ')}');
  }

  final bytes = ZipEncoder().encodeBytes(rebuilt);
  logs.add('$_logTag isolate: encoded ${bytes.length}B (store) in ${sw.elapsedMilliseconds}ms');

  // Write atomically — no fsync. The atomic rename guarantees readers
  // never see a half-written file, and durability is not required (the
  // store can always re-seed from the bundled asset).
  final tmp = File('${input.targetPath}.tmp');
  await tmp.writeAsBytes(bytes);
  await tmp.rename(input.targetPath);
  logs.add('$_logTag isolate: wrote ${input.targetPath} at ${sw.elapsedMilliseconds}ms');
  sw.stop();

  return _RepackResult(logs: logs);
}
