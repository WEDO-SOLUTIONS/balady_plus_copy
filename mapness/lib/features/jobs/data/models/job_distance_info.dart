import 'package:dgis_map/library.dart';

class JobDistanceInfo {
  JobDistanceInfo({
    this.point,
    this.briefMessages,
    this.id,
  });
  final GeoPointMessage? point;
  final List<BriefRouteInfoMessage>? briefMessages;
  final DgisObjectIdMessage? id;
}
