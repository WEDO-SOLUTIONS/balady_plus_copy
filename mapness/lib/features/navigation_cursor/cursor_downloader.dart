import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:mapness/features/navigation_cursor/navigation_cursor.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cursor_downloader.g.dart';

const _logTag = '[cursor_downloader]';

/// glTF binary magic (`glTF`): every valid GLB starts with these four bytes.
/// See https://registry.khronos.org/glTF/specs/2.0/glTF-2.0.html#binary-header
const List<int> _kGlbMagic = <int>[0x67, 0x6C, 0x54, 0x46];

/// Downloads GLB car models from the OCI bucket and stores them under the
/// app's Application Support directory. Also tracks in-flight downloads so
/// two rapid taps on the same cursor coalesce into one HTTP request.
///
/// This is a plain service — persistence of *which* cursor is active lives
/// in [NavigationCursorController]; here we only own the bytes on disk.
@Riverpod(keepAlive: true)
CursorDownloader cursorDownloader(Ref ref) => CursorDownloader();

class CursorDownloader {
  CursorDownloader({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;
  final Map<NavigationCursor, Future<File>> _inFlight = <NavigationCursor, Future<File>>{};
  Directory? _cachedDir;

  /// Root of the on-disk cursor cache. Lazy — resolved on first use so tests
  /// can override [path_provider] via [PathProviderPlatform] without a boot
  /// hook.
  Future<Directory> _dir() async {
    final cached = _cachedDir;
    if (cached != null) {
      return cached;
    }
    final base = await getApplicationSupportDirectory();
    final dir = Directory('${base.path}/cursors');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    _cachedDir = dir;
    return dir;
  }

  /// Absolute path of [cursor]'s GLB on disk (may not exist yet).
  Future<File> localFile(NavigationCursor cursor) async {
    if (!cursor.requiresDownload) {
      throw StateError('localFile called on bundled cursor ${cursor.id}');
    }
    final dir = await _dir();
    return File('${dir.path}/${cursor.id}.glb');
  }

  /// True when [cursor] already has a non-empty GLB on disk. Fast check —
  /// only stats the file, does not read magic bytes.
  Future<bool> isDownloaded(NavigationCursor cursor) async {
    if (!cursor.requiresDownload) {
      return true;
    }
    final file = await localFile(cursor);
    if (!await file.exists()) {
      return false;
    }
    final stat = await file.stat();
    return stat.size > 0;
  }

  /// IDs of every cursor whose GLB is on disk. Used by
  /// [NavigationCursorController.build] to reconcile SharedPreferences with
  /// reality after an app reinstall/clear-cache.
  Future<Set<String>> downloadedIds() async {
    final ids = <String>{};
    for (final cursor in NavigationCursor.values) {
      if (await isDownloaded(cursor)) {
        ids.add(cursor.id);
      }
    }
    return ids;
  }

  /// Download [cursor]'s GLB and return its local [File]. If already cached
  /// on disk, returns immediately without a network hit. Concurrent calls
  /// for the same cursor share one HTTP request.
  Future<File> download(NavigationCursor cursor) {
    if (!cursor.requiresDownload) {
      throw ArgumentError('Cannot download bundled cursor ${cursor.id}');
    }
    return _inFlight.putIfAbsent(cursor, () => _run(cursor)).whenComplete(() => _inFlight.remove(cursor));
  }

  Future<File> _run(NavigationCursor cursor) async {
    final file = await localFile(cursor);
    if (await isDownloaded(cursor)) {
      logger.log('$_logTag ${cursor.id}: cache hit ${file.path}');
      return file;
    }
    final url = '$kCursorCdnBaseUrl${cursor.cdnFileName}';
    final tmp = File('${file.path}.tmp');
    final sw = Stopwatch()..start();
    logger.log('$_logTag ${cursor.id}: GET $url');
    try {
      final response = await _dio
          .download(
            url,
            tmp.path,
            options: Options(
              responseType: ResponseType.bytes,
              // Without explicit timeouts dio waits forever when the device
              // is offline — the picker spinner then never clears and the
              // user sees it as "just a loader". 20s is long enough for
              // real Saudi 3G, short enough that a permanent outage
              // surfaces as an error snackbar before the user gives up.
              sendTimeout: const Duration(seconds: 30),
              receiveTimeout: const Duration(seconds: 60),
            ),
          )
          .timeout(
            const Duration(seconds: 20),
            onTimeout: () =>
                throw TimeoutException('Connect timeout — check your internet connection', const Duration(seconds: 20)),
          );
      if (response.statusCode != 200) {
        throw StateError('HTTP ${response.statusCode} for $url');
      }
      final head = await _readHead(tmp);
      if (!_isGlbHead(head)) {
        await tmp.delete();
        throw StateError('Downloaded payload is not a valid GLB (magic=${_formatMagic(head)})');
      }
      await tmp.rename(file.path);
      sw.stop();
      logger.log('$_logTag ${cursor.id}: saved ${file.path} (${await file.length()}B) in ${sw.elapsedMilliseconds}ms');
      return file;
    } catch (e) {
      sw.stop();
      if (await tmp.exists()) {
        try {
          await tmp.delete();
        } catch (_) {}
      }
      logger.log(
        '$_logTag ${cursor.id}: FAILED after ${sw.elapsedMilliseconds}ms: $e',
        logLevel: MapnessLogLevel.error,
      );
      rethrow;
    }
  }

  Future<Uint8List> _readHead(File file) async {
    final handle = await file.open();
    try {
      final bytes = await handle.read(_kGlbMagic.length);
      return bytes;
    } finally {
      await handle.close();
    }
  }

  bool _isGlbHead(Uint8List head) {
    if (head.length < _kGlbMagic.length) {
      return false;
    }
    for (var i = 0; i < _kGlbMagic.length; i++) {
      if (head[i] != _kGlbMagic[i]) {
        return false;
      }
    }
    return true;
  }

  String _formatMagic(Uint8List head) => head.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ');
}
