import 'package:mapness/entities/bus_departures/model.dart';
import 'package:mapness/features/bus_departures/repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@riverpod
Future<BusDeparturesResponse?> busDepartures(
  Ref ref,
  String poiId,
) => ref.watch(busDeparturesRepoProvider.notifier).getDepartures(poiId);
