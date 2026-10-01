import 'package:dgis_map/library.dart';
import 'package:equatable/equatable.dart';
import 'package:mapness/entities/routing/route_search_point.dart';

class RouteParamsPoint extends Equatable {
  final double latitude;
  final double longitude;
  final int? objectId;
  final int? entranceId;
  final int? levelId;

  const RouteParamsPoint({
    required this.latitude,
    required this.longitude,
    this.objectId,
    this.entranceId,
    this.levelId,
  });

  @override
  List<Object?> get props => [
        latitude,
        longitude,
        objectId,
        entranceId,
        levelId,
      ];

  String latLngToString() => '$latitude,$longitude';
}

extension RouteParamsPointListX on List<RouteParamsPoint?> {
  RouteParamsPointList? getIntermediatePoints() => length > 2
      ? RouteParamsPointList(
          sublist(1, length - 1).nonNulls.map((e) => RouteParamsPointWithLabel(value: e, label: '')).toList(),
        )
      : null;

  String latLngToString() => '[${map((e) => e?.latLngToString()).join(',')}]';
}

class RouteParamsPointList extends Equatable {
  final List<RouteParamsPointWithLabel> points;

  const RouteParamsPointList(this.points);

  @override
  List<Object?> get props => [points];
}

class RouteParamsPointWithLabel extends Equatable {
  final String label;
  final RouteParamsPoint? value;

  const RouteParamsPointWithLabel({
    required this.value,
    required this.label,
  });

  RouteParamsPointWithLabel.fromDirectoryObject(DirectoryObjectMessage object)
      : this(
          value: RouteParamsPoint(
            latitude: object.markerPosition!.latitude,
            longitude: object.markerPosition!.longitude,
            objectId: object.id?.objectId,
            entranceId: object.id?.entranceId,
            levelId: object.levelId,
          ),
          label: object.title,
        );

  @override
  List<Object?> get props => [
        label,
        value,
      ];
}

extension RouteParamsPointWithLabelListX on List<RouteParamsPointWithLabel?> {
  RouteParamsPointList? getIntermediatePointsWithLabels() => length > 2
      ? RouteParamsPointList(
          sublist(1, length - 1).nonNulls.toList(),
        )
      : null;

  String latLngToString() => map((e) => e?.value).toList().latLngToString();
}

extension GeoPoint on RouteParamsPoint {
  GeoPointMessage get geoPoint => GeoPointMessage(
        latitude: latitude,
        longitude: longitude,
      );

  DgisObjectIdMessage? get dgisObjectId =>
      objectId != null ? DgisObjectIdMessage(objectId: objectId!, entranceId: entranceId ?? 0) : null;

  RouteEditorRoutePointMessage get pointMessage => RouteEditorRoutePointMessage(
        point: geoPoint,
        objectId: dgisObjectId,
        levelId: levelId,
      );
}
