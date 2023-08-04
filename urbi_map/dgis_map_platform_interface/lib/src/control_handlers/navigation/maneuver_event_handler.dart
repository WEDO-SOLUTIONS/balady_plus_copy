import 'dart:async';
import 'dart:math';

import '../../events/navi_maneuver_event.dart';

class ManeuverEventHandler {
  Stream<NaviManeuverEvent> get maneuverEvents => _controller.stream;

  final _controller = StreamController<NaviManeuverEvent>();

  void handleManeuverEvent(Map<dynamic, dynamic> map) {
    switch (map['type']) {
      case "nextHidden":
        return _controller.sink.add(const ManeuverEventHidden());
      case "nextManeuver":
        if (map['distance'] == null || map['unit'] == null) {
          return _controller.sink.add(const ManeuverEventHidden());
        }

        final formattedDistance = formatMeters(map['distance']);
        return _controller.sink.add(ManeuverEvent(
          distance: formattedDistance.value,
          unit: formattedDistance.unit,
          roadName: map['roadName'],
          instruction: ManeuverInstruction.fromString(map['instruction']),
        ));
    }
  }

  void handleAdditionalManeuverEvent(Map<dynamic, dynamic> map) {
    switch (map['type']) {
      case "additionalHide":
        return _controller.sink.add(const ManeuverAdditionalEventHidden());
      case "additionalExitName":
        return _controller.sink.add(ManeuverAdditionalEventExit(map['value']));
      case "additionalIconWithText":
        return _controller.sink.add(
          ManeuverAdditionalEventWithIcon(ManeuverInstruction.fromString(map['value'])),
        );
    }
  }

  Future<void> dispose() {
    return _controller.close();
  }

  FormattedMeasure formatMeters(int millis) {
    final meters = millis / 1000;
    if (meters > 3000) {
      // Показываем в километрах с точностью до целых
      final kilometers = (meters / 1000).floor();
      return FormattedMeasure(kilometers.toString(), "km");
    }

    if (meters > 1000) {
      // Показываем в километрах с точностью до одного десятичного знака
      final hundredsOfMeters = (meters / 100).floor();
      final distanceKm = (hundredsOfMeters / 10).floor();
      return FormattedMeasure(distanceKm.floor().toString(), "km");
    }

    if (meters > 500) {
      // Показываем с точностью до 100 м
      final hundredsOfMeters = (meters / 100).floor();
      final distanceM = hundredsOfMeters * 100;
      return FormattedMeasure(distanceM.floor().toString(), "m");
    }

    if (meters > 250) {
      // Показываем с точностью до 50 м
      final fiftiesOfMeters = (meters / 50).floor();
      final distanceM = fiftiesOfMeters * 50;
      return FormattedMeasure(distanceM.floor().toString(), "m");
    }

    if (meters == 0) {
      return FormattedMeasure("0", "m");
    }

    // Показываем с точностью до 10 м
    final tensOfMeters = max(1, meters / 10).floor();
    final distanceM = tensOfMeters * 10;
    return FormattedMeasure(distanceM.floor().toString(), "m");
  }
}

class FormattedMeasure {
  FormattedMeasure(this.value, this.unit);

  final String value;
  final String unit;
}
