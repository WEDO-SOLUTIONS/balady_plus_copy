import 'dart:async';
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
/// Stateless file→file pipe: [repackInto] reads the current on-disk archive
/// at [targetPath], applies overrides, and writes the result back to the same
/// path atomically. [downloadStyleBytes] returns raw bytes.
///
/// The bundled asset is owned exclusively by [MapStyleStore] — this service
/// never touches [rootBundle]. Callers that want a clean "from bundled" repack
/// must call [MapStyleStore.resetToBundled] first, so a single asset key
/// exists in the whole feature.
class DynamicStyleService {
  const DynamicStyleService();

  /// Repack the archive at [targetPath] with [overrides] and atomically
  /// overwrite it in place.
  ///
  /// Reads the current on-disk archive (not the bundled asset), so overrides
  /// accumulate: `apply(X)` then `apply(Y)` results in both X and Y present.
  /// To drop previous mutations first, callers must call
  /// [MapStyleStore.resetToBundled] before this method.
  Future<void> repackInto({
    required String targetPath,
    required List<StyleEntryOverride> overrides,
  }) async {
    final sw = Stopwatch()..start();
    final overrideSummary = overrides.map((o) => '${o.archivePath} (${o.bytes.length}B)').join(', ');
    logger.log('$_logTag repack: start, ${overrides.length} override(s) → $targetPath: $overrideSummary');

    final srcFile = File(targetPath);
    if (!await srcFile.exists()) {
      throw StateError('Style file not found at $targetPath — did MapStyleStore.build() run?');
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
      _RepackInput(source: source, overrides: overrides, targetPath: targetPath),
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
  const _RepackInput({required this.source, required this.overrides, required this.targetPath});
  final Uint8List source;
  final List<StyleEntryOverride> overrides;
  final String targetPath;
}

class _RepackResult {
  const _RepackResult({required this.logs});

  /// Diagnostic lines produced inside the isolate, flushed into the app
  /// logger by [DynamicStyleService.repackInto] once the isolate returns.
  final List<String> logs;
}

Future<_RepackResult> _repackInIsolate(_RepackInput input) async {
  final sw = Stopwatch()..start();
  final logs = <String>['$_logTag isolate: start (source ${input.source.length}B)'];

  final archive = ZipDecoder().decodeBytes(input.source);
  logs.add('$_logTag isolate: decoded ${archive.files.length} entries in ${sw.elapsedMilliseconds}ms');

  final overrides = {
    for (final o in input.overrides) o.archivePath: o.bytes,
  };
  final unmatched = overrides.keys.toSet();
  final replaced = <String>[];
  final rebuilt = Archive();

  for (final file in archive.files) {
    if (!file.isFile) {
      rebuilt.addFile(file);
      continue;
    }
    final replacement = overrides[file.name];
    if (replacement == null) {
      // Re-add the original entry uncompressed: pure-Dart deflate of the
      // whole ~5 MB archive (hundreds of entries) takes minutes on-device,
      // which looks like a hang. The 2GIS SDK reads stored zip entries
      // fine, so we trade a larger on-disk file for an effectively instant
      // repack. readBytes() returns the inflated content — inflate is
      // cheap; it's deflate on re-encode that was the bottleneck.
      final content = file.readBytes();
      final entry = ArchiveFile.bytes(file.name, content ?? const <int>[])
        ..mode = file.mode
        ..lastModTime = file.lastModTime
        ..compression = CompressionType.none;
      rebuilt.addFile(entry);
      continue;
    }
    unmatched.remove(file.name);
    replaced.add('${file.name}: ${file.size}B → ${replacement.length}B');
    final entry = ArchiveFile.bytes(file.name, replacement)
      ..mode = file.mode
      ..lastModTime = file.lastModTime
      ..compression = CompressionType.none;
    rebuilt.addFile(entry);
  }
  logs.add(
    '$_logTag isolate: replaced ${replaced.length} entr(ies) [${replaced.join('; ')}] at ${sw.elapsedMilliseconds}ms',
  );

  if (unmatched.isNotEmpty) {
    logs.add('$_logTag isolate: ERROR overrides not found: ${unmatched.join(', ')}');
    throw StateError('Style overrides not found in archive: ${unmatched.join(', ')}');
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
