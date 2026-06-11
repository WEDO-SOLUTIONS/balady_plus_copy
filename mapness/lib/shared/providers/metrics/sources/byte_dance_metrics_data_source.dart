import 'package:flutter/material.dart';
import 'package:mapness/entities/metrics/events/metrics_event.dart';
import 'package:mapness/entities/metrics/metrics_data_source.dart';

class ByteDanceMetricsDataSource implements MetricsDataSource {
  @override
  Future<void> sendEvent(MetricsEvent event) async {
    debugPrint('ByteDanceMetricsDataSource.sendEvent: $event');
    // TODO: implement handleEvent
  }
}
