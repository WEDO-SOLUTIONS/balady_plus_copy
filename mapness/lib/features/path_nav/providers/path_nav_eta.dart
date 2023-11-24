import 'package:intl/intl.dart';
import 'package:mapness/entities/path_nav/models/path_nav_eta.dart';
import 'package:mapness/features/path_nav/lib/number_formatters.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'path_nav_eta.g.dart';

@riverpod
class _PathNavEta extends _$PathNavEta {
  @override
  PathNavEta? build() {
    final mapController = ref.read(dgisControllerProvider)!;
    final subspcription = mapController.naviDashboardEvents.listen((event) {
      final distance = event.distance.formatDistance();
      state = PathNavEta(
        timeEta: event.duration.formatDuration(),
        timeEtaUnits: 'min',
        distanceEta: distance.value,
        distanceEtaUnits: distance.unit,
        arrivalTime: DateFormat.Hm().format(
          DateTime.now().add(Duration(seconds: event.duration)),
        ),
      );
    });
    ref.onDispose(() {
      subspcription.cancel();
    });
    return null;
  }
}

final pathNavEtaProvider = _pathNavEtaProvider;
