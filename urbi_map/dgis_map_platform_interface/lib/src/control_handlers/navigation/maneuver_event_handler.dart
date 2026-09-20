import 'dart:async';
import 'dart:math';

import '../../events/navi_maneuver_event.dart';

/// Turns navigation's maneuver notifications into a Dart stream, and formats
/// the distance the banner shows.
class ManeuverEventHandler {
  /// Every maneuver navigation has asked the banner to show, including the
  /// instructions to hide it.
  Stream<NaviManeuverEvent> get maneuverEvents => _controller.stream;

  final _controller = StreamController<NaviManeuverEvent>();

  /// Decodes the main maneuver off the platform channel and publishes it on
  /// [maneuverEvents].
  void handleManeuverEvent(Map<dynamic, dynamic> map) {
    switch (map['type']) {
      case "nextHidden":
        return _controller.sink.add(const ManeuverEventHidden());
      case "nextManeuver":
        if (map['distance'] is! num || map['unit'] == null) {
          return _controller.sink.add(const ManeuverEventHidden());
        }

        final instruction = ManeuverInstruction.tryFromString('${map['instruction'] ?? ''}');
        if (instruction == null) {
          return _controller.sink.add(const ManeuverEventHidden());
        }
        final formattedDistance = formatMeters((map['distance'] as num).toInt());
        return _controller.sink.add(
          ManeuverEvent(
            distance: formattedDistance.value,
            unit: formattedDistance.unit,
            roadName: '${map['roadName'] ?? ''}',
            instruction: instruction,
          ),
        );
    }
  }

  /// Decodes the banner's secondary line off the platform channel and
  /// publishes it on [maneuverEvents].
  void handleAdditionalManeuverEvent(Map<dynamic, dynamic> map) {
    switch (map['type']) {
      case "additionalHide":
        return _controller.sink.add(const ManeuverAdditionalEventHidden());
      case "additionalExitName":
        // The native side sends numeric exit names (exit "12") as int; the
        // event field is String, and the implicit dynamic downcast threw on
        // every maneuver event of such an exit. Stringify instead.
        return _controller.sink.add(ManeuverAdditionalEventExit('${map['value'] ?? ''}'));
      case "additionalIconWithText":
        final instruction = ManeuverInstruction.tryFromString('${map['value'] ?? ''}');
        if (instruction == null) {
          return;
        }
        return _controller.sink.add(ManeuverAdditionalEventWithIcon(instruction));
    }
  }

  /// Closes the maneuver stream.
  Future<void> dispose() {
    return _controller.close();
  }

  /// Rounds a distance given in millimetres to what a driver can act on, and
  /// picks the unit to show it in: whole kilometres above 3 km, then 100 m
  /// steps above 500 m, 50 m steps above 250 m, and 10 m steps below that.
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

/// A distance already rounded and paired with the unit it should be shown in.
class FormattedMeasure {
  /// Creates the measure from its [value] and [unit].
  FormattedMeasure(this.value, this.unit);

  /// The number to show, already rounded.
  final String value;

  /// Unit [value] is expressed in, either "m" or "km".
  final String unit;
}
