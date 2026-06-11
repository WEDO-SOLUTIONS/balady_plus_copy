import 'package:mapness/entities/metrics/events/metrics_event.dart';

abstract interface class MetricsDataSource {
  Future<void> sendEvent(MetricsEvent event);
}
