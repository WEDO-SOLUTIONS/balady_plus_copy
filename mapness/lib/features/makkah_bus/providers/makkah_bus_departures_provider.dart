import 'package:mapness/entities/makkah_bus/makkah_bus_departures_model.dart';
import 'package:mapness/features/makkah_bus/makkah_bus_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'makkah_bus_departures_provider.g.dart';

@riverpod
Future<MakkahBusDeparturesResponse?> makkahBusDepartures(
  Ref ref,
  String poiId,
) => ref.watch(makkahBusRepositoryProvider.notifier).getDepartures(poiId);
