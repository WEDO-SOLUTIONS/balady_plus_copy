import 'package:dgis_map/library.dart';

class JobDistanceInfo {
  final GeoPointMessage? point;
  final List<BriefRouteInfoMessage>? briefMessages;
  final DgisObjectIdMessage? id;

  JobDistanceInfo({
    this.point,
    this.briefMessages,
    this.id,
  });
}
