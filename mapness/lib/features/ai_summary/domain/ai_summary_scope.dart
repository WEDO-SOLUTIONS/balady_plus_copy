import 'package:dgis_map/library.dart';

/// Object types for which the AI Summary card is allowed to render.
///
/// Anything outside this set must skip both the network fetch and the UI
/// section entirely. Per spec the allowed slugs are:
///
///   branch, parking, attraction, gate, station_platform, station, place
///
/// `place` maps to [ObjectTypeMessage.admDivPlace] — the only enum member
/// that represents a place administrative unit.
const aiSummaryAllowedObjectTypes = <ObjectTypeMessage>{
  ObjectTypeMessage.branch,
  ObjectTypeMessage.parking,
  ObjectTypeMessage.attraction,
  ObjectTypeMessage.gate,
  ObjectTypeMessage.station,
  ObjectTypeMessage.stationPlatform,
  ObjectTypeMessage.admDivPlace,
};

/// `true` if any of the POI's types is in [aiSummaryAllowedObjectTypes].
///
/// A POI can carry multiple object types (e.g. `[branch, station]`); the
/// section is shown when at least one of them is in scope — OR semantics.
bool isAiSummaryAllowed(Iterable<ObjectTypeMessage> types) => types.any(aiSummaryAllowedObjectTypes.contains);
