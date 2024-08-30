import 'dart:async';

import 'package:intl/intl.dart';
import 'package:mapness/entities/path_nav/models/path_nav_eta.dart';
import 'package:mapness/features/path_nav/lib/enums.dart';
import 'package:mapness/features/path_nav/lib/number_formatters.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'path_nav_eta.g.dart';

@riverpod
class _PathNavEta extends _$PathNavEta {
  @override
  PathNavEta? build() {
    unawaited(_subscribe());

    return null;
  }

  Future<void> _subscribe() async {
    final mapController = await ref.read(dgisControllerProvider.future);
    final subspcription = mapController.naviDashboardEvents.listen((event) {
      final distance = event.distance.formatDistance();
      final duration = Duration(seconds: event.duration);
      final isExpanded = state?.isExpanded;

      state = PathNavEta(
        durationInSeconds: event.duration,
        timeEta: event.duration.formatDuration(),
        timeEtaUnits: duration >= const Duration(hours: 1) ? TimeUnits.hours : TimeUnits.min,
        distanceEta: distance.value,
        distanceEtaUnits: distance.unit,
        rawDistance: event.distance,
        arrivalTime: DateFormat.Hm().format(
          DateTime.now().add(duration),
        ),
      ).copyWith(isExpanded: isExpanded);
    });
    ref.onDispose(subspcription.cancel);
  }

  void toggleIsExpanded({required bool isExpanded}) {
    state = state?.copyWith(
      isExpanded: isExpanded,
    );
  }
}

final pathNavEtaProvider = _pathNavEtaProvider;
