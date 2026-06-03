import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

part '_model.dart';
part 'metrics_logger.freezed.dart';
part 'metrics_logger.g.dart';

late final metricsLogger = _MetricsLogger().._init();

/// Debug logger to find which events are sent in the app in actual usage
class _MetricsLogger {
  final _cache = <MetricsDbDto>[];
  late final Timer _ticker;
  Completer<void>? _writeCompleter;

  // todo remove future
  Future<void> _init() async {
    _ticker = Timer.periodic(
      const Duration(seconds: 5),
      (timer) => _flush(),
    );
  }

  Future<void> sendEvent({
    required String eventType,
    required List<MetricsLoggerService> services,
    Map<String, dynamic>? payload,
    MapnessLogLevel? logLevel,
  }) async {
    // wait for pending write operation to finish to keep _cache in consistent state
    await _writeCompleter?.future;
    final metric = MetricsDbDto(
      eventType: eventType,
      services: services,
      timestamp: DateTime.now(),
      payload: payload,
      logLevel: logLevel,
    );
    _cache.add(metric);
  }

  Future<void> _flush() async {
    if (_cache.isEmpty) {
      return;
    }
    final items = List.of(_cache);
    final file = await _getFile();
    final text = items.map((e) => e.toFileString()).join('\n');

    _writeCompleter = Completer();
    try {
      await file.writeAsString(
        text,
        mode: FileMode.append,
        flush: true,
      );
      _cache.clear();
    } catch (e) {
      logger.log('failed to write metrics log to file: $e', logLevel: MapnessLogLevel.error);
    }
    _writeCompleter?.complete();
  }

  Future<void> shareFile() async {
    final file = await _getFile();
    final params = ShareParams(
      files: [XFile(file.path)],
    );

    final result = await SharePlus.instance.share(params);
  }

  Future<void> deleteFile() async {
    final file = await _getFile();
    await file.delete();
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File(join(directory.path, 'metrics.txt'));
  }

  void dispose() {
    _ticker.cancel();
  }
}
