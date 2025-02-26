import 'package:mapness/_generated/protocol/protocol.pb.dart' as proto;
import 'package:mapness/shared/entities/coordinates.dart';

extension PointMapper on proto.Point {
  static proto.Point fromDomain(Coordinates coordinates) => proto.Point(
        latitude: coordinates.latitude,
        longitude: coordinates.longitude,
      );

  Coordinates toDomain() => Coordinates(
        latitude: latitude,
        longitude: longitude,
      );
}
